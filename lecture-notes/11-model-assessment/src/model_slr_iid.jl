using Random # random number generation tools
using DataFrames # dataframe structures
using CSVFiles # interface for working with CSV files
using Plots # plotting tools
using StatsBase # basic stats functions
using Optim # optimization tools
using Distributions # API for interacting with probability distributions
using StatsPlots # additional statistical plotting functions
using Turing

## load data files
slr_data = DataFrame(load("data/CSIRO_Recons_gmsl_yr_2015.csv"))
gmt_data = DataFrame(load("data/HadCRUT.5.0.1.0.analysis.summary_series.global.annual.csv"))
slr_data[:, :Time] = slr_data[:, :Time] .- 0.5; # remove 0.5 from Times
dat = leftjoin(slr_data, gmt_data, on="Time") # join data frames on time
select!(dat, [1, 2, 4])  # drop columns we don't need
rename!(dat, :Time => :year)
rename!(dat, :"GMSL (mm)" => :sealevels)
rename!(dat, :"Anomaly (deg C)" => :temp)

## plot data
@df dat scatter(:year, :sealevels, color=:black, label="Reconstructed Data", legend=:topleft, grid=false, xaxis="Year", yaxis="Sea Level Anomaly (mm)", tickfontsize=14, legendfontsize=12, guidefontsize=14)
savefig("figures/slr-data.svg")

## set up and calibrate models
function quadratic_slr(a, b, c, yrs)
    slr_predict = a .* (yrs .- yrs[1]).^2 .+ b .* (yrs .- yrs[1]) .+ c
    return slr_predict
end

function rahmstorf_slr(α, T₀, H₀, temps)
    temp_effect = α .* (temps .- T₀)
    slr_predict = cumsum(temp_effect) .+ H₀
    return slr_predict
end

# rahmstorf (2007) model with normal residuals
@model function rahmstorf_model(slr, temp)
    α ~ Normal(0, 10)
    H₀ ~ Normal(0, 100)
    T₀ ~ Normal(-50, 100)
    σ ~ truncated(Normal(0, 100); lower=0)

    model_out = rahmstorf_slr(α, H₀, T₀, temp)
    for i = 1:length(slr)
        slr[i] ~ Normal(model_out[i], σ)
    end
end

rmodel = rahmstorf_model(dat.sealevels, dat.temp)
rchain = sample(rmodel, NUTS(), 10000; drop_warmup=true, progress=true)

function simulate_rahmstorf_model(α, H₀, T₀, σ, temp)
    model_out = rahmstorf_slr(α, H₀, T₀, temp)
    err = rand(Normal(0, σ), length(temp))
    return model_out .+ err
end

function simulate_rahmstorf_slr(nsamp, chain, temp)
    idx = sample(1:length(chain), nsamp)
    α = Array(chain[:α])
    H₀ = Array(chain[:H₀])
    T₀ = Array(chain[:T₀])
    σ = Array(chain[:σ])
    y_pred = reduce(hcat, [simulate_rahmstorf_model(α[i], H₀[i], T₀[i], σ[i], temp) for i in idx])
    return y_pred
end

rahmstorf_pred = simulate_rahmstorf_slr(10000, rchain, dat.temp)
## compute quantiles
rahmstorf_quantiles = reduce(hcat, (x -> quantile(x, [0.025, 0.5, 0.975])).(eachrow(rahmstorf_pred)))

function surprise_index(data, quantiles)
    surprise = (data .> quantiles[2, :]) .|| (data .< quantiles[1, :])
    return sum(surprise) / length(data)
end

## plot 95% CIs
plot!(dat.year, rahmstorf_quantiles[2, :], color=:blue, label="Rahmstorf Model Median", legend=:topleft, grid=false, xaxis="Year", yaxis="Sea Level Anomaly (mm)", tickfontsize=14, legendfontsize=12, guidefontsize=14, linewidth=3)
plot!(dat.year, rahmstorf_quantiles[1, :], fillrange=rahmstorf_quantiles[3, :], color=:blue, alpha=0.2, label="Rahmstorf Model 95% CI")
@df dat scatter!(:year, :sealevels, color=:black, label="Reconstructed Data")
savefig("figures/slr-model-fit.svg")

## compute MAP and residuals
rahmstorf_map = optimize(rmodel, MAP())
a, b, c, σ_rahm = rahmstorf_map.values
rmap_residuals = rahmstorf_slr(a, b, c, dat.temp) .- dat.sealevels
histogram(rmap_residuals, xlabel="Residuals from MAP (mm)", label=false, tickfontsize=14, legendfontsize=12, guidefontsize=14)
savefig("figures/slr-residuals-map.svg")

rmap_pacf = pacf(rmap_residuals, 1:5)

function calculate_residual_pacf(nsamp, chain, sealevels, temps)
    idx = sample(1:length(chain), nsamp)
    α = Array(chain[:α])
    H₀ = Array(chain[:H₀])
    T₀ = Array(chain[:T₀])
    resid = [rahmstorf_slr(α[i], H₀[i], T₀[i], temps) .- sealevels for i in idx]
    partial_corr = reduce(hcat, [pacf(v, 1:5) for v in resid])
    return partial_corr
end

resids_pacf = calculate_residual_pacf(10000, rchain, dat.sealevels, dat.temp)
resids_quantile = reduce(hcat, (x -> quantile(x, [0.025, 0.975])).(eachrow(resids_pacf)))
resids_error⁻ = rmap_pacf .- resids_quantile[1, :]
resids_error⁺ = resids_quantile[2, :] .- rmap_pacf

scatter(rmap_pacf, linetype=:stem, yerror = (resids_error⁻, resids_error⁺), markersize=4, marker=:circle, markerstrokewidth=3, markeralpha=0.6, color=:red, xlabel="Lag", ylabel="Partial Autocorrelation", tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16, legendfontsize=14, legend=:false)
savefig("figures/slr-residual-pacf-err.svg")



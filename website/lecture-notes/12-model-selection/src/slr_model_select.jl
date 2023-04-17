using Random
using Plots
using Measures
using StatsBase
using StatsPlots
using Distributions
using Turing
using Optim
using CSVFiles
using DataFrames
using DataFramesMeta

## load data files
slr_data = DataFrame(load("data/CSIRO_Recons_gmsl_yr_2015.csv"))
gmt_data = DataFrame(load("data/HadCRUT.5.0.1.0.analysis.summary_series.global.annual.csv"))
slr_data[:, :Time] = slr_data[:, :Time] .- 0.5; # remove 0.5 from Times
dat = leftjoin(slr_data, gmt_data, on="Time") # join data frames on time
select!(dat, [1, 2, 4])  # drop columns we don't need
rename!(dat, :Time => :year)
rename!(dat, :"GMSL (mm)" => :sealevels)
rename!(dat, :"Anomaly (deg C)" => :temp)

function rahmstorf_slr(α, T₀, H₀, temps)
    temp_effect = α .* (temps .- T₀)
    slr_predict = cumsum(temp_effect) .+ H₀
    return slr_predict
end

## set up and calibrate models
function quadratic_slr(a, b, c, yrs)
    slr_predict = (a .* (yrs .- yrs[1]).^2) .+ (b .* (yrs .- yrs[1])) .+ c
    return slr_predict
end

# rahmstorf (2007) model with normal residuals
@model function quadratic_model(slr, yrs)
    a ~ Normal(0, 1)
    b ~ Normal(0, 10)
    c ~ Normal(-50, 100)
    σ ~ truncated(Normal(0, 10); lower=0)

    model_out = quadratic_slr(a, b, c, yrs)
    for i = 1:length(slr)
        slr[i] ~ Normal(model_out[i], σ)
    end
end

qmodel = quadratic_model(dat.sealevels, dat.year)
qmle = optimize(qmodel, MLE())
qchain = sample(qmodel, NUTS(), MCMCThreads(), 5000, 4; drop_warmup=true, progress=true)

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
rmle = optimize(rmodel, MLE())
rchain = sample(rmodel, NUTS(), MCMCThreads(), 5000, 4; drop_warmup=true, progress=true)


function compute_aic(mle_fit, num_params)
    lpd = mle_fit.lp - num_params
    return -2 * lpd
end

function compute_bic(mle_fit, num_params, num_data)
    lpd = mle_fit.lp - num_params
    return -2 * lpd
end


function compute_lp_quad(p, data)
    model_out = quadratic_slr(p[1:3]..., data.year)
    sum(logpdf.(Normal.(model_out, p[4]), data.sealevels))
end

function compute_lp_rahm(p, data)
    model_out = rahmstorf_slr(p[1:3]..., data.temp)
    sum(logpdf.(Normal.(model_out, p[4]), data.sealevels))
end

function compute_dic_v1(chain::Chains, data::DataFrame, lp_func::Function)
    pmean = mean(chain)[:, 2]
    lpd = lp_func(pmean, data)
    pdic = 2 * (lpd - mean(chain[:lp]))
    return -2 * (lpd - pdic)
end

function compute_dic_v2(chain::Chains, data::DataFrame, lp_func::Function)
    pmean = mean(chain)[:, 2]
    lpd = lp_func(pmean, data)
    pdic = 2 * var(chain[:lp])
    return -2 * (lpd - pdic)
end

## plot data
@df dat scatter(:year, :sealevels, color=:black, label="Reconstructed Data", legend=:topleft, grid=false, xaxis="Year", yaxis="Sea Level Anomaly (mm)", tickfontsize=14, legendfontsize=12, guidefontsize=14)
plot!(dat.year, quadratic_slr(qmle.values[1:3]..., dat.year), linewidth=3, label="Quadratic Model MLE Fit", color=:blue)
plot!(dat.year, rahmstorf_slr(rmle.values[1:3]..., dat.temp), linewidth=3, label="Rahmstorf Model MLE Fit", color=:magenta)
savefig("../figures/slr-mle-fit.svg")
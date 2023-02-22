using Plots
using Random
using StatsBase
using DataFrames
using CSVFiles
using Optim
using Distributions
using Measures
using StatsPlots

Random.seed!(1)

sl_dat = DataFrame(load(joinpath(@__DIR__, "..", "data", "CSIRO_Recons_gmsl_yr_2015.csv")))

function lik_quadratic(params; dat=sl_dat)
    a = params[1]
    b = params[2]
    c = params[3]
    t₀ = params[4]
    pred = a * (dat[:, 1] .- t₀).^2 .+ b * (dat[:, 1] .- t₀) .+ c
    residuals = dat[:, 2] .- pred
    rmse = sqrt.(mean(residuals.^2))
    return rmse
end

function sl_pred(params, yrs=sl_dat[:, 1])
    a = params[1]
    b = params[2]
    c = params[3]
    t₀ = params[4]
    pred = a * (yrs .- t₀).^2 .+ b * (yrs .- t₀) .+ c
    return pred
end

optim_out = optimize(lik_quadratic, [0.0, 0.0, -100.0, 1800.0], iterations=1000)

scatter(sl_dat[:, 1], sl_dat[:, 2], xlabel="Year", ylabel="GMSL (mm)", label="Sea-Level Data", tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16, legendfontsize=14)
plot!(sl_dat[:, 1], sl_pred(optim_out.minimizer), color=:red, label="Best-Fit Quadratic", linewidth=3)
savefig("../figures/slr-fit.svg")

resids = sl_dat[:, 2] - sl_pred(optim_out.minimizer)
plot(sl_dat[:, 1], resids, xlabel="Year", ylabel="Residual (mm)", tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16, legendfontsize=14, marker=:circle, legend=:false)
savefig("../figures/slr-residuals.svg")

plot(pacf(resids, 1:5), linetype=:stem, markersize=5, marker=:circle, xlabel="Lag", ylabel="Partial Autocorrelation", tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16, legendfontsize=14, legend=:false)
savefig("../figures/slr-pacf.svg")

ρ = pacf(resids, 1:2)[1]
σ² = var(resids) * (1+ ρ) / 2 

function gen_ar1_boot(ρ, σ², T, N)
    resids = zeros(T, N)
    resids[1, :] = rand(Normal(0, σ² / (1 + ρ)), N)
    wn_dist = Normal(0, σ²)
    for t = 2:T
        resids[t, :] = resids[1, :] .+ rand(wn_dist, N)
    end
    return resids
end

n_boot = 1000
pred = sl_pred(optim_out.minimizer)
boot_resids = gen_ar1_boot(ρ, σ², nrow(sl_dat), n_boot)
boot_slr = Matrix(mapcols(x -> x .+ pred, DataFrame(boot_resids, :auto)))'
boot_q = Matrix(mapcols(x -> quantile(x, [0.025, 0.975]), DataFrame(boot_slr, :auto)))'

plot(sl_dat[:, 1], boot_q[:, 1], fillrange=boot_q[:, 2], alpha=0.2, legend=:topleft, label="95% Bootstrap Interval", xlabel="Year", ylabel="GMSL (mm)", tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16, legendfontsize=14)
scatter!(sl_dat[:, 1], sl_dat[:, 2], label="Sea-Level Data", color=:black)
plot!(sl_dat[:, 1], sl_pred(optim_out.minimizer), color=:red, label="Best-Fit Quadratic", linewidth=3)
savefig("../figures/slr-boot-ci.svg")

plot(sl_dat[:, 1], boot_slr[1:5, :]', label=:false, xlabel="Year", ylabel="GMSL (mm)", tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16, legendfontsize=14)
scatter!(sl_dat[:, 1], sl_dat[:, 2], label="Sea-Level Data", color=:black)
savefig("../figures/slr-boot.svg")

boot_params = DataFrame(zeros(n_boot, 4), [:a, :b, :c, :t₀])
converged_flag = Array{Bool}(undef, n_boot)
for i = 1:nrow(boot_params)
    optim_boot = optimize(p -> lik_quadratic(p, dat=hcat(sl_dat[:, 1], boot_slr[i, :])), [0.0, 0.0, -200.0, 1800.0]; iterations=3000)
    converged_flag[i] = Optim.converged(optim_boot)
    boot_params[i, :] = optim_boot.minimizer
end

@df boot_params histogram(cols(1:4), layout=(2,2), tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16, legendfontsize=14, xlabel="Value", ylabel="Count")
vline!(optim_out.minimizer', color=:red, label=:false, linewidth=2)
plot!(size=(750, 375))
plot!(leftmargin=3mm, bottommargin=3mm)
savefig("../figures/slr-boot-hist.svg")

@df boot_params cornerplot(cols(1:4), compact=true)
plot!(size=(800, 375))
plot!(leftmargin=3mm, bottommargin=3mm)
savefig("../figures/slr-boot-corner.svg")

# plot projections
proj_yrs = collect(1700:2100)
boot_pred = DataFrame((p -> sl_pred(p, proj_yrs)).(eachcol(Matrix(boot_params))), :auto)
boot_pred_q = Matrix(mapcols(x -> quantile(x, [0.025, 0.975]), boot_pred))'
boot_pred_med = Matrix(mapcols(x -> quantile(x, [0.5]), boot_pred))'

plot(proj_yrs, boot_pred_q[:, 1], fillrange=boot_pred_q[:, 2], alpha=0.2, legend=:topleft, label="95% Bootstrap Interval", xlabel="Year", ylabel="GMSL (mm)", tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16, legendfontsize=14)
scatter!(sl_dat[:, 1], sl_dat[:, 2], label="Sea-Level Data", color=:black)
plot!(sl_dat[:, 1], sl_pred(optim_out.minimizer), color=:red, label="Best-Fit Quadratic", linewidth=3)

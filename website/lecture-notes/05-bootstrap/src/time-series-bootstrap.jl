using Plots
using Random
using StatsBase
using DataFrames
using CSVFiles

Random.seed!(1)

sl_dat = DataFrame(load(joinpath(@__DIR__, "..", "data", "CSIRO_Recons_gmsl_yr_2015.csv")))

plot(sl_dat[:, 1], sl_dat[:, 2], xlabel="Year", ylabel="GMSL (mm)", title="Sea-Level Rise Observations", label=:false, linewidth=2, tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16)
savefig("../figures/slr-plot.svg")

resample_index = sample(1:nrow(sl_dat), nrow(sl_dat); replace=true)

plot(sl_dat[:, 1], sl_dat[resample_index, 2], xlabel="Year", ylabel="GMSL (mm)", title="Sea-Level Rise Resample", label=:false, linewidth=2, tickfontsize=12, guidefontsize=14, titlefontsize=16, labelfontsize=16)
savefig("../figures/slr-resample.svg")

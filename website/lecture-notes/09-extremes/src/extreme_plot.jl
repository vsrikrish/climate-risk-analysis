using Distributions
using Plots
using StatsPlots
using StatsBase

xhi = quantile(Normal(0, 2), 0.975)
xlo = quantile(Normal(0, 2), 0.025)

plot(Normal(0, 2), label="Base", linewidth=2, color=:black, xticks=:false, yticks=:false, guidefontsize=14, legendfontsize=12)
plot!(Normal(0.5, 2), label="Shifted Mean", linewidth=2, color=:black, linestyle=:dash)
plot!(xhi:0.01:8, Normal(0, 2), color=:red, linewidth=0, fill=(0, 0.5, :red), label=false)
plot!(xhi:0.01:8, Normal(0.5, 2), color=:red, linewidth=0, fill=(0, 0.5, :red), label=false)
xlabel!("Variable")
savefig("../figures/extreme-shift.svg")

nsamples = 100000
xhi = quantile(Normal(0, 2), 0.99)
xbase = rand(Normal(0, 2), nsamples)
xshift = rand(Normal(0.5, 2), nsamples)
plot(sort(xbase), 1(nsamples:-1:1) ./ nsamples, label="Base", color=:black, linewidth=2, xticks=:false, guidefontsize=14, legendfontsize=12)
xlabel!("Variable")
xlims!((-7, 6))
ylims!((1/1000, 1))
plot!(sort(xshift), 1(nsamples:-1:1) ./ nsamples, color=:black, linestyle=:dash, linewidth=2, label="Shifted Mean")
yticks = [1, 1/10, 1/50, 1/100, 1/1000]
yaxis!("Exceedance Probability", yticks, :log, formatter=y -> string(round(y; digits=3)))
hline!([1-cdf(Normal(0, 2), xhi)], color=:red, label=:false)
hline!([1-cdf(Normal(0.5, 2), xhi)], color=:red, label=:false, linestyle=:dash, linewidth=2)
vline!([xhi], color=:blue, linewidth=2, label=:false)
yticks = [1, 1/10, 1/50, 1/100, 1/1000]
yaxis!("Exceedance Probability", yticks, :log, formatter=y -> string(round(y; digits=3)))
savefig("../figures/extreme-exceedprob.svg")

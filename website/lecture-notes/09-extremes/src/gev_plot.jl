using Plots
using StatsPlots
using LaTeXStrings

plot(-2:0.1:6, GeneralizedExtremeValue(0, 1, 0.5), linewidth=3, color=:red, label=L"$\xi = 1/2$", guidefontsize=14, legendfontsize=12, tickfontsize=12)
plot!(-4:0.1:6, GeneralizedExtremeValue(0, 1, 0), linewidth=3, color=:green, label=L"$\xi = 0$")
plot!(-4:0.1:2, GeneralizedExtremeValue(0, 1, -0.5), linewidth=3, color=:blue, label=L"$\xi = -1/2$")
scatter!((-2, 0), color=:red, label=:false)
scatter!((2, 0), color=:blue, label=:false)
ylabel!("Density")
xlabel!(L"$x$")
savefig("../figures/gev-shape.svg")
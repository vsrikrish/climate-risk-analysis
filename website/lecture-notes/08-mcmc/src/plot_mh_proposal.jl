using Plots
using Distributions
using StatsPlots
using QuadGK
using LaTeXStrings

# target density: modified Normal(0, 1) PDF
function target_distribution(x) 
    return sin(x)^2 * sin(2x)^2 * pdf(Normal(0, 1), x)
end

# compute normalizing constant for normalization
marg_dens, error = quadgk(x -> target_distribution(x), -Inf, Inf)
# plot target density
x = -π:0.01:π
p_base = plot(x, target_distribution.(x) ./ marg_dens, linewidth=3, label="Target D adjensity")
plot!(xlabel=L"x", ylabel="Density")
plot!(legendfontsize=12, tickfontsize=12, guidefontsize=14)
# pick current value
x_current = 0.5
vline!([x_current], color=:black, linewidth=1, label=L"$x_t$")
savefig("../figures/mh-example.svg")

# plot proposal distributions
plot!(deepcopy(p_base), x, pdf.(Normal(x_current, 0.1), x) ./ 10, color=:purple, label="Scaled Narrow Proposal", linewidth=2, linestyle=:dash)
savefig("../figures/mh-example-narrow.svg")
plot!(deepcopy(p_base), x, pdf.(Normal(x_current, 0.5), x) ./ 2, color=:red, label="Scaled Wide Proposal", linewidth=2, linestyle=:dash)
savefig("../figures/mh-example-wide.svg")


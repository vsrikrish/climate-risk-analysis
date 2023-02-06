import Pkg
Pkg.activate(dirname(dirname(@__DIR__)))
Pkg.instantiate()

# will be generating plots of utility functions
using Plots
using LaTeXStrings
using Statistics

# plot risk averse utility function
u_ra(x) = log(x-4) # risk-averse utility function
inv_u_ra(y) = 4 + exp(y)

plot(xsub, u_ra.(xsub), color=:black, linewidth=3, grid=:false, legend=:false, guidefontsize=18, tickfontsize=15, ylabel="Utility", xlabel="Bet Outcome")
xlims!((5.5, 15))
ylims!(u_ra.((5.5, 16.0)))
xt = [6.0, 10.0, 14.0]
yt = u_ra.(xt)
eu = mean(u_ra.([6, 14]))
ce = inv_u_ra(eu)
push!(yt, eu)
push!(xt, ce)
xticks!(xt, [L"$X-d$", L"$X$", L"$X+d$", L"CE"])
yticks!(yt, [L"$U(X-d)$", L"$U(X)$", L"$U(X+d)$", L"E(U)"])

plot!([ce, ce], [0, eu], color="#e1562c", linewidth=2, linestyle=:dash)
plot!([4, ce], [eu, eu], color=color="#e1562c", linewidth=2, linestyle=:dash)
scatter!([ce], [eu], color=color="#e1562c")

plot!([10, 10], [0, u_ra(10)], color="#537eff", linewidth=2, linestyle=:dash)
plot!([4, 10], [u_ra(10), u_ra(10)], color="#537eff", linewidth=2, linestyle=:dash)
scatter!([10], [u_ra(10)], color="#537eff")

plot!([10, ce], [0.75, 0.75], color=:black, linewidth=2)
annotate!(mean([10, ce]), 0.85, text("RP", :black, 12))
    
savefig(joinpath(dirname(@__DIR__), "figures/risk_averse.svg"))

## plot risk seeking utility function
u_rs(x) = exp(x / 5) # risk-seeking utility function
inv_u_rs(y) = 5*log(y)

plot(xsub, u_rs.(xsub), color=:black, linewidth=3, grid=:false, legend=:false, tickfontsize=15, guidefontsize=18, ylabel="Utility", xlabel="Bet Outcome")
xlims!((5, 15))
ylims!(u_rs.((5.0, 14.25)))
xt = [6.0, 10.0, 14.0]
yt = u_rs.(xt)
eu = mean(u_rs.([6, 14]))
ce = inv_u_rs(eu)
push!(yt, eu)
push!(xt, ce)
xticks!(xt, [L"$X-d$", L"$X$", L"$X+d$", L"CE"])
yticks!(yt, [L"$U(X-d)$", L"$U(X)$", L"$U(X+d)$", L"E(U)"])

plot!([ce, ce], [0, eu], color="#e1562c", linewidth=2, linestyle=:dash)
plot!([4, ce], [eu, eu], color=color="#e1562c", linewidth=2, linestyle=:dash)
scatter!([ce], [eu], color=color="#e1562c")

plot!([10, 10], [0, u_rs(10)], color="#537eff", linewidth=2, linestyle=:dash)
plot!([4, 10], [u_rs(10), u_rs(10)], color="#537eff", linewidth=2, linestyle=:dash)
scatter!([10], [u_rs(10)], color="#537eff")

plot!([10, ce], [4.2, 4.2], color=:black, linewidth=2)
annotate!(mean([10, ce]), 4.6, text("RP", :black, 12))
    
savefig(joinpath(dirname(@__DIR__), "figures/risk_seeking.svg"))


## plot risk-neutral utility function
u_rn(x) = x - 4 # risk-averse utility function
inv_u_rn(y) = 4 + y

plot(xsub, u_rn.(xsub), color=:black, linewidth=3, grid=:false, legend=:false, tickfontsize=15, guidefontsize=18, ylabel="Utility", xlabel="Bet Outcome")
xlims!((5, 15))
ylims!(u_rn.((5.0, 15.0)))
xt = [6.0, 10.0, 14.0]
yt = u_rn.(xt)
eu = mean(u_rn.([6, 14]))
ce = inv_u_rn(eu)
push!(yt, eu)
push!(xt, ce)
xticks!(xt, [L"$X-d$", L"$X$", L"$X+d$"])
yticks!(yt, [L"$U(X-d)$", L"$U(X)$", L"$U(X+d)$"])

plot!([10, 10], [0, u_rn(10)], color="#537eff", linewidth=2, linestyle=:dash)
plot!([4, 10], [u_rn(10), u_rn(10)], color="#537eff", linewidth=2, linestyle=:dash)
scatter!([10], [u_rn(10)], color="#537eff")
    
savefig(joinpath(dirname(@__DIR__), "figures/risk_neutral.svg"))


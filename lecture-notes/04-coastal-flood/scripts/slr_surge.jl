using Plots
using Distributions

elev = 10

surge_dist = Normal(6, 2)

surge = rand(surge_dist, 10000)

exceed_base = sum(surge .> elev) / 10000

exceed_slr = sum((surge .+ 1) .> elev) / 10000

plot(Normal(6, 2), label="Extreme Sea Level Without SLR", color=:black, xaxis=:false, yaxis=:false, grid=:false)
plot!(Normal(7, 2), label="Extreme Sea Levels With SLR", color=:red)
plot!(elev:0.01:maximum(surge), zeros(length(elev:0.01:maximum(surge))), fillrange=pdf.(Normal(6, 2), elev:0.01:maximum(surge)), 
fill=:black, alpha = 0.3, label="Exceedance Without SLR")
plot!(elev:0.01:maximum(surge)+1, zeros(length(elev:0.01:maximum(surge)+1)), fillrange=pdf.(Normal(7, 2), elev:0.01:maximum(surge)+1), 
fill=:red, alpha = 0.3, label="Exceedance With SLR")
vline!([elev], color=:blue, label=:false)
annotate!(elev+0.3, 0.15, text("Inundation Depth", :blue, 10, rotation=-90))

savefig("figures/slr_surge_tails.svg")
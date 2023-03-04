using Plots
using ColorSchemes

current = [1.0, 0.0, 0.0]
P = [1/2 1/4 1/4
    1/2 0 1/2
    1/4 1/4 1/2]   

T = 21

state_probs = zeros(T, 3)
state_probs[1,:] = current
for t=1:T-1
    state_probs[t+1, :] = state_probs[t:t, :] * P
end

vspan([0, 4], linecolor=:red, fillcolor=:red, alpha=0.2, label=:false)
plot!(0:T-1, state_probs, label=["Foggy" "Sunny" "Rainy"], palette=:mk_8, linewidth=2)
xlabel!("Time")
ylabel!("State Probability")
plot!(tickfontsize=12, guidefontsize=14, legendfontsize=14)
savefig("../figures/weather-markov.svg")
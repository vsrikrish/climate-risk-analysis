using Plots
using Distributions
using StatsPlots
using LaTeXStrings
using Measures
using Loess
using Random
using MCMCChains

Random.seed!(1)

function target_density(x) 
    return sin(x)^2 * sin(2x)^2 * pdf(Normal(0, 1), x)
end

function mh_transition(x_current, σ²)
    # generate new proposal
    x_proposal = rand(Normal(x_current, σ²))
    u = rand()
    ρ = log(target_density(x_proposal)) - log(target_density(x_current)) # transition log-probability
    if log(u) < min(ρ, 1)
        y = x_proposal
    else
        y = x_current
    end
    return y, log(target_density(y))
end

function mh_algorithm(n_iter, σ², x₀)
    samples = zeros(n_iter)
    log_target = zeros(n_iter)
    samples[1] = x₀
    log_target[1] = log(target_density(x₀))
    accept_count = 0
    for i = 2:length(samples) 
        samples[i], log_target[i] = mh_transition(samples[i-1], σ²)
        if samples[i] != samples[i-1]
            accept_count += 1
        end
    end
    accept_rate = accept_count / n_iter
    return samples, log_target, accept_rate
end

y_mid, logp_mid, α_mid = mh_algorithm(10000, 2, 0.25)
y_chain = Chains(y_mid, [:x])
ac_plot = autocorplot(y_chain, label="Goldilocks Proposal", legend=:topright)
ess_mid = Int(round(ess(y_chain)[:x, :ess]))
α_mid = round(α_mid * 100; digits=1)
p_mid = plot(y_chain, top_margin=-10mm, title="")

y_wide, logp_wide, α_wide = mh_algorithm(10000, 20, 0.25)
y_chain = Chains(y_wide, [:x])
autocorplot!(ac_plot, y_chain, label="Too-Wide Proposal", legend=:topright)
ess_wide = Int(round(ess(y_chain)[:x, :ess]))
α_wide = round(α_wide * 100; digits=1)
p_wide = plot(y_chain, top_margin=-10mm, title="")

y_narrow, logp_narrow, α_narrow = mh_algorithm(10000, 0.05, 0.25)
y_chain = Chains(y_narrow, [:x])
autocorplot!(ac_plot, y_chain, label="Too-Narrow Proposal", legend=:topright)
ess_narrow = Int(round(ess(y_chain)[:x, :ess]))
α_narrow = round(α_narrow * 100; digits=1)
p_narrow = plot(y_chain, top_margin=-10mm, title="")

savefig(ac_plot, "../figures/mh-acplot.svg")

l = @layout [
    a{0.005h};
    b{0.33h};
    c{0.005h};
    d{0.33h};
    e{0.005h};
    f{0.33h}
]

plot_title(title) = plot(title = title, grid = false, showaxis = false, bottom_margin = -30mm)

p_all = plot(plot_title("Too-Narrow Proposal, ESS: $ess_narrow, Accept Rate= $α_narrow%"),
 p_narrow,
 plot_title("Goldilocks Proposal, ESS: $ess_mid, Accept Rate= $α_mid%"),
 p_mid,  
 plot_title("Too-Wide Proposal, ESS: $ess_wide, Accept Rate= $α_wide%"), 
 p_wide,
 layout=l)
plot!(size=(1600, 800))
plot!(left_margin=6mm, bottom_margin=4mm)

savefig("../figures/mcmc-trace.svg")


# plot ESS by proposal variance

vars = 0.01:0.01:20
ess_out = zeros(length(vars))
acc_rate = zeros(length(vars))
for (i, v) in enumerate(vars)
    y, logp, α = mh_algorithm(10000, v, 0.25)
    y_chain = Chains(y, [:x])
    ess_out[i] = ess(y_chain)[:x, :ess]
    acc_rate[i] = α * 100
end
scatter(vars, ess_out, marker=(:circle, 3, :black, :white), label="ESS", legend=:topright)
ess_model = loess(vars, ess_out, span=0.2);
ess_pred = predict(ess_model, vars);
plot!(vars, ess_pred, color=:red, label="LOESS Curve", linewidth=3)
ylims!((0, 1800))
xlabel!("Variance of Proposal Distribution")
ylabel!(L"Effective Sample Size ($N=10,000$)")
savefig("../figures/mcmc-ess.svg")

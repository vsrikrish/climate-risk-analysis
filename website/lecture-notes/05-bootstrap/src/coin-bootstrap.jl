using Distributions
using Plots
using Random
using StatsBase

cd(@__DIR__)

Random.seed!(1)

# define coin-flip model
p_true = 0.6
n_flips = 20
coin_dist = Bernoulli(p_true)
# generate data set
dat = rand(coin_dist, n_flips)
freq_dat = sum(dat) / length(dat)

# bootstrap
function coin_boot_sample(dat)
    boot_sample = sample(dat, length(dat); replace=true)
    freq = sum(boot_sample) / length(dat)
    return freq
end

n_boot = 1000
boot_freq = [coin_boot_sample(dat) for i in 1:n_boot]
histogram(boot_freq, label="Bootstrap Estimates", xlabel="Proportion of Heads", ylabel="Count", color=:white)
vline!([p_true], color=:red, linestyle=:dash, label="True Value", linewidth=2)
vline!([freq_dat], color=:red, linestyle=:solid, label="Sample Estimate", linewidth=2)
vline!([0.5], color=:purple, linestyle=:dash, label="Fair Value", linewidth=2)
savefig("../figures/coin-bootstrap-small.svg")

# larger experiment
n_flips = 50
dat = rand(coin_dist, n_flips)
freq_dat = sum(dat) / length(dat)

n_boot = 1000
boot_freq = [coin_boot_sample(dat) for i in 1:n_boot]
histogram(boot_freq, label="Bootstrap Estimates", xlabel="Proportion of Heads", ylabel="Count", color=:white)
vline!([p_true], color=:red, linestyle=:dash, label="True Value", linewidth=2)
vline!([freq_dat], color=:red, linestyle=:solid, label="Sample Estimate", linewidth=2)
vline!([0.5], color=:purple, linestyle=:dash, label="Fair Value", linewidth=2)
savefig("../figures/coin-bootstrap-large.svg")

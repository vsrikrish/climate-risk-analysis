using Plots
using Distributions
using Random
using Turing
using LaTeXStrings

Random.seed!(1)

true_f(x) = sin(x/2 + π/4) - sin(x/4 - π/2) + 4
x = 10*rand(25)
y = true_f.(x) .+ rand(Normal(0, 1), 25)

@model function linear_model(y, x) 
    a ~ Normal(0, 2)
    b ~ Normal(3, 2)
    σ ~ truncated(Normal(0, 5); lower=0)

    μ = a * x .+ b
    for i = 1:length(x)
        y[i] ~ Normal(μ[i], σ)
    end
    return y
end

linear_chain = sample(linear_model(y, x), NUTS(), 5000; drop_warmup=true)

@model function cubic_model(y, x) 
    a ~ Normal(0, 2)
    b ~ Normal(0, 2)
    c ~ Normal(0, 2)
    d ~ Normal(0, 2)
    σ ~ truncated(Normal(0, 5); lower=0)

    μ = a * x.^3 .+ b * x.^2 .+ c * x .+ d
    for i = 1:length(x)
        y[i] ~ Normal(μ[i], σ)
    end
    return y
end

cubic_chain = sample(cubic_model(y, x), NUTS(), 5000; drop_warmup=true)

@model function septic_model(y, x) 
    a ~ Normal(0, 2)
    b ~ Normal(0, 2)
    c ~ Normal(0, 2)
    d ~ Normal(0, 2)
    e ~ Normal(0, 2)
    f ~ Normal(0, 2)
    g ~ Normal(0, 2)
    h ~ Normal(0, 2)
    σ ~ truncated(Normal(0, 5); lower=0)

    μ = a * x.^7 .+ b * x.^6 .+ c * x.^5 .+ d * x.^4 .+ e * x.^3 .+ f  * x.^2 .+ g * x .+ h
    for i = 1:length(x)
        y[i] ~ Normal(μ[i], σ)
    end
end

septic_chain = sample(septic_model(y, x), NUTS(), 20000; drop_warmup=true)


x_pred = collect(0:0.01:10)
linear_pred = predict(linear_model(Vector{Union{Missing, Float64}}(undef, length(x_pred)), x_pred), linear_chain)
linear_quantile = mapslices(v -> quantile(v, [0.025, 0.5, 0.975]), Array(group(linear_pred, :y)); dims=1)

cubic_pred = predict(cubic_model(Vector{Union{Missing, Float64}}(undef, length(x_pred)), x_pred), cubic_chain)
cubic_quantile = mapslices(v -> quantile(v, [0.025, 0.5, 0.975]), Array(group(cubic_pred, :y)); dims=1)

quintic_pred = predict(quintic_model(Vector{Union{Missing, Float64}}(undef, length(x_pred)), x_pred), quintic_chain)
quintic_quantile = mapslices(v -> quantile(v, [0.025, 0.5, 0.975]), Array(group(quintic_pred, :y)); dims=1)

scatter(x, y, color=:black, markersize=5, label="Data", tickfontsize=14, legendfontsize=12, guidefontsize=14, xlabel=L"x", ylabel=L"y")
plot!(x_pred, true_f.(x_pred), color=:black, label="True Model", linewidth=3)
plot!(x_pred, linear_quantile[2, :], color=:red, ribbon=(linear_quantile[2, :] .- linear_quantile[1, :], linear_quantile[3, :] .- linear_quantile[2, :]), label="Linear Model", fillalpha=0.3, linewidth=3)
plot!(x_pred, cubic_quantile[2, :], color=:magenta, ribbon=(cubic_quantile[2, :] .- cubic_quantile[1, :], cubic_quantile[3, :] .- cubic_quantile[2, :]), label="Cubic Model", fillalpha=0.3, linewidth=3)
plot!(x_pred, quintic_quantile[2, :], color=:green, ribbon=(quintic_quantile[2, :] .- quintic_quantile[1, :], quintic_quantile[3, :] .- quintic_quantile[2, :]), label="Quintic Model", fillalpha=0.3, linewidth=3)
savefig("../figures/bias-variance-complexity.png")
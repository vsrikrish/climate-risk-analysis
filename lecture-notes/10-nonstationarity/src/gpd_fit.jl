using Plots
using CSV
using DataFrames
using DataFramesMeta
using Dates
using Turing
using Optim
using StatsPlots
using Measures

function load_data(fname)
    date_format = DateFormat("yyyy-mm-dd HH:MM:SS")
    # This uses the DataFramesMeta.jl package, which makes it easy to string together commands to load and process data
    df = @chain fname begin
        CSV.File(; header=false)
        DataFrame
        rename("Column1" => "year", "Column2" => "month", "Column3" => "day", "Column4" => "hour", "Column5" => "gauge")
        # need to reformat the decimal date in the data file
        @transform :datetime = DateTime.(:year, :month, :day, :hour)
        # replace -99999 with missing
        @transform :gauge = ifelse.(abs.(:gauge) .>= 9999, missing, :gauge)
        select(:datetime, :gauge)
    end
    return df
end

dat = load_data("../data/h551.csv")

ma_length = 366
ma_offset = Int(floor(ma_length/2))
moving_average(series,n) = [mean(@view series[i-n:i+n]) for i in n+1:length(series)-n]
dat_ma = DataFrame(datetime=dat.datetime[ma_offset+1:end-ma_offset], residual=dat.gauge[ma_offset+1:end-ma_offset] .- moving_average(dat.gauge, ma_offset))

threshold = 1000 # set your own threshold here

dat_exceed = dat_ma[dat_ma.residual .> threshold, :]

function assign_cluster(dat, period)
    cluster_index = 1
    clusters = zeros(Int, length(dat))
    for i in 1:length(dat)
        if clusters[i] == 0
            clusters[findall(abs.(dat .- dat[i]) .<= period)] .= cluster_index
            cluster_index += 1
        end
    end
    return clusters
end

dat_exceed = @transform dat_exceed :cluster = assign_cluster(:datetime, Dates.Day(3))
dat_decluster = combine(dat_exceed -> dat_exceed[argmax(dat_exceed.residual), :], groupby(dat_exceed, :cluster))

dat_decluster = @transform dat_decluster :year = Dates.year.(dat_decluster.datetime) 
counts = combine(groupby(dat_decluster, :year), nrow => :count)
delete!(counts, nrow(counts)) # including 2023 will bias the count estimate

@model function gp_pot_ns(y, counts)
    ## priors
    λ_0 ~ Gamma(1, 1) # poisson rate (number of exceedances/yr)
    σ ~ truncated(Normal(0, 100); lower=0) # Generalized Pareto scale
    ξ ~ Normal(0, 1) # Generalized Pareto shape

    ## likelihood
    counts ~ Poisson(λ)
    y ~ GeneralizedPareto(σ, ξ)
end

chain_ns = sample(gev_annmax_ns(dat_annmax.residual), NUTS(), MCMCThreads(), 5000, 4; drop_warmup=true)


@model function gp_pot_st(y, counts)
    ## priors
    λ ~ Gamma(1, 1) # poisson rate (number of exceedances/yr)
    σ ~ truncated(Normal(0, 100); lower=0) # Generalized Pareto scale
    ξ ~ Normal(0, 1) # Generalized Pareto shape

    ## likelihood
    counts ~ Poisson(λ)
    y ~ GeneralizedPareto(σ, ξ)
end

chain_st = sample(gp_pot_st(dat_annmax.residual), NUTS(), MCMCThreads(), 5000, 4; drop_warmup=true)

rl_st = mapslices(p -> quantile(GeneralizedExtremeValue(p[3], p[1], p[2]), 0.99), Array(chain_st); dims=2)

rl_ns = mapslices(p -> quantile(GeneralizedExtremeValue(p[3] + p[4] * (2023-1894), p[1], p[2]), 0.99), Array(chain_ns); dims=2)


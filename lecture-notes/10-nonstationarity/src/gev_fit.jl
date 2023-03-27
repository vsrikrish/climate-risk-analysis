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

dat_ma = dropmissing(dat_ma) # drop missing data
dat_annmax = combine(dat_ma -> dat_ma[argmax(dat_ma.residual), :], groupby(transform(dat_ma, :datetime => x->year.(x)), :datetime_function))
delete!(dat_annmax, nrow(dat_annmax)) # delete 2023; haven't seen much of that year yet

@model function gev_annmax_ns(y)
    ## pick priors
    σ ~ truncated(Normal(0, 100); lower=0) # scale
    ξ ~ Normal(0, 0.5) # shape; pay special attention to this one, and you may need to experiment
    β₀ ~ Normal(1000, 100)
    β₁ ~ Normal(0, 10)

    ## likelihood
    μ = β₀ .+ β₁ * collect(1:length(y))
    y .~ GeneralizedExtremeValue.(μ, σ, ξ)
end

chain_ns = sample(gev_annmax_ns(dat_annmax.residual), NUTS(), MCMCThreads(), 5000, 4; drop_warmup=true)


@model function gev_annmax_st(y)
    ## pick priors
    σ ~ truncated(Normal(0, 100); lower=0) # scale
    ξ ~ Normal(0, 0.5) # shape; pay special attention to this one, and you may need to experiment
    μ ~ Normal(1000, 100)

    ## likelihood
    y ~ GeneralizedExtremeValue(μ, σ, ξ)
end

chain_st = sample(gev_annmax_st(dat_annmax.residual), NUTS(), MCMCThreads(), 5000, 4; drop_warmup=true)

rl_st = mapslices(p -> quantile(GeneralizedExtremeValue(p[3], p[1], p[2]), 0.99), Array(chain_st); dims=2)

rl_ns = mapslices(p -> quantile(GeneralizedExtremeValue(p[3] + p[4] * (2023-1894), p[1], p[2]), 0.99), Array(chain_ns); dims=2)


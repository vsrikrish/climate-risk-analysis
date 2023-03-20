using Plots
using StatsPlots
using LaTeXStrings
using Dates

# load and decluster data
function load_data(fname)
    date_format = "yyyy-mm-dd HH:MM"
    # this uses the DataFramesMeta package -- it's pretty cool
    return @chain fname begin
        CSV.File(; dateformat=date_format)
        DataFrame
        rename(
            "Time (GMT)" => "time", "Predicted (m)" => "harmonic", "Verified (m)" => "gauge"
        )
        @transform :datetime = (Date.(:Date, "yyyy/mm/dd") + Time.(:time))
        select(:datetime, :gauge, :harmonic)
        @transform :weather = :gauge - :harmonic
        @transform :month = (month.(:datetime))
    end
end

dat = load_data("../data/norfolk-hourly-surge-2015.csv")
dat = @transform dat :cluster = floor.(:datetime, Dates.Day(3))
max_dat = combine(dat -> dat[argmax(dat.weather), :], groupby(dat, :cluster))

plot(0:0.1:6, GeneralizedPareto(0, 1, 1/2), linewidth=3, color=:red, label=L"$\xi = 1/2$", guidefontsize=14, legendfontsize=12, tickfontsize=12)
plot!(0:0.1:6, GeneralizedPareto(0, 1, 0), linewidth=3, color=:green, label=L"$\xi = 0$")
plot!(0:0.1:2, GeneralizedPareto(0, 1, -1/2), linewidth=3, color=:blue, label=L"$\xi = -1/2$")
scatter!((2, 0), color=:blue, label=:false)
ylabel!("Density")
xlabel!(L"$x$")
savefig("../figures/gpd-shape.svg")
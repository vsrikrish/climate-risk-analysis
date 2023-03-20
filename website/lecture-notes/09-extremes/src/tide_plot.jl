using Plots
using CSV
using DataFrames
using DataFramesMeta
using Dates

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

plot(dat.datetime, dat.gauge; ylabel="Gauge [m]", label="Observed", legend=:topleft, tickfontsize=12, guidefontsize=14, legendfontsize=12, xlabel="Date/Time")
plot!(dat.datetime, dat.harmonic; label="Predicted Harmonics", alpha=0.7)
savefig("../figures/gauge-data.svg")

plot(dat.datetime, dat.weather; ylabel="Gauge Weather Variability (m)", label="Observations", legend=:topleft, tickfontsize=12, guidefontsize=14, legendfontsize=12, xlabel="Date/Time")
max_dat = combine(dat -> dat[argmax(dat.weather), :], groupby(transform(dat, :datetime => x->yearmonth.(x)), :datetime_function))
scatter!(max_dat.datetime, max_dat.weather, label="Monthly Maxima")
month_start = collect(Date(2015, 01, 01):Dates.Month(1):Date(2015, 12, 01))
vline!(DateTime.(month_start), color=:black, label=:false, linestyle=:dash)
savefig("../figures/gauge-maxima.svg")

thresh = 0.5
plot(dat.datetime, dat.weather; ylabel="Gauge Weather Variability (m)", label="Observations", legend=:top, tickfontsize=12, guidefontsize=14, legendfontsize=12, xlabel="Date/Time")
hline!([thresh], color=:red, linestyle=:dash, label="Threshold")
scatter!(dat.datetime[dat.weather .> thresh], dat.weather[dat.weather .> thresh], markershape=:x, color=:black, markersize=3, label="Exceedances")
savefig("../figures/gauge-peaks.svg")
md"""
## Overview

This tutorial will give some examples of plotting and plotting features in Julia, as well as providing references to some relevant resources. The main plotting library is `Plots.jl`, but there are some others that provide useful features.

## Some Resources

* `Plots.jl` [useful tips](https://docs.juliaplots.org/latest/basics/#Useful-Tips)
* `Plots.jl` [examples](https://docs.juliaplots.org/latest/generated/gr/)
* [Plot attributes](http://docs.juliaplots.org/latest/generated/attributes_plot/)
* [Axis attributes](http://docs.juliaplots.org/latest/generated/attributes_axis/#Axis)
* [Color names](http://juliagraphics.github.io/Colors.jl/stable/namedcolors/)
"""

#nb # ## Packages
#nb #
#nb # To run this notebook, you can download or view the [`Project.toml`](https://raw.githubusercontent.com/vsrikrish/climate-risk-analysis/gh-pages/tutorials/notebooks/julia-plots/Project.toml) and [`Manifest.toml`](https://raw.githubusercontent.com/vsrikrish/climate-risk-analysis/gh-pages/tutorials/notebooks/julia-plots/Manifest.toml). You can also just add packages as needed to the environment, which is by default set to exist in the path of the notebook file.


using Pkg
#md Pkg.activate("_literate/julia-plots")
#nb Pkg.activate(@__DIR__)
Pkg.instantiate()
#md macro OUTPUT() #hide
#md     return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/" #hide
#md end; #hide

# ## Demos

using Plots
using Random # hide
Random.seed!(1) # hide

# ### Line Plots
# To generate a basic line plot, use `plot`.

y = rand(5)
plot(y, label="original data", legend=:topright)
#md savefig(joinpath(@OUTPUT, "line-plot.png")) #hide

#md # \fig{line-plot.png}

# There's a lot of customization here that can occur, a lot of which is discussed in the docs or can be found with some Googling.

# #### Adding Plot Elements
# 
# Now we can add some other lines and point markers. 

y2 = rand(5)
y3 = rand(5)
plot!(y2, label="new data")
scatter!(y3, label="even more data")
#md savefig(joinpath(@OUTPUT, "line-plot-added.png")) #hide

#md # \fig{line-plot-added.png}

# Remember that an exclamation mark (!) at the end of a function name means that function modifies an object in-place, so `plot!` and `scatter!` modify the current plotting object, they don't create a new plot.

# #### Removing Plot Elements
# 
# Sometimes we want to remove legends, axes, grid lines, and ticks.

plot!(legend=false, axis=false, grid=false, ticks=false)
#md savefig(joinpath(@OUTPUT, "line-plot-removed.png")) #hide

#md # \fig{line-plot-removed.png}

# #### Aspect Ratio
# 
# If we want to have a square aspect ratio, use `ratio = 1`.

v = rand(5)
plot(v, ratio=1, legend=false)
scatter!(v)
#md savefig(joinpath(@OUTPUT, "square-aspect.png")) #hide

#md # \fig{square-aspect.png}

# ### Heatmaps
 
# A heatmap is effectively a plotted matrix with colors chosen according to the values. Use `clim` to specify a fixed range for the color limits.

A = rand(10, 10)
heatmap(A, clim=(0, 1), ratio=1, legend=false, axis=false, ticks=false)
#md savefig(joinpath(@OUTPUT, "heatmap-basic.png")) #hide

#md # \fig{heatmap-basic.png}

M = [ 0 1 0; 0 0 0; 1 0 0]
whiteblack = [RGBA(1,1,1,0), RGB(0,0,0)]
heatmap(c=whiteblack, M, aspect_ratio = 1, ticks=.5:3.5, lims=(.5,3.5), gridalpha=1, legend=false, axis=false, ylabel="i", xlabel="j")
#md savefig(joinpath(@OUTPUT, "heatmap-bw.png")) #hide

#md # \fig{heatmap-bw.png}

# #### Custom Colors

using Colors

mycolors = [colorant"lightslateblue",colorant"limegreen",colorant"red"]
A = [i for i=50:300, j=1:100]
heatmap(A, c=mycolors, clim=(1,300))
#md savefig(joinpath(@OUTPUT, "heatmap-colors.png")) #hide

#md # \fig{heatmap-colors.png}

# ### Plotting Areas Under Curves

y = rand(10)
plot(y, fillrange= y.*0 .+ .5, label= "above/below 1/2", legend =:top)
#md savefig(joinpath(@OUTPUT, "above-below.png")) #hide

#md # \fig{above-below.png}

x = LinRange(0,2,100)
y1 = exp.(x)
y2 = exp.(1.3 .* x)
plot(x, y1, fillrange = y2, fillalpha = 0.35, c = 1, label = "Confidence band", legend = :topleft)
#md savefig(joinpath(@OUTPUT, "confidence.png")) #hide

#md # \fig{confidence.png}

x = -3:.01:3
areaplot(x, exp.(-x.^2/2)/√(2π),alpha=.25,legend=false)
#md savefig(joinpath(@OUTPUT, "normal-area.png")) #hide

#md # \fig{normal-area.png}

M = [1 2 3; 7 8 9; 4 5 6; 0 .5 1.5]
areaplot(1:3, M, seriescolor = [:red :green :blue ], fillalpha = [0.2 0.3 0.4])
#md savefig(joinpath(@OUTPUT, "area-colored.png")) #hide

#md # \fig{area-colored.png}

using SpecialFunctions
f = x->exp(-x^2/2)/√(2π)
δ = .01
plot()
x = √2 .* erfinv.(2 .*(δ/2 : δ : 1) .- 1)
areaplot(x, f.(x), seriescolor=[ :red,:blue], legend=false)
plot!(x, f.(x),c=:black)
#md savefig(joinpath(@OUTPUT, "normal-quantiles.png")) #hide

#md # \fig{normal-quantiles.png}

# ### Plotting Shapes

rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])
circle(r,x,y) = (θ = LinRange(0,2π,500); (x.+r.*cos.(θ), y.+r.*sin.(θ)))
plot(circle(5,0,0), ratio=1, c=:red, fill=true)
plot!(rectangle(5*√2,5*√2,-2.5*√2,-2.5*√2),c=:white,fill=true,legend=false)
#md savefig(joinpath(@OUTPUT, "circle-rect.png")) #hide

#md # \fig{circle-rect.png}

# ### Plotting Distributions

# The [`StatsPlots.jl`](https://github.com/JuliaPlots/StatsPlots.jl/blob/master/README.md) package is very useful for making various plots of probability distributions.

using Distributions, StatsPlots
plot(Normal(2, 5))
#md savefig(joinpath(@OUTPUT, "normal-pdf.png")) # hide

#md # \fig{normal-pdf.png}

scatter(LogNormal(0.8, 1.5))
#md savefig(joinpath(@OUTPUT, "lognormal-scatter.png")) # hide

#md # \fig{lognormal-scatter.png}

# We can also use this functionality to plot distributions of data in tabular data structures like `DataFrames`.

using DataFrames
dat = DataFrame(a = 1:10, b = 10 .+ rand(10), c = 10 .* rand(10))
@df dat density([:b :c], color=[:black :red])
#md savefig(joinpath(@OUTPUT, "dataframe-dist.png")) #hide

#md # \fig{dataframe-dist.png}

# ### Editing Plots Manually

pl = plot(1:4,[1, 4, 9, 16])
#md savefig(joinpath(@OUTPUT, "basic-plot.png")) #hide

#md # \fig{basic-plot.png}

pl.attr
#-
pl.series_list[1]
#-
pl[:size]=(300,200)
#-
pl
#md savefig(joinpath(@OUTPUT, "basic-size.png")) #hide

#md # \fig{basic-size.png}

# ### Log-Scaled Axes

xx = .1:.1:10
plot(xx.^2, xaxis=:log, yaxis=:log)
#md savefig(joinpath(@OUTPUT, "log-axes.png")) #hide

#md # \fig{log-axes.png}

plot(exp.(x), yaxis=:log)
#md savefig(joinpath(@OUTPUT, "log-exp.png")) #hide

#md # \fig{log-exp.png}

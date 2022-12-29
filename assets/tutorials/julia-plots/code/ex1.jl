# This file was generated, do not modify it. # hide
using Pkg
Pkg.activate("_literate/julia-plots")
Pkg.instantiate()
macro OUTPUT() # hide
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/" # hide
end; # hide
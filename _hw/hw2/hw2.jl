#nb # # Homework 2, BEE 6940 (Due By 2/23/23, 9:00PM)

#nb # **Name**:
#nb #
#nb # **ID**:

# ## Overview

# ### Instructions
#
# - Problem 1 asks you to use `Optimize.optim()` to calibrate a semi-empirical sea-level rise model to temperature and sea-level data. 
# - Problem 2 asks you to use SNEASY, a Simple Nonlinear EArth SYstem model, to propagate climate-system uncertainty through to sea-level rise.

#nb # ### Load Environment
#nb #
#nb # The following code loads the environment and makes sure all needed packages are installed. This should be at the start of most Julia scripts.

#nb import Pkg
#nb Pkg.activate(@__DIR__)
#nb Pkg.instantiate()

# ## Problems (Total: 100 Points)

# ### Problem 1 (60 points)
#
# In this problem, we will work with the semi-empirical sea-level model from [Rahmstorf (2007)](https://doi.org/10.1073/pnas.0907765106). This model links global mean temperature $T(t)$ to global mean sea-level $H(t)$ through the equation:
#
# $$\frac{dH(t)}{dt} = \alpha (T(t) - T_0),$$
#
# where $T_0$ is the temperature (in $^\circ C$) where sea-level is in equilibrium ($dH/dt = 0$), and $\alpha$ is the sea-level rise sensitivity to temperature. Discretizing this equation using the Euler method and using an annual timestep ($\delta t = 1$), we get
#
# $$H(t+1) = H(t) + \alpha (T(t) - T_0).$$
#
# Our goal in this problem is to load temperature and sea-level datasets and *calibrate* the model by finding parameter values which are consistent with historical observations. We will select parameters which minimize the root-mean-square-error (RMSE) of the data-model residuals. The following function can be used to compute the RMSE.

using Statistics

rmse(y, ŷ) = sqrt(mean((y - ŷ).^2))

# #### Problem 1.1 (15 points)
#
# Load the sea-level and temperature datasets into `DataFrame`s. The sea-level dataset is provided in `data/CSIRO_Recons_gmsl_yr_2015.csv`, and the temperature dataset is provided in `data/HadCRUT.5.0.1.0.analysis.summary_series.global.annual.csv`. You'll need to correct the years in the sea-level rise data to remove the half-year, and then align the two data sets on the common period 1880 &ndash; 2013. Plot each of the resulting data sets after this "cleaning" process on different axes.

# #### Problem 1.2 (30 points)

# Write a function for the above model, and find the parameter values which minimize the RMSE using `Optim.optimize()` (here is [documentation on how to use `Optim.optimize()` to minimize a function](https://julianlsolvers.github.io/Optim.jl/v0.9.3/user/minimization/). This will involve writing a function which takes in a vector of parameter values and the data, simulates the model, and computes the RMSE. `Optim.optimize()` maps a parameter vector to a function, and since you'll be passing auxiliary data to your function, you may want to use anonymous function to wrap your simulation function, as in
#
# ```julia
# optimize(p -> f(p, aux), ...)
# ```

# #### Problem 1.3 (15 points)
#
# Plot the sea-level data as points, and overlay a line with the model hindcast. How well do you think the model fits the data? Are there any key trends or features that you notice?

# ### Problem 2 (40 points)
#
# Your goal in this problem is to see how scenario and parametric uncertainty in climate models propagates through the simple semi-empirical sea-level model from Problem 1. You'll be using SNEASY, and we have provided the same set of functions in `src/sneasy_model_functions.jl` that you used in Lab 3.

# #### Problem 2.1 (10 points)
#
# Use 1000 samples from the parameter set for MimiSNEASY (found in `params/parameters_subsample_sneasybrick.csv`) to compute and plot 95% uncertainty intervals for global mean temperatures from 1880 &ndash; 2100 for RCPs 2.6, 4.5, 6.0, and 8.5. 

# #### Problem 2.2 (10 points)
#
# Run your calibrated model from Problem 1 on the ensemble of temperatures for each RCP from Problem 2.1. Plot the 95% uncertainty intervals and the median trajectory from 1880 & ndash;.

# #### Problem 2.3 (10 points)
#
# Use [`Plots.density()`](https://docs.juliaplots.org/latest/api/#Plots.density!-Tuple) to plot the distribution of global mean sea levels in 2100 for each RCP (put these density plots on the same axes for easier comparison).

# #### Problem 2.4 (10 points)
#
# What do you notice about the contributions of parametric and scenario uncertainty to the variability in sea levels over the rest of the century? Are there any interesting trends? 

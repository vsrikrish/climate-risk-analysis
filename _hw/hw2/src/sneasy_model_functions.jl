using Mimi
using MimiSNEASY
using DataFrames
using CSVFiles
using Statistics

"""
    create_sneasy_model(; rcp_scenario="RCP85", start_year=1765, end_year=2100)

Create a MimiSNEASY model instance corresponding to `rcp_scenario` which will run from `start_year` to `end_year`

"""
function create_sneasy_model(; rcp_scenario="RCP85", start_year=1765, end_year=2100)
    # find indices for years
    model_years = collect(start_year:end_year)
    rcp_indices = findall((in)(model_years), 1765:2500)

    # Load emissions and forcing data (index into appropriate years).
    rcp_emissions      = DataFrame(load(joinpath(@__DIR__, "..", "data", rcp_scenario*"_emissions.csv"), skiplines_begin=36))
    rcp_concentrations = DataFrame(load(joinpath(@__DIR__, "..", "data", rcp_scenario*"_concentrations.csv"), skiplines_begin=37))
    rcp_forcing        = DataFrame(load(joinpath(@__DIR__, "..", "data", rcp_scenario*"_midyear_radforcings.csv"), skiplines_begin=58))

    # Calculate CO₂ emissions.
    rcp_co2_emissions = (rcp_emissions.FossilCO2 .+ rcp_emissions.OtherCO2)[rcp_indices]
    # Get RCP N₂O concentrations (used for CO₂ radiative forcing calculations).
    rcp_n2o_concentration = rcp_concentrations.N2O[rcp_indices]

    # Calculate exogenous radiative forcings.
    rcp_aerosol_forcing    = (rcp_forcing.TOTAER_DIR_RF .+ rcp_forcing.CLOUD_TOT_RF)[rcp_indices]
    rcp_other_forcing      = (rcp_forcing.TOTAL_INCLVOLCANIC_RF .- rcp_forcing.CO2_RF .- rcp_forcing.TOTAER_DIR_RF .- rcp_forcing.CLOUD_TOT_RF)[rcp_indices]

    m = MimiSNEASY.get_model(start_year=start_year, end_year=end_year)

    # update RCP scenario inputs
    update_param!(m, :ccm, :CO2_emissions, rcp_co2_emissions)
	update_param!(m, :rfco2, :N₂O, rcp_n2o_concentration)
 	update_param!(m, :radiativeforcing, :rf_aerosol, rcp_aerosol_forcing)
 	update_param!(m, :radiativeforcing, :rf_other, rcp_other_forcing)

    return m
end

"""
    set_sneasy_params!(m, params, parnames)

Set parameter values for a MimiSNEASY model instance `m`. `params` can be a `DataFrameRow` or a vector, and `parnames` is a required vector of parameter names matching the values in `params`.

"""
function set_sneasy_params!(m, params, parnames)
    parameters = vec(Array(params)) # vectorize parameters

    # set up sneasy parameters, variables, and components to find indices and update parameters in a loop
    sneasy_parnames = ["climate_sensitivity", "heat_diffusivity", "rf_scale_aerosol", "Q10", "CO2_fertilization", "CO2_diffusivity", "N2O_0", "CO2_0"]
    sneasy_vars = [:t2co, :kappa, :alpha, :Q10, :Beta, :Eta, :N₂O_0]
    sneasy_comps = [:doeclim, :doeclim, :radiativeforcing, :ccm, :ccm, :ccm, :rfco2]
    
    # find matching indices of parameters
    par_index = indexin(sneasy_parnames, parnames)
    
    # loop over the SNEASY parameter list and update those that are provided by the params/parnames arguments
    for i = 1:length(sneasy_parnames) - 1
        if !isnothing(par_index[i])
            update_param!(m, sneasy_comps[i], sneasy_vars[i], parameters[par_index[i]])
        end
    end
end

"""
    query_temperature(m, model_years, query_years)

Query global mean temperatures anomaly relative to the 1861-1880 average.

"""
function query_temperature(m, model_years, query_years)
    # get normalization value, 1861-1880 mean
    norm_index = findall((in)(1861:1880), model_years)
    temp_baseline = mean(m[:doeclim, :temp][norm_index])
    # query temperatures and normalize to baseline
    query_index = findall((in)(query_years), model_years)
    query_temps = m[:doeclim, :temp][query_index] .- temp_baseline
    return query_temps
end
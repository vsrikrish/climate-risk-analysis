# This file was generated, do not modify it. # hide
using Statistics

rmse(y, ŷ) = sqrt(mean((y - ŷ).^2))
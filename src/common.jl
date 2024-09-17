using Distributions, StatsBase, Printf, Random, Plots

# Define a struct to hold the parameters
mutable struct ModelParameters
    γ::Float64
    α::Float64
    ρ::Float64
    ξ::Float64
    ω::Float64
    η::Float64
    θ::Float64
    μ_a::Float64
    σ_a::Float64
    μ_z::Float64
    σ_z::Float64
    R::Float64
    σ::Float64
    ϕ::Float64
    δ::Float64
    S::Int
    M::Int
    location:: Float64
    tail:: Float64
    scale:: Float64
    p:: Float64
end

# Define another struct for fixed point settings
mutable struct FixedPointSettings
    υ::Float64
    iter_S_max::Int
    tol_S::Float64
    tol_S_A::Float64
    tol::Float64
end
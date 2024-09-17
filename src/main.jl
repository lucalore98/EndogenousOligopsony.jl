cd("EndogenousOligopsony.jl")
using EndogenousOligopsony, Distributions
# Define a folder to save figures
saveFolder = "Figures"
# Check if the folder exists, and if not, create it
if !isdir(saveFolder)
    mkdir(saveFolder)
end

# Initialize model parameters
modelParams = ModelParameters(
    0.7,   # γ: Labor elasticity in production
    0.99,  # α: Returns to scale
    0.3,   # ρ: Complementarity between workers
    1.0,   # ξ: Scale in worker output
    0.5,   # ω: Weight on worker ability
    10,    # η: Elasticity within markets
    0.5,   # θ: Elasticity across markets
    0,     # μ_a: Mean of worker ability distribution
    0.5,   # σ_a: Std. dev. of worker ability distribution
    0,     # μ_z: Mean of firm productivity distribution
    0.3,   # σ_z: Std. dev. of firm productivity distribution
    0.10,  # R: Rental rate of capital
    1.0,   # σ: Utility curvature (risk aversion)
    0.6,   # ϕ: Frisch elasticity of labor supply
    0.08,  # δ: Capital depreciation rate
    500,    # S: Number of worker types (percentiles)
    1000,  # M: Number of markets
    2,    # Location parameter in Pareto distribution
    0.52, # Tail parameter in Pareto distribution
    19.74, # Scale parameter in Pareto distribution
    0.14 # Mass of markets with one firm only
)

# Initialize fixed point settings
feSettings = FixedPointSettings(
    0.2,      # υ: Step size for updates (slow adjustment)
    10000,    # iter_S_max: Max iterations for equilibrium
    1e-06,    # tol_S: Tolerance for market equilibrium
    1e-03,    # tol_S_A: Tolerance across markets
    0.001     # tol: Tolerance for aggregate labor supply
)

# Define the log-normal distribution for worker abilities
logAbilityDist = LogNormal(modelParams.μ_a, modelParams.σ_a)

# Generate percentiles (500 percentiles between 0 and 1)
space = LinRange(0, 1, modelParams.S+2)  # S percentiles + boundaries
a = quantile(logAbilityDist, space[2:end-1])  # Skip the 0 and 1 bounds

# Calculate mass (equally weighted)
mass = fill(1 / length(a), length(a))

genEq=generateMarkets(modelParams,a)
# Plot the distribution of firms and save the plot
Figures.plotFirmDistribution(genEq[:,1], saveFolder)




z
S_ij=marketEq(modelParams, feSettings, z, Φ, mass, S_ij_0; efficient=false)


fig = plotMarketSharesInEquilibrium(a, S_ij, N, saveFolder)
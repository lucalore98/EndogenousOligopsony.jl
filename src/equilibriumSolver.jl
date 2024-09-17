function mplFun(modelParams, Φ, Φ_bar, H)
    # Extract necessary parameters from the parameters struct
    γ = modelParams.γ
    α = modelParams.α
    R=modelParams.R
    S=modelParams.S
    Z = (1 - α * (1 - γ)) * (α * (1 - γ) / R)^((1 - γ) * α / (1 - α * (1 - γ)))

    # Replicate arrays to match dimensions
    hh = repeat(H, S, 1)
    barbar = repeat(Φ_bar, S, 1)

    # Calculate MPL using the formula
    MPL = Z * (α * γ / (1 - α * (1 - γ))) * barbar.^(1 / (1 - α * (1 - γ))) .* hh.^((α - 1) / (1 - α * (1 - γ))) .* (1 .- (1 / (α * γ)) * (1 .- Φ./ barbar))

    # Set negative values to 0
    MPL[MPL .< 0] .= 0

    return MPL
end

function marketEq(modelParams, feSettings, z, Φ, mass, S_ij_0; efficient=false)
    
    # Extract necessary parameters from the parameters struct
    γ = modelParams.γ
    α = modelParams.α
    ρ = modelParams.ρ
    ξ = modelParams.ξ
    ω = modelParams.ω
    η = modelParams.η
    θ = modelParams.θ
    R = modelParams.R
    upsilon = feSettings.υ
    iter_S_max = feSettings.iter_S_max
    tol_S = feSettings.tol_S
    

    # Common term to all firms
    Z = (1 - α * (1 - γ)) * (α * (1 - γ) / R)^((1 - γ) * α / (1 - α * (1 - γ)))
    N = length(z)

    # Initial Guess
    S_ij = S_ij_0

    # Iteration
    for i in 1:iter_S_max
        isnan_indices = isnan.(S_ij)
        S_ij[isnan_indices] .= 0

        NS = S_ij[:, 1:N].^(η / (1 + η)) .* mass  # Number of workers by firm
        H = sum(NS, dims=1)  # Firm-level employment

        Φ_bar = sum(NS .* Φ, dims=1) ./ H
        MPL = mplFun(modelParams, Φ, Φ_bar, H)

        # Set μ (mu) based on 'efficient' option
        if efficient
            μ = ones(size(S_ij[:, 1:N]))  # Set μ to 1 if efficient = true
        else
            ε = (1 / η .+ (1 / θ - 1 / η) .* S_ij[:, 1:end-1]).^(-1)
            μ = ε ./ (1 .+ ε)
        end

        S_ij_n = zeros(size(S_ij))

        # Calculate the sum
        sum_values = sum((μ .* MPL).^(1 + η), dims=2)
        #zero_sum_indices = sum_values .== 0

        # Update S_ij_n for all firms
        S_ij_n[:, 1:end-1] = (μ .* MPL).^(1 + η) ./ sum_values
        S_ij_n[zero_sum_indices, :] .= 0  # Replace NaN values with zero
        S_ij_n[:, end] = 1 .- sum(S_ij_n, dims=2)  # Last column for unemployment
        #S_ij_n[S_ij_n .< tol_S] .= 0

        dist_S = maximum(abs.(S_ij_n -S_ij))
        if dist_S < tol_S
            println("Solution Reached")
            break
        end

        # Update S slowly
        S_ij = upsilon * S_ij_n + (1 - upsilon) * S_ij
        if i == iter_S_max
            println("WARNING: max iter reached")
            break
        end
    end

    #S_ij[S_ij .< tol_S] .= 0
    NS = S_ij[:, 1:N].^(η / (1 + η)) .* mass  # Number of workers by firm
    H = sum(NS, dims=1)  # Firm-level employment
    Φ_bar = sum(NS .* Φ, dims=1) ./ H
    ε = (1 / η .+ (1 / θ - 1 / η) .* S_ij[:, 1:end-1]).^(-1)
    μ = ε ./ (1 .+ ε)

    # Wages
    W_ij = μ .* MPL
    π_ij = Z .* z'.^(1 / γ) .* H .* Φ_bar.^(1 / γ)  # π represents profits (pi)

    return S_ij
end
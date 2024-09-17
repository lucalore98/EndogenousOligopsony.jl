# Function to calculate firm-level output
function phiFun(z, a, modelParams)
    # Extract necessary parameters from modelParams
    γ = modelParams.γ
    ρ = modelParams.ρ
    ω = modelParams.ω
    ξ = modelParams.ξ

    # Use broadcasting to apply the operation across both z and a
    Φ = ((1 - ω) .* (z.^((ρ - 1) / ρ))' .+ ω .* (a.^((ρ - 1) / ρ))) .^ (ρ / (ρ - 1))

    # Raise Φ to the power of ξ
    Φ = Φ .^ ξ

    return Φ
end
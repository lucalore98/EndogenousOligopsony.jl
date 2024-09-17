# Function to generate markets
function generateMarkets(modelParams,a)
    # Number of firms per market
    M_j = numFirms(modelParams)      
    I = 4  # Number of columns to store in genEq
    genEq = Array{Any}(undef, modelParams.M, I)  # Initialize the genEq array with 2 dimensions

    # Assign the number of firms to the first column
    genEq[:, 1] .= M_j
    # Loop over each market
    for marketIdx in 1:modelParams.M
        N = Int(genEq[marketIdx, 1])  # Number of firms in the market
        z = sort(rand(LogNormal(modelParams.μ_z, modelParams.σ_z), N))  # Draw firm productivities
        genEq[marketIdx, 2] = z  # Store firm productivities

        # Worker-level output in each firm
        genEq[marketIdx, 3] = phiFun(z, a, modelParams)

        # Firm shares and unemployment
        S = ones(length(a), N + 1) / N  # Initialize matrix with N+1 columns
        S[:, N+1] .= 1 .- sum(S[:, 1:N], dims=2)  # Last column for unemployment

        # Store firm shares and unemployment in genEq
        genEq[marketIdx, 4] = S
    end

    return genEq  # Return the results for all markets
end
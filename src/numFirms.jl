function numFirms(params::ModelParameters)
    # Extract relevant parameters from the struct
    location = params.location
    tail = params.tail
    scale = params.scale
    M = params.M
    p = params.p  # Percentage of single-firm markets (can adjust or add to struct if needed)

    cap=100 # Top cap 

    # Calculate the number of Pareto-distributed markets and single-firm markets
    M_pareto = round(Int, (1 - p) * M)  # Markets with Pareto-distributed firms
    M_ones = round(Int, p * M)  # Single-firm markets

    # Generate firm numbers for Pareto markets
    pareto_distr = GeneralizedPareto(tail, scale, location)
    M_j = rand(pareto_distr, M_pareto)  # Generate random numbers from Pareto distribution

    # Round and cap firm numbers at 100
    M_j = round.(M_j)  # Round to nearest integer
    M_j = min.(M_j, cap)  # Cap at 100 firms

    # Combine single-firm markets with the rest
    M_j = vcat(ones(Int, M_ones), M_j)  # Append markets with one firm
    
    # Return sorted number of firms per market
    return sort(M_j)
end
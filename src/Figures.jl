# Figures.jl
module Figures
    using Plots
    function plotFirmDistribution(M_j, save_folder)
        # Plot the histogram with 100 bins, bin edges between 0.5 and 100.5
        fig=histogram(M_j, bins=0.5:1:100.5, normalize=true, 
            xlabel="Number of Firms", 
            ylabel="Fraction of Markets", 
            title="Distribution of Number of Firms per Market", 
            label="Firm Count Distribution")  # Better legend description
    
        
        # Define the path to save the figure (overwrites if it exists)
        save_path = joinpath(save_folder, "firm_distribution_histogram.png")
        
        # Save the plot
        savefig(save_path)
        println("Figure saved to: $save_path")
        return fig
    end

    function plotMarketSharesInEquilibrium(a, S_ij, N, saveFolder)
        # Set the variable G to the desired number of elements
        Q = length(a)
        G = Int(0.98 * Q)  # 98% of the ability distribution
    
        # Some percentiles in ability distribution
        median = a[Int(Q / 2)]
        seven_five = a[Int(0.75 * Q)]
        ninety = a[Int(0.9 * Q)]
    
        # Extracting the required columns from S
        s_1 = S_ij[1:G, Int(N / N)]
        s_2 = S_ij[1:G, Int(0.25 * N)]
        s_3 = S_ij[1:G, Int(0.5 * N)]
        s_4 = S_ij[1:G, Int(0.75 * N)]
        s_5 = S_ij[1:G, Int(0.95 * N)]
    
        # Create the plot
        fig = plot(a[1:G], s_1, label = "Min firm", linewidth = 2)
        plot!(a[1:G], s_2, label = "25th percentile", linewidth = 2)
        plot!(a[1:G], s_3, label = "Median", linewidth = 2)
        plot!(a[1:G], s_4, label = "75th percentile", linewidth = 2)
        plot!(a[1:G], s_5, label = "95th percentile", linewidth = 2)
    
        # Add vertical lines for percentiles
        vline!([median], label = "Median ability", linewidth = 2, linestyle = :dash, color = :red)
        vline!([seven_five], label = "75th percentile ability", linewidth = 2, linestyle = :dash, color = :blue)
        vline!([ninety], label = "90th percentile ability", linewidth = 2, linestyle = :dash, color = :green)
    
        # Adding labels and legend
        xlabel!("Ability")
        ylabel!("Share Values")
        title!("Selected firms market shares of workers")
    
    
        # Define the path to save the figure
        save_path = joinpath(saveFolder, "market_shares_equilibrium.png")
        
        # Save the figure
        savefig(save_path)
        println("Figure saved to: $save_path")
    
        return fig
    end

    export plotMarketSharesInEquilibrium, plotFirmDistributionInEquilibrium
end
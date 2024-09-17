# Create the histogram for M_j
function plotFirmDistribution(M_j, save_folder)
    # Plot the histogram with 100 bins, bin edges between 0.5 and 100.5
    histogram(M_j, bins=0.5:1:100.5, normalize=true, 
        xlabel="Number of Firms", 
        ylabel="Fraction of Markets", 
        title="Distribution of Number of Firms per Market", 
        label="Firm Count Distribution")  # Better legend description

    
    # Define the path to save the figure (overwrites if it exists)
    save_path = joinpath(save_folder, "firm_distribution_histogram.png")
    
    # Save the plot
    savefig(save_path)
    println("Figure saved to: $save_path")
end
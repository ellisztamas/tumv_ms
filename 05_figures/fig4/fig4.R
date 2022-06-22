#' Script to create figure 4.

library('gridExtra')
library('cowplot')

# Script to plot the map.
source("05_figures/fig4/plot_spatial_dispersion.R")
source("05_figures/fig4/map.R")

# This gets the PNG device to work on RStudio server
options(bitmapType='cairo')

dist_plots <- plot_grid(plot_maf, plot_am_dists, plot_snp_dists,
                        ncol=3, labels = c("B", "C", "D"))


png(
  filename = "05_figures/fig4/fig4.png",
  width = 18, height = 15, units = 'cm', res = 300
  )

plot_grid(map_plot, dist_plots, nrow = 2, labels = c("A", ""))

dev.off()


#' Script to create figure 4.

library('gridExtra')
library('cowplot')

# Script to plot the map.
source("05_figures/fig4/plot_spatial_dispersion.R")
source("05_figures/fig4/map.R")

# This gets the PNG device to work on RStudio server
options(bitmapType='cairo')

dist_plots <- plot_grid(plot_maf, mac_by_distance,
                        ncol=2, labels = c("B", "C"))


# png(
#   filename = "05_figures/fig4/fig4.png",
#   width = 18, height = 15, units = 'cm', res = 300
#   )

plot_grid(map_plot, dist_plots, nrow = 2, labels = c("A", ""))

ggsave(
  filename = "05_figures/fig4/fig4.pdf",
  device = "pdf",
  width = 18, height = 15, units = 'cm'
)



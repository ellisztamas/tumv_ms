#' Code to create figure 2.

library(ggpubr)

source("05_figures/fig2/necrosis-manhattan-plot.R")
source("05_figures/fig2/phenotypes_at_major_association.R")
source("05_figures/fig2/mutants.R")

# This gets the PNG device to work on RStudio server
options(bitmapType='cairo')

plot_manh <- ggarrange(
  plotlist = manh_plus_signif,
  ncol=2, nrow = 2, labels = "AUTO"
)

plot_bars <- ggarrange(
  plot_phenotypes_at_major_association, plot_mutants,
  ncol = 2, widths = c(2,1), labels = c("D", "E")
)

ggarrange(
  plot_manh, plot_bars,
  nrow = 2,
  heights = c(5,3)
  )

ggsave(
  "05_figures/fig2/fig2.png",
  device = "png",
  units = "cm", height = 22, width = 16.9
)

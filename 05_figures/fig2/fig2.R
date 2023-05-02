#' Code to create figure 2.

library(ggpubr)

source("05_figures/fig2/necrosis-manhattan-plot.R")
source("05_figures/fig2/phenotypes_at_major_association.R")
source("05_figures/fig2/mutants.R")
source("05_figures/fig2/te_insert.R")

# This gets the PNG device to work on RStudio server
options(bitmapType='cairo')

plot_manh <- ggarrange(
  plotlist = manh_plus_signif,
  ncol=2, nrow = 2, labels = "AUTO"
)

plot_effect_sizes <- ggarrange(
  plot_phenotypes_at_major_association, plot_te_insert,
  labels = c("E", "G"),
  nrow=2
)

plot_bars <- ggarrange(
  plot_effect_sizes, plot_mutants,
  nrow = 1, ncol=2,
  widths =  c(2,1), labels = c(NA, "F")
)

ggarrange(
  plot_manh, plot_bars,
  nrow = 2
  )

ggsave(
  "05_figures/fig2/fig2.png",
  device = "png",
  units = "cm", height = 22, width = 16.9
)

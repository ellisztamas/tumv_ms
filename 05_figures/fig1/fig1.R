#' Create the plot to render figure 1.

library('cowplot')

source("05_figures/fig1/correlation_matrix.R")
source("05_figures/fig1/phenotype_differences.R")
source("05_figures/fig1/snp_heritability.R")

# This gets the PNG device to work on RStudio server
options(bitmapType='cairo')

symptoms <- ggdraw() +
  draw_image("05_figures/fig1/Symptoms_scale_new.png")

p1 <- plot_grid(
  symptoms, snp_heritability, plot_cor_matrix, 
  nrow = 3,
  rel_heights = c(1,2,2),
  # rel_widths = c(1,2),
  labels = LETTERS[1:3]
)


p2 <-ggpubr::ggarrange(
  phenotype_diffs$audps,
  phenotype_diffs$infectivity,
  phenotype_diffs$sym,
  phenotype_diffs$necrosis,
  labels = LETTERS[4:7]
  )

png(
  filename = "05_figures/fig1/fig1.png",
  width = 18, height = 18, units='cm', res = 300
)

plot_grid(p1, p2, ncol = 2)

dev.off()

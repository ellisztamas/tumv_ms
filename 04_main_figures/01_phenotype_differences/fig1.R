#' Create the plot to render figure 1.

library('cowplot')

source("04_main_figures/01_phenotype_differences/correlation_matrix.R")
source("04_main_figures/01_phenotype_differences/phenotype_differences.R")

png(
  filename = "04_main_figures/01_phenotype_differences/fig1.png",
  width = 18, height = 10, units='cm', res = 300
)


p2 <-ggpubr::ggarrange(
  phenotype_diffs$audps,
  phenotype_diffs$infectivity,
  phenotype_diffs$sym,
  phenotype_diffs$necrosis,
  labels = LETTERS[2:5]
  )

plot_grid(cor_matrix, p2, ncol = 2, labels = c("A", ""))

dev.off()

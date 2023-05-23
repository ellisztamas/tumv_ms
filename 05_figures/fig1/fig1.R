#' Create the plot to render figure 1.

library('cowplot')

source("05_figures/fig1/correlation_matrix.R")
source("05_figures/fig1/phenotype_differences.R")
source("05_figures/fig1/snp_heritability.R")

# This gets the PNG device to work on RStudio server
options(bitmapType='cairo')

symptoms <- ggdraw() +
  draw_image("05_figures/fig1/Symptoms_scale_new.png")

plot_misc_phenotype_stuff <- plot_grid(
  symptoms, plot_cor_matrix, snp_heritability,
  labels = LETTERS[1:3], ncol=3
)

plot_phenotypes_by_virus <-ggpubr::ggarrange(
  plotlist = phenotypes_by_virus,
  labels = LETTERS[4:7],
  nrow = 1, ncol=4
)

plot_phenotype_diffs <-ggpubr::ggarrange(
  plotlist = phenotype_diffs,
  labels = LETTERS[8:11],
  nrow = 1, ncol=4
  )

plot_grid(
  plot_misc_phenotype_stuff, plot_phenotypes_by_virus, plot_phenotype_diffs,
  nrow = 3, rel_heights = c(3,2,2)
  )


ggsave(
  filename = '05_figures/fig1/fig1.pdf',
  device=cairo_pdf ,
  height = 16, width=16.9, units = "cm"
  )

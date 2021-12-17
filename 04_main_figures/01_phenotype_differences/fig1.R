#' Create the plot to render figure 1.

library('patchwork')
library('magick')
library('cowplot')

source("04_main_figures/01_phenotype_differences/correlation_matrix.R")
source("04_main_figures/01_phenotype_differences/phenotype_differences.R")

symptom_scale =  ggdraw() +
  draw_image(
    magick::image_read_svg("04_main_figures/01_phenotype_differences/Symptoms_scale_new.svg")
  )

png(
  filename = "04_main_figures/01_phenotype_differences/fig1.png",
  width = 9, height = 14, units='cm', res = 300
)

symptom_scale /
  cor_matrix /
  (phenotype_diffs$audps | phenotype_diffs$infectivity) /
  (phenotype_diffs$sym | phenotype_diffs$necrosis) +
  plot_layout(heights = c(2,4,1,1)) + #, widths = c(2,2,1,1)) +
  plot_annotation(tag_levels = 'A') &
  theme(
    legend.position = "none",
    axis.text   = element_text(size=5),
    axis.title  =element_text(size=7)
  )

dev.off()

#' Script to create Manhattan plots for G and GxE GWAS results for necrosis.
#' 
#' Created by modifying the tutorial by Daniel Roelfs
#' https://danielroelfs.com/blog/how-i-create-manhattan-plots-using-ggplot/

library(tidyverse)

# Function to create the Manhattan plot
source("02_library/manhattan_plot.R")

# Import Limix results for necrosis, for direct effects only
limix_necrosis <- read_csv(
  "04_main_figures/02_multitrait_GWA/output/Necrosis_Evo_Necrosis_Anc_0.10_MTMM_G.csv",
  col_types = 'ciddid'
)

# Create the ggplot2 objects for a Manhattan plot and associated QQ-plot
manh_necrosis <- manhattan_plot(limix_necrosis, fraction_to_keep = 0.05, signif_cutoff = 0.02)

qq <- gwas_qqplot(limix_necrosis)
# Inset the QQ plot in the MH plot
necrosis_manh <- manh_necrosis +
  annotation_custom(
    ggplotGrob(qq),
    xmin = 119144518 / 2,
    xmax = 119144518,
    ymin = 8, ymax = 20
  )

# Create a zoom-in on the 100kb around the strong GWAS peak
# This is a table of the annotated genes nearby, listed in table 1.
cds <- data.frame(
  locus = c("AT2G14070", "AT2G14080", "AT2G14095", "AT2G14100", "AT2G14110", "AT2G14120", "AT2G14160"),
  start = c(5921880, 5925118, 5933929, 5936371, 5951822, 5960108, 5976801),
  stop  = c(5923151, 5929902, 5932382, 5934482, 5953155, 5953939, 5976252)
)
# # Plot P-values for the region, annotated with coding sequeneces from TAIR 10
# zoomed_manh <- limix_necrosis %>% 
#   filter(chr == 2, pos >= 5900000, pos <= 6000000) %>% 
#   ggplot(aes(x = pos, y = -log10(pvalue))) +
#   geom_point(color ="#377eb8") +
#   geom_hline(
#     yintercept = -log10(0.05 / nrow(limix_necrosis)),
#     color = "grey40", linetype = "dashed"
#   ) + 
#   theme_classic() +
#   labs(
#     x = "Position (bp)", 
#     y = "-log<sub>10</sub>(p)"
#   ) + 
#   annotate(
#     'segment', x  = cds$start, xend = cds$stop, y = 21 + 1:nrow(cds), yend = 21  + 1:nrow(cds),
#     colour = "black", size = 1,
#     arrow = arrow(
#       type = "closed", length = unit(0.1, "inches")
#     )
#   ) +
#   annotate(
#     'text', label = cds$locus,
#     x  = apply(cds[, 2:3], 1, min),
#     y = 21 + 1:nrow(cds),
#     hjust = 1.2,
#     size = 3
#   ) +
#   theme( 
#     legend.position = "none",
#     axis.title.y = element_markdown()
#   )
#' Script to create figure 4.

library('patchwork')

# Script to plot the map.
source("04_main_figures/04_geographic_distribution/map.R")

# Contingency table 
necrosis_susceptibility <- g1001 %>% 
  group_by(Phenotype, Genotype) %>% 
  summarise(
    n = n()
  ) %>%
  pivot_wider(names_from = Phenotype, values_from = n) %>% 
  gridExtra::tableGrob(rows = NULL) %>% 
  wrap_elements()

# Script to create the histogram
source('04_main_figures/04_geographic_distribution/plot_spatial_dispersion.R')

# Put the plot together
map / (necrosis_susceptibility | distance_hists) + 
  plot_layout(heights=c(1,1), widths = c(2,1)) +
  plot_annotation(tag_levels = 'A')
#' Script to create figure 4.

library('gridExtra')

# Script to plot the map.
source("04_main_figures/04_geographic_distribution/map.R")

# Contingency table 
g <- g1001 %>% 
  group_by(Phenotype, Genotype) %>% 
  summarise(
    n = n()
  ) %>%
  pivot_wider(names_from = Phenotype, values_from = n) %>% 
  tableGrob(rows=NULL, theme = ttheme_minimal())

# Solution for how to colour individual cells in the table from Stack Overflow
# https://stackoverflow.com/a/39313912
find_cell <- function(table, row, col, name="core-fg"){
  l <- table$layout
  which(l$t==row & l$l==col & l$name==name)
}
g$grobs[find_cell(g, 2, 2, "core-bg")][[1]][["gp"]] <- grid::gpar(fill="gray")
g$grobs[find_cell(g, 3, 2, "core-bg")][[1]][["gp"]] <- grid::gpar(fill="#4285f4")
g$grobs[find_cell(g, 2, 3, "core-bg")][[1]][["gp"]] <- grid::gpar(fill="#34a853")
g$grobs[find_cell(g, 3, 3, "core-bg")][[1]][["gp"]] <- grid::gpar(fill="#ea4335")


png(
  filename = "04_main_figures/04_geographic_distribution/fig4.png",
  width = 18, height = 6, units = 'cm', res = 300)

map_plot + draw_grob(
  g,
  hjust = 70, vjust = -60
)

dev.off()


# # Put the plot together
# map_plot / (necrosis_susceptibility | distance_hists) + 
#   plot_layout(heights=c(1,1), widths = c(2,1)) +
#   plot_annotation(tag_levels = 'A')
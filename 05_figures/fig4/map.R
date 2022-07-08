# Create a map showing the geographic distribution of accessions
# screened for TuMV resistance, highlighting those showing necrosis in response
# to either virus, and those showing the susceptible allele.

library('ggplot2')
library("maps")
library("mapdata")

source('03_data_preparation/1001genomes_data.R')

world <- map_data('world')  

# Reorder factors so that "Alive/Resistant" comes last.
# Necessary so that other factors can be overplotted
g1001 <- g1001 %>% 
  left_join(
    read_csv("01_data/top_snp.csv", col_types = 'ci'),
    by = 'code'
  ) %>% 
  mutate(
    Phenotype = ifelse( Necrosis_Anc | Necrosis_Evo, "Necrotic", "Alive"),
    Genotype = ifelse( geno == 1, "Susceptible", "Resistant"),
    type = paste(Phenotype, Genotype, sep = "/"),
    type = fct_relevel(type, "Alive/Resistant", after = Inf)
    )

map_plot <- ggplot() +
  # Plot an empty map of the world
  # Borders are shown the same colour as the country backgrounds
  geom_polygon(
    data=world,
    aes(x=long, y = lat, group = group),
    fill="gray90", colour="gray90") + 
  coord_fixed(
    xlim = range(g1001$Long, na.rm = TRUE),
    ylim = range(g1001$Lat, na.rm = TRUE),
    1.5
  ) +
  # Overplot the accessions
  geom_point(
    data = g1001,
    aes(x=Long, y = Lat, colour = type)) +
  geom_point(
    data = g1001 %>% filter(type != "Alive/Resistant"),
    aes(x = Long, y = Lat, colour=type)
    ) + 
  # Make it look nice
  labs(
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_bw() +
  theme(
    legend.position = "none",
    legend.title = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
    ) +
  scale_color_manual(values = c("#4285f4", "#34a853", "#ea4335", "gray70"))


# Add the contingency table 
g <- g1001 %>% 
  group_by(Phenotype, Genotype) %>% 
  summarise(
    n = n(),
    .groups = "drop"
  ) %>%
  pivot_wider(names_from = Phenotype, values_from = n) %>% 
  dplyr::select(Alive, Necrotic) %>% 
  tableGrob(
    rows=c("Resistant", "Susceptible"), cols = c("Alive", "Necrotic"), theme = ttheme_minimal())

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

map_plot <- map_plot + draw_grob(g, hjust = 70, vjust = -60 )
map_plot

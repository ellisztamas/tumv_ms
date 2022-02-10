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
  mutate(type = fct_relevel(type, "Alive/Resistant", after = Inf))

map_plot <- ggplot() +
  # Plot an empty map of the world
  # Borders are shown the same colour as the country backgrounds
  geom_polygon(
    data=world,
    aes(x=long, y = lat, group = group),
    fill="gray95", colour="gray95") + 
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
    )+
  scale_color_manual(values = c("#4285f4", "#34a853", "#ea4335", "gray"))

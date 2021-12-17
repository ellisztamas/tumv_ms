#' Plot the distributions of pairwise distances between plants that show or do 
#' not show necrosis in response to either virus, and those harbouring the
#' susceptible or resistant allele at the most strongly associated SNP for 
#' necrosis on chromosome 2.

library('tidyverse')
library('geosphere')

# For each phenotype/genotype combination create an upper triangular matrix of
# pairwise distances between accessions.
distances <- g1001 %>% 
  select(Long, Lat) %>% 
  split(g1001$type) %>% 
  purrr::map(~ distm(.)/1000) %>% 
  purrr::map(function(x) x[upper.tri(x, diag = FALSE)] )
# Turn those matrices into dataframes.
distances <- lapply(names(distances), function(x) {
  data.frame(
    type = x,
    distance = distances[[x]]
  )
}) %>% 
  do.call(what = 'rbind') %>% 
  mutate(
    type = as.factor(type),
    type = factor(type, levels(type)[c(1,4,2,3)])
  )

# Plot histograms of pairwise distances between accessions.
distance_hists <- distances %>%
  ggplot(aes(y = type, x = distance, fill = type)) +
  geom_violin(adjust = 1) +
  scale_fill_manual(
    values = c(
      "Alive/Resistant" = "gray",
      "Necrotic/Susceptible" = "#4285f4",
      "Alive/Susceptible" = "#34a853",
      "Necrotic/Resistant" = "#ea4335"
    )) +
  theme_classic()+
  theme(
    legend.position="none",
    # axis.title.y=element_blank(),
    axis.text.y=element_blank()
  ) +
  labs(
    y = "Phenotype/Genotype",
    x = "Distance between accessions (km)"
  )

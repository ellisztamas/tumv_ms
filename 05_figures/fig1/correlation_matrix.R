#' Create a plot object for the phenotype correlation matrix.

library(tidyverse)
library(reshape2)

source("03_data_preparation/1001genomes_data.R")

# List of correlations between traits for the same virus, and between viruses
cor_matrices <- list(
  # Cor matrix between traits for the ancestral virus
  anc = g1001 %>% 
    dplyr::select( grep("Anc", names(.)) ) %>% 
    cor(method = 's') %>% 
    matrix(nrow = 4),
  # Cor matrix between traits for the evolved virus
  evo = g1001 %>% 
    dplyr::select( grep("Evo", names(.)) ) %>% 
    cor(method = 's') %>% 
    matrix(nrow = 4),
  # Vector of correlations of each trait *between viruses
  between = mapply(function(x,y) cor(g1001[[ x ]] , g1001[[ y ]], method ='s'),
                   grep("Anc", names(g1001), value = TRUE),
                   grep("Evo", names(g1001), value = TRUE)
  )
)
# Make a single matrix to hold all the values.
# Start by making a copy of the ancestral correlations
cor_matrix <- cor_matrices$anc
# Insert correlations for the evolved virus into the top of this matrix
cor_matrix[lower.tri(cor_matrix)] <- cor_matrices$evo[lower.tri(cor_matrices$evo)]
# Insert correlations between viruses into the diagonal
diag(cor_matrix) <- cor_matrices$between
# Add the trait names to rows and columns
row.names(cor_matrix) <- c("AUDPS", "Infectivity", "Symptoms", "Necrosis")
colnames(cor_matrix) <- row.names(cor_matrix)

# Plot the correlation matrix
plot_cor_matrix <- cor_matrix %>% 
  melt(na.rm = TRUE) %>% 
  mutate(fontface = ifelse(Var1 == Var2, 'bold', 'plain')) %>% 
  # Create a plot object for the matrix.
  ggplot(aes(Var1, Var2, fill=value)) +
  geom_tile(colour="white") +
  geom_text(aes(Var1, Var2, label = round(value,2), fontface = fontface), color = "black", size = 3) +
  scale_fill_gradient2(
    low = "red", high = "red", mid = "white", 
    midpoint = 0, limit = c(-1,1), space = "Lab", 
    name="Spearman\nCorrelation") +
  theme_minimal()+ 
  coord_fixed() + theme(
    legend.position="none",
    axis.title = element_blank(),
    axis.text.x = element_text( angle = 45, vjust = 1, hjust = 1)
  ) +
  labs(
    x = "",
    y = ""
  )

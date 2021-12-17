#' Create a plot object for the phenotype correlation matrix.

library(tidyverse)
library(reshape2)

source("03_scripts/1001genomes_data.R")

# Get upper triangle of the correlation matrix
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat, diag = TRUE)]<- NA
  return(cormat)
}

cor_matrix <- g1001 %>% 
  # Create an upper triangular correlation matrix for all combinations of phenotypes
  select(
    AUDPS_Anc_21, AUDPS_Evo_21,
    Infectivity_Anc_21, Infectivity_Evo_21, 
    SYM_Anc, SYM_Evo,
    Necrosis_Anc, Necrosis_Evo) %>% 
  rename(
    `AUDPS Anc` = AUDPS_Anc_21,
    `AUDPS Evo` = AUDPS_Evo_21,
    `Inf. Anc` = Infectivity_Anc_21,
    `Inf. Evo` = Infectivity_Evo_21,
    `Sym. Anc` = SYM_Anc,
    `Sym. Evo` = SYM_Evo,
    `Nec. Anc` = Necrosis_Anc,
    `Nec. Evo` = Necrosis_Evo,
  ) %>% 
  cor(method = 's') %>% 
  get_upper_tri() %>% 
  melt(na.rm = TRUE) %>% 
  # Create a plot object for the matrix.
  ggplot(aes(Var1, Var2, fill=value)) +
  geom_tile(colour="white") +
  geom_text(aes(Var1, Var2, label = round(value,2)), color = "black", size = 2) +
  scale_fill_gradient2(
    low = "blue", high = "red", mid = "white", 
    midpoint = 0, limit = c(-1,1), space = "Lab", 
    name="Spearman\nCorrelation") +
  theme_minimal()+ 
  theme(
    axis.text.x = element_text(
      angle = 45, vjust = 1, 
      size = 12, hjust = 1))+
  coord_fixed() +
  theme(
    legend.position="none",
    axis.title = element_blank(),
    axis.text = element_text(size = 7),
    axis.text.x = element_text(size = 7)
  ) +
  labs(
    x = "",
    y = ""
  )

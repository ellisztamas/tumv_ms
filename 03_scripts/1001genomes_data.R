#' Import the metadata on the 1001 genomes project, and subset screened lines
#' Join this to the phenotype file

library(tidyverse)

g1001 <- read_csv(
  # 1001 genomes data
  "01_data/the1001genomes_accessions.csv", col_types = "cccccddcccccc"
)  %>% 
  rename("code" = AccessionID) %>% 
  dplyr::select(code, Lat, Long) %>% 
  # Phenotype data
  right_join(
    read_csv("01_data/phenotypes_1050_accessions.csv", col_types = "cddddiiii"),
    by='code'
  ) %>%
  # Data for the top SNP
  left_join(
    read_csv("01_data/chr2_5923326.csv", col_types = "ci"),
    by='code'
  ) %>% 
  # New column showing who is necrotic or not.
  mutate(
    Phenotype = ifelse(Necrosis_Anc == 1 | Necrosis_Evo == 1, "Necrotic", "Alive"),
    Genotype = ifelse(genotype == 0, "Resistant", "Susceptible"),
    type = factor(paste(Phenotype, Genotype, sep="/"),
                  levels = c(
                    "Alive/Resistant",
                    "Alive/Susceptible",
                    "Necrotic/Resistant",  
                    "Necrotic/Susceptible"
                  ))
  )

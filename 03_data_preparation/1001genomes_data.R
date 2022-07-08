#' Import the metadata on the 1001 genomes project, and subset screened lines
#' Join this to the phenotype file

library(tidyverse)

g1001 <- read_csv(
  # 1001 genomes data
  "01_data/the1001genomes_accessions.csv", col_types = "cccccddcccccc"
)  %>% 
  rename("code" = AccessionID) %>% 
  dplyr::select(code, Lat, Long, `Admixture Group`) %>% 
  dplyr::rename(admixture_group = `Admixture Group`) %>% 
  # Phenotype data
  right_join(
    read_csv("01_data/phenotypes_1050_accessions.csv", col_types = "cddddiiii"),
    by='code'
  )
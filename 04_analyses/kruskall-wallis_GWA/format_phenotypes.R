#' Tom Ellis, 23rd March 2021
#' Format necrosis data for GWAS.
#' 
#' Saves files for necrosis against the evolved and ancestral strains with a 
#' column for genotype and a column for phenotype

suppressPackageStartupMessages(library(tidyverse))
library("tidyverse")

# Create a folder for the phenotype data
source('02_library/get_script_path.R')
output_dir <- file.path(get_script_path(), "phenotypes") # only works when called via Rscript
dir.create(output_dir, showWarnings = FALSE)

# Full data sets
read.csv('01_data/phenotypes_1050_accessions.csv') %>% 
  select(code, Necrosis_Anc) %>%
  write.csv(file.path(output_dir, "ancestral.csv"), row.names = FALSE)

read.csv('01_data/phenotypes_1050_accessions.csv') %>% 
  select(code, Necrosis_Evo) %>%
  write.csv(file.path(output_dir, "evolved.csv"), row.names = FALSE)
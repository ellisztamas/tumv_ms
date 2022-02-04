suppressPackageStartupMessages(library("tidyverse"))
library("tidyverse")

# Create a folder for the phenotype data
source('02_library/get_script_path.R') # function to retrieve path of this script.
output_dir <- paste(get_script_path(), "phenotypes/", sep = "/") # only works when called via Rscript
if(!dir.exists(output_dir)) dir.create(output_dir)

# Import phenotype data
virus <- read.csv('01_data/phenotypes_1050_accessions.csv')

#AUDPS
audps_21 <- virus %>% 
  select(code, AUDPS_Anc_21, AUDPS_Evo_21) %>% 
  write.csv(file = paste(output_dir, 'AUDPS_21.csv', sep=""), row.names = FALSE)

# Severity of infection
sym <- virus %>%
  select(code, SYM_Anc, SYM_Evo) %>% 
  write.csv(file = paste(output_dir, 'sym.csv', sep=""), row.names = FALSE)

# Frequency of infection
infectivity_21 <- virus %>%
  select(code, Infectivity_Anc_21, Infectivity_Evo_21) %>% 
  write.csv(file = paste(output_dir, 'infectivity_21.csv', sep=""), row.names = FALSE)

# Necrosis
necrosis <- virus %>% 
  select(code, Necrosis_Evo, Necrosis_Anc) %>% 
  write.csv(file = paste(output_dir, 'necrosis.csv', sep=""), row.names = FALSE)

# Merge files on cohort and genotype at the top SNP to create a single covariate file.
read_csv("01_data/cohort_as_dummy.txt", col_types = 'ciiii') %>% 
  left_join(
    read_csv("01_data/top_snp.csv", col_types = 'ci'),
    by = 'code'
    ) %>% 
  write.csv(file = paste(output_dir, 'covariates.txt', sep=""), row.names = FALSE)

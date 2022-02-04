suppressPackageStartupMessages(library("tidyverse"))
library("tidyverse")

# Create a folder for the phenotype data
source('02_library/get_script_path.R')
output_dir <- paste(get_script_path(), "phenotypes/", sep = "/") # only works when called via Rscript
if(!dir.exists(output_dir)) dir.create(output_dir)

# Main phenotype data file to be split up.
virus <- read.csv('01_data/phenotypes_1050_accessions.csv') 

# Area under disease progression curve
audps_21 <- virus %>% 
  select(code, AUDPS_Anc_21, AUDPS_Evo_21) %>% 
  write.csv(file = paste(output_dir, 'AUDPS_21.csv', sep=""), row.names = FALSE)

# Severity of infection
sym <- virus %>%
  select(code, SYM_Anc, SYM_Evo) %>% 
  write.csv(file = paste(output_dir, 'sym.csv', sep=""), row.names = FALSE)

# Infectivity
infectivity_21 <- virus %>%
  select(code, Infectivity_Anc_21, Infectivity_Evo_21) %>% 
  write.csv(file = paste(output_dir, 'infectivity_21.csv', sep=""), row.names = FALSE)

# Frequency of infection
necrosis <- virus %>% 
  select(code, Necrosis_Evo, Necrosis_Anc) %>% 
  write.csv(file = paste(output_dir, 'necrosis.csv', sep=""), row.names = FALSE)

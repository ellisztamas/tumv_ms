
#' Format phenotype data from the replicate experiment.

suppressPackageStartupMessages(library("tidyverse"))
library("tidyverse")

# Create a folder for the phenotype data
source('02_library/get_script_path.R')
output_dir <- paste(get_script_path(), "phenotypes/", sep = "/") # only works when called via Rscript
if(!dir.exists(output_dir)) dir.create(output_dir)

# Necrosis, as defined in the 1050 accessions
# i.e. scored as 1 if *any* plant showed necrosis
read_delim("001_data/001_raw_data/replicate_experiment.csv", delim=";") %>% 
  filter(Accession != "Col-0") %>% 
  select(Accession, Virus, per_nec_infected) %>% 
  pivot_wider(names_from = Virus, values_from = per_nec_infected) %>% 
  mutate(
    Ancestral = ifelse(Ancestral > 0, 1, 0),
    Evolved   = ifelse(Evolved   > 0, 1, 0)
  ) %>% 
  rename(binary_necrosis_anc = Ancestral, binary_necrosis_evo = Evolved) %>% 
  write.csv(paste(output_dir, "binary_necrosis.csv", sep=""), row.names = FALSE)

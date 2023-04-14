# Script to generate a matrix of distances in kilometres between all pairs of accessions

library('tidyverse')
library("geosphere")
# Import data
g1001 <-read_csv("01_data/the1001genomes_accessions.csv") 

# Matrix of pairwise distances between all accessions.
dmat <- g1001 %>% 
  dplyr::select(Long, Lat) %>% 
  distm() / 1000 

dmat %>% 
  write.table(
    file="04_analyses/07_geographic_distribution/output/distance_matrix.csv", 
    sep = ",",
    row.names = F, col.names = F
    )

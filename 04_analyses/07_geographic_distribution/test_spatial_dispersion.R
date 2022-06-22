#' Script to test whether pairs of necrotic accessions, or those with the
#' susceptible allele at Chr2:5927469 are more or less spatially distributed 
#' than would be expected by chance. This is done by comparing to the same 
#' numbers of pairs of accessions chosen at random.
#' 
#' Tom Ellis


library('tidyverse')
library("geosphere")
# Functions for sampling from distance matrices
source("02_library/matrix_subsamples.R")
# Import data
source('03_data_preparation/1001genomes_data.R')

set.seed(1050)

# Add a column for genotype at the top SNP
g1001 <- g1001 %>% 
  left_join(
    # read_csv("01_data/top_snp.csv", col_types = "ci"),
    read_csv("05_figures/fig2/relative_risk/output/snp_matrix.csv", col_types = "ciiiiiiiiiiiii"),
    by = 'code'
  )

# Matrix of pairwise distances between all accessions.
dmat <- g1001 %>% 
  dplyr::select(Long, Lat) %>% 
  distm() / 1000


# Distances between alleles at each locus ---------------------------------

# Observed distances between accessions with the minor allele at each locus
marker_names <- grep("chr*", names(g1001), value = TRUE)
obs_dists <-  sapply(marker_names, function(col) {
    m <- subset_matrix( ix = g1001[[ col ]],  dmat=dmat )
    median( m, na.rm = TRUE)
  })
# Get the median distances between pairs of randomly chosen accessions
minor_allele_counts <- colSums(g1001[, grep("chr*", names(g1001))] )
snp_rand_dists <- sapply(minor_allele_counts, median_of_pairwise_draws, dmat=dmat, nreps = 10000)
# Summarise observed distance, CIs for random pairs, and pvalues
snp_dists <- cbind(
  snp = names(obs_dists),
  obs_dists, # observed distance between accessions
  # 96% CI for distances between random pairs
  apply(snp_rand_dists, 2, quantile, c(0.025, 0.975) ) %>%  t() %>% as.data.frame(),
  # how often the observed value is greater than the random pairs
  p = sapply(1:13, function(i) mean(obs_dists[i] > snp_rand_dists[,i]) )
  )
names(snp_dists) <- c("snp", "obs", "lower", "upper", 'p')
# write to disk
write_csv(
  snp_dists,
  file = "04_analyses/07_geographic_distribution/output/snps_distances.csv"
)


# Distances between accessions of each admixture group --------------------

# Observed distances between accessions in each admixture group
am_groups <- unique(g1001$admixture_group)
am_dists <- sapply(am_groups, function(g){
  m <- subset_matrix(g1001$admixture_group == g, dmat = dmat)
  median(m, na.rm=TRUE)
})
# Distances between pairs of randomly chosen accessions, using the same number
# of accessions as are found in each admixture group
am_counts <- table(g1001$admixture_group)
am_rand_dist <- sapply(am_counts, median_of_pairwise_draws, dmat=dmat, nreps = 10000)

am_dists <- cbind(
  am_group = names(am_dists),
  am_dists, # observed distance between accessions
  # 96% CI for distances between random pairs
  apply(am_rand_dist, 2, quantile, c(0.02, 0.95) ) %>%  t() %>% as.data.frame(),
  # how often the observed value is greater than the random pairs
  p = sapply(1:10, function(i) mean(am_dists[i] > am_rand_dist[,i]) )
)
names(am_dists) <- c("am_group", "obs", "lower", "upper", 'p')

# write to disk
write_csv(
  am_dists,
  file = "04_analyses/07_geographic_distribution/output/admixture_group_distances.csv"
  )

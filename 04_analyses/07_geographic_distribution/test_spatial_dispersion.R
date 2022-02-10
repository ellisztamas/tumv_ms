#' Script to test whether pairs of necrotic accessions, or those with the
#' susceptible allele at Chr2:5927469 are more or less spatially distributed 
#' than would be expected by chance. This is done by comparing to the same 
#' numbers of pairs of accessions chosen at random.
#' 
#' Tom Ellis


library('tidyverse')
library("geosphere")

source('03_data_preparation/1001genomes_data.R')
# Add a column for genotype at the top SNP
g1001 <- g1001 %>% 
  left_join(
    read_csv("01_data/top_snp.csv", col_types = "ci"),
    by = 'code'
  )

# Matrix of pairwise distances between all accessions.
dmat <- g1001 %>% 
  dplyr::select(Long, Lat) %>% 
  distm() / 1000

# Median distances between observed accessions
obs <- vector("list",2)
names(obs) <- c("phenotype", "genotype")
# Median pariwise distance between necrotic accessions
ix <- (g1001$Necrosis_Anc == 1) | (g1001$Necrosis_Evo == 1)
dvec <- dmat[ix, ix]
obs$phenotype <- median(dvec[upper.tri(dvec)], na.rm = TRUE)
# Median pariwise distance between accessions with the susceptible allele
ix <- g1001$geno == 1
dvec <- dmat[ix, ix]
obs$genotype <- median(dvec[upper.tri(dvec)])

# Random pairs of accessions
nreps <- 1000
subsamples <- list(
  phenotype = numeric(length = nreps),
  genotype = numeric(length = nreps)
)
# Random subsamples of 53 accessions for necrotic accessions
for(r in 1:nreps){
  ix <- sample(
    1:1050,
    size = sum((g1001$Necrosis_Anc == 1) | (g1001$Necrosis_Evo == 1)),
    replace = FALSE)
  dvec <- dmat[ix, ix]
  dvec <- dvec[upper.tri(dvec)]
  subsamples$phenotype[r] <- median(dvec, na.rm = TRUE)
}
# Random subsamples of 107 accessions for necrotic accessions
for(r in 1:nreps){
  ix <- sample(
    1:1050,
    size = sum(g1001$geno == 1),
    replace = FALSE)
  dvec <- dmat[ix, ix]
  dvec <- dvec[upper.tri(dvec)]
  subsamples$genotype[r] <- median(dvec, na.rm = TRUE)
}

# Two-tailed p-values for whether observed values are less than would be expected by chance.
2 * mean(obs$phenotype > subsamples$phenotype)
2 * mean(obs$genotype < subsamples$genotype)

# As a graphical confirmation, plot histogram of the distances between all 
# accessions with orange and purple vertical lines showing median distances 
# between necrotic accessions and between accessions with the susceptible 
# alleles. Above, boxplots show the distributions of random subsamples of pairs
# of accessions in the same colours.
layout(mat = matrix(c(1,2),2,1, byrow=TRUE),  height = c(1,8))
par(mar=c(0, 4.1, 1.1, 2.1))
boxplot(subsamples , horizontal=TRUE , xaxt="n",
        col = c('purple', "orange"),
        axes=F , frame=F, ylim=c(0,15000))

par(mar=c(4, 4.1, 1.1, 2.1))
hist(
  dmat[upper.tri(dmat)] ,
  breaks=40 , border=F , 
  main="" , xlab="Distance (km)", ylab = "Pairs of accessions",
  xlim=c(0,15000)
  )
segments(obs$phenotype, 90000, obs$phenotype, 0, col = "purple", lwd = 2)
segments(obs$genotype,  90000, obs$genotype,  0, col = "orange", lwd = 2)
legend("topright", c("Susceptible alleles", "Necrotic accessions"),
       col = c('orange', "purple"),
       bty="n", pch =16)

#' Tom Ellis, 31st January 2022
#' Script to pull out the coordinates of top hits for necrosis and create a
#' table that python can use to pull genotypes at those loci.
#' This retrieves the top hit on chromosome 2, and additional hits from a GWAS
#' conditioning on the top hit (because linkage with that SNP will cause false
#' associations if not accounted for.)

library('tidyverse')

# Import GWAS results.
# I am using the combined results from Limix (effects common to both viruses,
# plus virus-specific effects)
gwas <- list(
  standard = read_csv(
    "04_analyses/02_multitrait_GWA/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_G.csv"
  ) %>% 
    mutate(effect = "common"),
  conditional = rbind(
    read_csv(
      "04_analyses/03_condition_on_top_snp/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_G.csv"
    ) %>% 
      mutate(effect = "common"),
    read_csv(
      "04_analyses/03_condition_on_top_snp/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_GxE.csv"
    ) %>% 
      mutate(effect = "specific")
  )
)

# Convert p values to -log10 pvalues
gwas$standard$log10p    <- -log10(gwas$standard$pvalue)
gwas$conditional$log10p <- -log10(gwas$conditional$pvalue)
# Threshold for significance
bonferroni <- -log10(0.05/nrow(gwas$standard))

# Function to filter non-significant SNPs, and to take most-significant SNPs 
# within 1-mb windows
top_snps_within_windows <- function(gwas, cutoff, window = 1e6){
  gwas %>% 
    filter(log10p > cutoff) %>%
    mutate(
      window = cut_width(pos, width = window)
    ) %>% 
    group_by(chr, window) %>%
    slice(which.max(log10p))
}
# Linkage-filtered top SNPs for each GWAS analysis.
top_snps <- list(
  standard = top_snps_within_windows(gwas$standard, bonferroni),
  conditional = top_snps_within_windows(gwas$conditional, bonferroni)
)

# save the top hits to disk.
# That means the big association on chr2 from the standard gwas, and everything
# else from the conditional
top_snps$standard %>% 
  arrange(pvalue) %>% 
  head(1) %>% 
  rbind(
    top_snps$conditional
  ) %>% 
  arrange(chr, pos) %>% 
  write.csv(file = "05_figures/fig2/relative_risk/output/top_gwas_results.csv", row.names = FALSE)

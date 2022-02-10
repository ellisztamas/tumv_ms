#' Script to generate plots showing log relative risk of necrosis in response
#' to the ancestral and evolved viruses. This is done separately for SNPs
#' showing 'common' reponses to both viruses or 'specific' responses to a single
#' virus.

library("tidyverse")
source("02_library/relative_risk.R") # functions to calculate and plot relative risk

# Import file with the positions of the top snps
top_snps <- read_csv("05_figures/fig2/relative_risk/output/top_gwas_results.csv") %>% 
  mutate(
    snp = paste("chr", chr, "_", pos, sep="")
  )

# g1001$n_alleles <- rowSums( g1001[,grep("chr", names(g1001), value = TRUE)] )
# table(n_alleles, g1001$Necrosis_Evo)
# 
# g1001 %>% 
#   group_by(n_alleles) %>% 
#   summarise(
#     anc = sum(Necrosis_Anc),
#     evo = sum(Necrosis_Evo)
#   ) %>% 
#   mutate(
#     anc = cumsum(anc),
#     evo = cumsum(evo)
#   ) %>% 
#   pivot_longer(anc:evo) %>% 
#   ggplot( aes(x = n_alleles, y = value, group = name, colour = name) ) +
#   geom_point() +
#   geom_line()

# Import phenotype data and bind to genotype data.
source("03_data_preparation/1001genomes_data.R")
g1001 <- g1001 %>% 
  left_join(
    read_csv("05_figures/fig2/relative_risk/output/snp_matrix.csv") %>% 
      mutate(code = as.character(code)),
    on='code'
  ) %>% 
  mutate(
    chr4_273465 = 1 - chr4_273465, # So the minor allele is the susceptible allele
  )

# Pull the vector of SNP names from the column headers
snp_names <- grep("chr._", colnames(g1001), value = TRUE)

# Table detailing absolute and relative risk of necrosis in response to the 
# ancestral and evolved viruses
snp_effects <- rbind(
  relative_risk(g1001$Necrosis_Anc, g1001[, snp_names]) %>% 
    add_column(g1001 = "Ancestral", .before = 1),
  relative_risk(g1001$Necrosis_Evo, g1001[, snp_names]) %>% 
    add_column(g1001 = "Evolved", .before = 1)
) %>%
  left_join(top_snps, by = 'snp') %>% 
  mutate(
    snp = factor(snp, levels =unique(.$snp) ),
  )

snp_effects %>% 
  arrange(log_rr) %>% 
  select(g1001,snp, G0_N0, G0_N1, G1_N0, G1_N1, freq, risk_G0, risk_G1, rel_risk, log_rr)

# Plot log relative risk
relrisk <- list(
  common = snp_effects %>%
    filter(effect == "common") %>% 
    arrange(chr, pos) %>% 
    plot_rel_risk()
    # theme(
    #   legend.position = c(0.8,0.8),
    #   legend.background = element_rect(fill = "white", color = "black")
    # )
  ,

  specific = snp_effects %>%
    filter(effect == "specific") %>%
    arrange(chr, pos) %>% 
    plot_rel_risk()
    # theme(legend.position="none")
  )



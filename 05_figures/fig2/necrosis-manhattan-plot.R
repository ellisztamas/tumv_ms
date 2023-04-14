#' Script to create Manhattan plots for G and GxE GWAS results for necrosis.
#' 
#' Created by modifying the tutorial by Daniel Roelfs
#' https://danielroelfs.com/blog/how-i-create-manhattan-plots-using-ggplot/

library(tidyverse)
library(ggpubr)
library(RColorBrewer)

# Function to create the Manhattan plot
source("02_library/manhattan_plot.R")

# Import GWAS for common and specific responses to the evolved and ancestral viruses
gwa_filenames <- c(
  "04_analyses/02_multitrait_GWA/output/SYM_Anc_SYM_Evo_0.03_MTMM_G.csv",
  "04_analyses/02_multitrait_GWA/output/SYM_Anc_SYM_Evo_0.03_MTMM_GxE.csv",
  "04_analyses/02_multitrait_GWA/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_G.csv",
  "04_analyses/02_multitrait_GWA/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_GxE.csv"
)
gwa_results <- lapply(gwa_filenames, read_csv, col_types = 'ciddid')
names(gwa_results) <- c("symptoms_G", "symptoms_GxE", "necrosis_G", "necrosis_GxE")

# For each GWA file add x-axis positions and filter only the significant results
signif_snps <- lapply(gwa_results, function(x){
  x %>% 
    add_base_pair_positions(.) %>% 
    mutate(log10p = -log10(pvalue)) %>% 
    filter( log10p > -log10(0.05 / nrow(.)) ) 
})

# Base Manhattan plots
manh <- lapply(gwa_results, manhattan_plot,
               fraction_to_keep = 0.05, signif_cutoff = 0.05 , chr_colours = c('gray80', 'gray60')
)
# Label significant SNPs in red
manh_plus_signif <- list(
  manh$symptoms_G +
    geom_point(
      data = signif_snps$symptoms_G, inherit.aes = TRUE, colour = 'red'
    )+
    ggtitle("Severity of symptoms", "Common effects"),
  manh$necrosis_G +
    geom_point(
      data = signif_snps$necrosis_G, inherit.aes = TRUE, colour = 'red'
    ) +
    ggtitle("Necrosis", "Common effects"),
  manh$symptoms_GxE +
    geom_point(
      data = signif_snps$symptoms_GxE, inherit.aes = TRUE, colour = 'red'
    )+
    ggtitle("Severity of symptoms", "Virus-specific effects"),
  manh$necrosis_GxE +
    geom_point(
      data = signif_snps$necrosis_GxE, inherit.aes = TRUE, colour = 'red'
    ) +
    ggtitle("Necrosis", "Virus-specific effects")
)

# # # Import file with the positions of the top snps
# top_snps <- read_csv("05_figures/fig2/relative_risk/output/top_gwas_results.csv") %>%
#   mutate(
#     snp = paste("chr", chr, "_", pos, sep="")
#   ) %>%
#   dplyr::select(chr, pos, effect, snp)
# # 
# # 
# # Function to link up the positions of top SNPs with the cumulative bp positions
# top_snp_coords <- function(gwas_data, top_snps, effect){
#   if(! effect %in% c("common", "specific") ){
#     stop("`effect` should be either `common` or `specific`.")
#   }
#   gwas_data %>%
#     add_base_pair_positions() %>%
#     filter(-log10(pvalue) > 3) %>% # filtring NS snps makes the next step faster
#     mutate(
#       snp = paste("chr", chr, "_", pos, sep=""),
#       log10p = -log10(pvalue)
#     ) %>%
#     filter( snp %in% top_snps$snp[top_snps$effect == effect] ) %>%
#     mutate(
#       snp = factor(snp, levels =unique(top_snps$snp) )
#     )
# }
# 
# 
# # List of dataframes that include top snp positions
# anno <- list(
#   top_snp_coords(necrosis$standard_G,      top_snps, effect = "common"),
#   top_snp_coords(necrosis$standard_GxE,    top_snps, effect = "specific"),
#   top_snp_coords(necrosis$conditional_G,   top_snps, effect = "common"),
#   top_snp_coords(necrosis$conditional_GxE, top_snps, effect = "specific")
# )
# names(anno) <- names(necrosis)
# 
# # Function to colour the top snps.
# label_top_snps <- function(manh_plot, annotation, palette) {
#   manh_plot +
#     geom_point(
#       data = annotation,
#       aes( x = bp_cum, y = log10p),
#       colour = palette,
#       size = 3
#     )
# }
# 
# palette <- lapply(c(5,8,5,8), brewer.pal, name = "Dark2")
# palette[[3]] <- palette[[3]][2:5]
# 
# manh <- mapply(
#   label_top_snps,
#   manh_plot = manh,
#   annotation = anno,
#   palette = palette, 
#   SIMPLIFY = FALSE
# )

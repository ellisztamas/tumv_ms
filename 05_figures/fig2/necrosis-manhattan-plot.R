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
gwas_files <- c(
  "04_analyses/02_multitrait_GWA/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_G.csv",
  "04_analyses/02_multitrait_GWA/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_GxE.csv",
  "04_analyses/03_condition_on_top_snp/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_G.csv",
  "04_analyses/03_condition_on_top_snp/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_GxE.csv"
)
necrosis <- lapply(gwas_files, read_csv, col_types = 'ciddid')
names(necrosis) <- c("standard_G", "standard_GxE", "conditional_G", "conditional_GxE")

# Import file with the positions of the top snps
top_snps <- read_csv("05_figures/fig2/relative_risk/output/top_gwas_results.csv") %>% 
  mutate(
    snp = paste("chr", chr, "_", pos, sep="")
  ) %>% 
  dplyr::select(chr, pos, effect, snp)


# Function to link up the positions of top SNPs with the cumulative bp positions
top_snp_coords <- function(gwas_data, top_snps, effect){
  if(! effect %in% c("common", "specific") ){
    stop("`effect` should be either `common` or `specific`.")
  }
  gwas_data %>% 
    add_base_pair_positions() %>%
    filter(-log10(pvalue) > 3) %>% # filtring NS snps makes the next step faster
    mutate(
      snp = paste("chr", chr, "_", pos, sep=""),
      log10p = -log10(pvalue)
    ) %>%
    filter( snp %in% top_snps$snp[top_snps$effect == effect] ) %>% 
    mutate(
      snp = factor(snp, levels =unique(top_snps$snp) )
    )
}

# List of dataframes that include top snp positions
anno <- list(
  top_snp_coords(necrosis$standard_G,      top_snps, effect = "common"),
  top_snp_coords(necrosis$standard_GxE,    top_snps, effect = "specific"),
  top_snp_coords(necrosis$conditional_G,   top_snps, effect = "common"),
  top_snp_coords(necrosis$conditional_GxE, top_snps, effect = "specific")
)
names(anno) <- names(necrosis)

# Base Manhattan plots
manh <- lapply(necrosis, manhattan_plot,
               fraction_to_keep = 0.01, signif_cutoff = 0.01 , chr_colours = c('gray80', 'gray60')
               )
# Function to colour the top snps.
label_top_snps <- function(manh_plot, annotation, palette) {
  manh_plot +
    geom_point(
      data = annotation,
      aes( x = bp_cum, y = log10p),
      colour = palette,
      size = 3
    )
}

palette <- lapply(c(5,8,5,8), brewer.pal, name = "Dark2")
palette[[3]] <- palette[[3]][2:5]

manh <- mapply(
  label_top_snps,
  manh_plot = manh,
  annotation = anno,
  palette = palette, 
  SIMPLIFY = FALSE
)

manh$conditional_GxE


# qq <- gwas_qqplot(limix_necrosis)
# # Inset the QQ plot in the MH plot
# necrosis_manh <- manh_necrosis +
#   annotation_custom(
#     ggplotGrob(qq),
#     xmin = 119144518 / 2,
#     xmax = 119144518,
#     ymin = 8, ymax = 20
#   )
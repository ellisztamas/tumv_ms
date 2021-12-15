#' Manhattan plot from Limix output
#' 
#' Create a Manhattan plot from the output of one of Pieter Clauw's scripts to 
#' run Limix from Python. This is based on the tutorial by Daniel Roelfs at:
#' https://danielroelfs.com/blog/how-i-create-manhattan-plots-using-ggplot/
#' 
#' This simplifies the calculations needed for plotting by taking a random 
#' subsample of non-significant SNPs. A horizontal bar is drawn corresponding to
#' the Bonferroni-corrected significance threshold for a nominal cut-off of 0.05.
#' Colours are from the RColorBrewer pallette 'Set1"; this is likely to throw an
#' error if there are more than 8 chromosomes.
#' 
#' @param gwas_data Dataframe of GWAS results with columns including 'chr',
#' 'pos' and 'pvalue'. P-values should *not* be transformed to the log scale.
#' @param signif_cutoff Float between 0 and 1 giving a threshold for 'strong'
#' SNPs. Markers with larger p-values are randomly subsampled.
#' @fraction_to_keep Float between 0 and 1 giving the proportion of 'weak' SNPs
#' to subsample
#' @return A ggplot2 object.
#' @author Tom Ellis from code by Daniel Roeffs

manhattan_plot <- function(gwas_data, signif_cutoff = 0.05, fraction_to_keep = 0.1){
  library(dplyr)
  library(ggplot2)
  library(ggtext)
  
  # Manually set the significance threshold
  sig <- 0.05 / nrow(gwas_data)
  
  # Keep the strongest SNPs, but select only 10% of weaker SNPs to reduce computation
  sig_data <- gwas_data %>% 
    subset(pvalue < signif_cutoff)
  notsig_data <- gwas_data %>% 
    subset(pvalue >= signif_cutoff) %>%
    group_by(chr) %>% 
    sample_frac(fraction_to_keep)#, weight = -log10(pvalue))
  gwas_data <- bind_rows(sig_data, notsig_data)
  
  # Get the maximum base-pair position on each chromosome
  data_cum <- gwas_data %>% 
    group_by(chr) %>% 
    summarise(max_bp = max(pos)) %>% 
    mutate(bp_add = lag(cumsum(max_bp), default = 0)) %>% 
    dplyr::select(chr, bp_add)
  # Cumulative bp position for each SNP along the whole chromosome
  gwas_data <- gwas_data %>% 
    inner_join(data_cum, by = "chr") %>% 
    mutate(bp_cum = pos + bp_add)
  
  # Parameters for plotting
  # First, centres for each chromosome
  axis_set <- gwas_data %>% 
    group_by(chr) %>% 
    summarize(center = mean(bp_cum))
  # Manually set the limit for the y-axis
  ylim <- gwas_data %>% 
    filter(pvalue == min(pvalue)) %>% 
    mutate(ylim = abs(floor(log10(pvalue))) + 2) %>% 
    pull(ylim)
  
  # Make the plot
  manhplot <- ggplot(
    gwas_data,
    aes(x = bp_cum, y = -log10(pvalue), color = as_factor(chr), size = -log10(pvalue))) +
    geom_hline(yintercept = -log10(sig), color = "grey40", linetype = "dashed") + 
    geom_point(alpha = 0.75) +
    scale_x_continuous(label = axis_set$chr, breaks = axis_set$center) +
    scale_color_brewer(palette = "Set1")+
    # scale_y_continuous(expand = c(0,0), limits = c(0, ylim)) +
    # scale_color_manual(values = rep(c("#276FBF", "#183059"), unique(length(axis_set$chr)))) +
    scale_size_continuous(range = c(0.5,3)) +
    labs(
      x = "Chromosome", 
      y = "-log<sub>10</sub>(p)"
    ) + 
    theme_classic() +
    theme( 
      legend.position = "none",
      #   panel.border = element_blank(),
      #   panel.grid.major.x = element_blank(),
      #   panel.grid.minor.x = element_blank(),
      axis.title.y = element_markdown(),
      #   # axis.text.x = element_text(angle = 0, size = 8, vjust = 0.5)
    )
  
  manhplot
}

#' Create a quantile-normal plot for Limix output
#' 
#' Create a Manhattan plot from the output of one of Pieter Clauw's scripts to 
#' run Limix from Python.
#' 
#' @inheritParams manhattan_plot
#' @returns A ggplot2 object
#' @author Tom Ellis
gwas_qqplot <- function(gwas_data){
  library(dplyr)
  library(ggplot2)
  
  # Sort and add -log10 pvalues
  d <- gwas_data %>% 
    arrange(pvalue) %>% 
    mutate(
      logp = -log10(pvalue),
      exp  = -log10(ppoints(logp))
    ) 
  
  # Make the plot
  qq <- d %>% 
    ggplot(aes(y = logp, x = exp)) +
    geom_point() +
    geom_abline(intercept = 0, slope = 1) +
    labs(
      x = expression(paste("Expected -log"[10], plain(P))),
      y = expression(paste("Observed -log"[10], plain(P)))
    ) +
    theme_classic()
  
  qq
}

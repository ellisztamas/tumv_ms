#' Script to plot phenotypes in response to each virus.
#' 
#' This creates two lists of ggplot objects.
#' `phenotypes_by_virus` shows mostly boxplots of overal phenotype differences
#' `phenotype_diffs` shows change in phenotype for each genotype
#' 
#' Tom Ellis
library(tidyverse)

source("03_data_preparation/1001genomes_data.R")

phenotypes_by_virus <- list(
  audps =
    g1001 %>% 
    dplyr::select(code, AUDPS_Anc_21, AUDPS_Evo_21) %>% 
    pivot_longer(AUDPS_Anc_21: AUDPS_Evo_21, names_to = "Virus") %>%
    mutate(
      Virus = ifelse(grepl("*Anc*", Virus), "Anc", "Evo")
    ) %>% 
    ggplot(aes(x = Virus, y = value, fill = Virus)) + 
    geom_boxplot() +
    labs(
      y = "AUDPS"
    ) +
    theme_classic() +
    theme(
      axis.title.x = element_blank(),
      legend.position="none"
    ),
  
  infectivity = g1001 %>% 
    dplyr::select(code, Infectivity_Anc_21, Infectivity_Evo_21) %>% 
    pivot_longer(Infectivity_Anc_21 : Infectivity_Evo_21, names_to = "Virus") %>%
    mutate(
      Virus = ifelse(grepl("*Anc*", Virus), "Anc", "Evo")
    ) %>% 
    ggplot(aes(x = Virus, y = value, fill = Virus)) + 
    geom_boxplot() +
    labs(
      y = "Infectivity"
    ) +
    theme_classic() +
    theme(
      axis.title.x = element_blank(),
      # axis.text=element_text(size=5),
      legend.position="none"
    ),

  sym = g1001 %>% 
    dplyr::select(code, SYM_Anc, SYM_Evo) %>% 
    pivot_longer(SYM_Anc : SYM_Evo, names_to = "Virus") %>%
    mutate(
      Virus = ifelse(grepl("*Anc*", Virus), "Anc", "Evo")
    ) %>% 
    ggplot(aes(x = value, colour = Virus, fill = Virus, group = Virus)) + 
    geom_bar(position = position_dodge(0.7), width= 0.5) +
    labs(
      x = "Severity of symptoms",
      y = "Frequency"
    ) +
    theme_classic() +
    theme(
      axis.text=element_text(size=4),
      legend.position="none"
    ) +
    scale_x_continuous(breaks=0:5),
  
  necrosis = g1001 %>% 
    dplyr::select(code, Necrosis_Anc, Necrosis_Evo) %>% 
    pivot_longer(Necrosis_Anc : Necrosis_Evo, names_to = "Virus") %>%
    mutate(
      Virus = ifelse(grepl("*Anc*", Virus), "Anc", "Evo")
    ) %>% 
    group_by(Virus) %>% 
    summarise(
      n = sum(value)
    ) %>% 
    ggplot(aes(x = Virus, y = n, fill = Virus)) + 
    geom_col() +
    labs(
      y = "Necrotic lines"
    ) +
    theme_classic() +
    theme(
      axis.title.x = element_blank(),
      legend.position="none"
    )
)

phenotype_diffs <- list(
  delta_AUDPS <- g1001 %>% 
    dplyr::select(code, AUDPS_Anc_21, AUDPS_Evo_21) %>% 
    mutate(
      diff = AUDPS_Evo_21 - AUDPS_Anc_21,
    ) %>% 
    ggplot(aes(x = diff)) + 
    # geom_histogram(breaks = seq(-11,16,1)) +
    geom_histogram(boundary = 0) +
    labs(
      x = "\u0394 AUDPS",
      y = "Frequency"
    ) +
    theme_bw(),

  delta_infectivity = g1001 %>% 
    dplyr::select(code, Infectivity_Anc_21, Infectivity_Evo_21) %>% 
    mutate(diff = Infectivity_Evo_21 - Infectivity_Anc_21) %>% 
    ggplot(aes(x = diff)) + 
    geom_histogram(breaks = seq(-0.8, 1, 0.1)) +
    labs(
      x = "\u0394 Infectivity",
      y = "Frequency"
    ) +
    theme_bw(),
  
  delta_symptoms = g1001 %>% 
    mutate(
      sym_diff = SYM_Evo - SYM_Anc
    ) %>% 
    ggplot(aes( x=sym_diff )) +
    geom_bar() +
    scale_x_continuous(breaks = -5:5) +
    labs(
      x = "\u0394 symptoms",
      y = "Frequency"
    ) +
    theme_bw(),
  
  delta_necrosis = g1001 %>% 
    dplyr::select(code, Necrosis_Anc, Necrosis_Evo) %>% 
    mutate(necrosis = paste(Necrosis_Anc, Necrosis_Evo, sep="/")) %>%
    filter(necrosis != "0/0") %>%
    ggplot(aes( x=necrosis )) +
    geom_bar() +
    labs(
      x = "Necrosis (Anc/Evo)",
      y = "Frequency"
    ) +
    # scale_y_continuous(trans='log10') +
    # annotation_logticks(sides='l')+
    theme_bw()
  
)

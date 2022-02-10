#' Create a list of plot objects for differences between phenotypes in response
#' to each virus
#' 
library(tidyverse)

source("03_data_preparation/1001genomes_data.R")

phenotype_diffs <- list(
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
      y = "N. accessions"
    ) +
    theme_classic() +
    theme(
      axis.text=element_text(size=4),
      legend.position="none"
    ) +
    scale_x_continuous(breaks=0:5),
  
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
      y = "Necrotic accessions"
    ) +
    theme_classic() +
    theme(
      axis.title.x = element_blank(),
      legend.position="none"
    )
)

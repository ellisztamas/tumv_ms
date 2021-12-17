#' Create a list of plot objects for differences between phenotypes in response
#' to each virus
#' 
library(tidyverse)

source("03_scripts/1001genomes_data.R")

phenotype_diffs <- list(
  audps =
    g1001 %>% 
    select(code, AUDPS_Anc_21, AUDPS_Evo_21) %>% 
    pivot_longer(AUDPS_Anc_21: AUDPS_Evo_21, names_to = "Virus") %>%
    mutate(
      Virus = ifelse(grepl("*Anc*", Virus), "TuMV-AS", "TuMV-DV")
    ) %>% 
    ggplot(aes(x = Virus, y = value, fill = Virus)) + 
    geom_boxplot() +
    labs(
      y = "AUDPS"
    ) +
    theme(
      axis.title.x = element_blank()
    )+
    theme_classic(),
  
  sym = g1001 %>% 
    select(code, SYM_Anc, SYM_Evo) %>% 
    pivot_longer(SYM_Anc : SYM_Evo, names_to = "Virus") %>%
    mutate(
      Virus = ifelse(grepl("*Anc*", Virus), "TuMV-AS", "TuMV-DV")
    ) %>% 
    ggplot(aes(x = value, colour = Virus, fill = Virus, group = Virus)) + 
    geom_bar(position = 'dodge') +
    labs(
      x = "Severity of symptoms",
      y = "N. accessions"
    ) +
    theme(
      axis.text=element_text(size=5)
    )+
    scale_x_continuous(breaks=0:5) +
    theme_classic(),
  
  infectivity = g1001 %>% 
    select(code, Infectivity_Anc_21, Infectivity_Evo_21) %>% 
    pivot_longer(Infectivity_Anc_21 : Infectivity_Evo_21, names_to = "Virus") %>%
    mutate(
      Virus = ifelse(grepl("*Anc*", Virus), "TuMV-AS", "TuMV-DV")
    ) %>% 
    ggplot(aes(x = Virus, y = value, fill = Virus)) + 
    geom_boxplot() +
    labs(
      y = "Infectivity"
    ) +
    theme(
      axis.title.x = element_blank(),
      axis.text=element_text(size=1)
    )+
    theme_classic(),
  
  necrosis = g1001 %>% 
    select(code, Necrosis_Anc, Necrosis_Evo) %>% 
    pivot_longer(Necrosis_Anc : Necrosis_Evo, names_to = "Virus") %>%
    mutate(
      Virus = ifelse(grepl("*Anc*", Virus), "TuMV-AS", "TuMV-DV")
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
    theme(
      axis.title.x = element_blank()
    )+
    theme_classic()
)

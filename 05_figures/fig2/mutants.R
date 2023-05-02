library("tidyverse")

mutants <- read_delim("01_data/GWAS_clean_symptoms_mutants.csv", delim = ";", col_types = 'cdfff')

plot_mutants <- mutants %>% 
  filter(
    genotype %in% c("at2g14080", "at2g14120", "Col-0")
  ) %>%
  mutate(
    genotype = ifelse(genotype == 'at2g14120', 'drp3b', genotype)
    ) %>% 
  group_by(genotype, Virus, Symptoms) %>% 
  summarise(
    n = n()
  ) %>% 
  complete(
    genotype, Virus, Symptoms, fill = list(n = 0)
  ) %>% 
  ggplot(aes( x=Symptoms, y = n, group=Virus, fill=Virus)) +
  geom_col(position = position_dodge(0.7), width = 0.5) +
  labs(
    x = "Severity of Symptoms",
    y = "Number of individuals"
  ) +
  facet_grid( rows = vars(genotype) ) +
  theme_bw() +
  theme(
    legend.position = "bottom"
  )

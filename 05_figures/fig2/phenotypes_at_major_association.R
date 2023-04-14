#' Script to plot severity of symptoms distributions for lines with major and 
#' minor alleles at Chr2:5927469

source("03_data_preparation/1001genomes_data.R")

plot_phenotypes_at_major_association <- g1001 %>% 
  left_join(
    read_csv("01_data/top_snp.csv", col_types = "cf")
  ) %>% 
  dplyr::select(SYM_Anc, SYM_Evo, geno) %>% 
  pivot_longer(SYM_Anc: SYM_Evo, names_to = 'Virus', values_to = "Symptoms") %>% 
  mutate(Virus = ifelse(Virus == "SYM_Anc", "Ancestral", 'Evolved')) %>% 
  group_by(geno, Virus, Symptoms) %>% 
  summarise(
    n = n(),
    .groups = 'drop') %>% 
  complete(
    Symptoms, Virus, geno, fill = list(n = 0)
  ) %>% 
  group_by(geno) %>% 
  summarise(
    Virus = Virus,
    Symptoms = Symptoms,
    p = n / sum(n)
  ) %>%
  complete(
    Symptoms, Virus, geno, fill = list(n = 0)
  ) %>% 
  mutate(
    Allele = ifelse(geno == 0, "Major", 'Minor')
  ) %>% 
  ggplot(aes ( x = Symptoms, y = p, fill=Allele, group=Allele )) +
  geom_bar(stat = "identity", position = position_dodge(0.7), width = 0.5) + 
  scale_fill_brewer(palette = 'Dark2') +
  labs(
    x = "Severity of symptoms",
    y = "Proportion of lines"
  ) +
  facet_grid(cols = vars(Virus)) +
  theme_bw() +
  theme(
    legend.position = "bottom"
  )

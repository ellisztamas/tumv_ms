library(tidyverse)



te_insert <- read_delim(
  "01_data/lines_with_TE_insert.txt",
  delim = " ",
  skip = 1, col_names = c('X', "code", 'insert'), col_types = 'icc'
) %>% 
  select(-X) %>% 
  filter(code != "no") %>% 
  mutate(
    code = sapply( strsplit(.$code, split = "\\."), function(x) x[[1]] ), # Simplify accession label
    insert = code %in%  c(
      "10004",
      "159",
      "351",
      "870",
      "9100",
      "9102",
      "9561",
      "9622",
      "9892",
      "9903",
      "9927",
      "9982",
      "9995"
    )
  )

pheno <- g1001 %>% 
  mutate(code = as.character(code)) %>% 
  inner_join(te_insert, by = "code") 

plot_te_insert <- pheno %>%
  pivot_longer(SYM_Anc: SYM_Evo, names_to = 'Virus', values_to = "symptoms") %>%
  group_by(insert, Virus, symptoms) %>%
  summarise(
    n = n()
  ) %>%
  group_by(insert) %>% 
  summarise(
    Virus = Virus, 
    symptoms = symptoms,
    p = n / sum(n)
  ) %>% 
  ungroup() %>% 
  complete(
    Virus, insert, symptoms, fill = list(n = 0)
  ) %>% 
  mutate(
    Virus = ifelse(Virus == "SYM_Anc", "Ancestral", "Evolved"),
    `TE insert` = ifelse(insert, "Present", "Absent")
  ) %>% 
  ggplot(aes( x=symptoms, y = p, fill = `TE insert`, group=`TE insert`) ) +
  geom_col(position = position_dodge(0.7), width = 0.5) +
  labs(
    x = "Severity of symptoms",
    y = "Proportion of lines"
  ) +
  scale_fill_brewer(palette = 'Dark2') +
  theme_bw() +
  theme(
    legend.position = "left"
  ) +
  facet_grid(cols = vars(Virus) )


pheno %>% 
  group_by(insert) %>% 
  
  summarise(
    anc = sum(Necrosis_Anc),
    evo = sum(Necrosis_Evo)
  )

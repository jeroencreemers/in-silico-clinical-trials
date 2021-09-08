library(tidyverse)

load("data/lookup_table_survival_chemo.RData")
df_chemo <- cbind(df, therapy = "chemo") %>% 
  filter(randomization == "treatment")

load("data/lookup_table_survival_immuno.RData")
df_immuno <- cbind(df, therapy = "immuno") %>% 
  filter(randomization == "treatment")

df <- rbind(df_chemo, df_immuno)

save(df, file = "data/figure_3d_dataset.RData")
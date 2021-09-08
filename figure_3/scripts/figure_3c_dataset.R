library(tidyverse)

load("data/lookup_table_survival_chemo.RData")
df_chemo <- cbind(df, therapy = "chemo") %>% 
  filter(randomization == "treatment")

load("data/lookup_table_survival_chemoimmuno.RData")
df_chemoimmuno <- cbind(df, therapy = "chemoimmuno") %>% 
  filter(randomization == "treatment")

df <- rbind(df_chemo, df_chemoimmuno)

save(df, file = "data/figure_3c_dataset.RData")
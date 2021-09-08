library(tidyverse)

load("temp/lookup_table_survival_immuno.RData")
df_chemo <- cbind(df, therapy = "immuno") %>% 
  filter(randomization == "treatment")

load("temp/lookup_table_survival_firstchemo_thenimmuno.RData")
df_chemoimmuno <- cbind(df, therapy = "firstchemo_thenimmuno") %>% 
  filter(randomization == "treatment")

df <- rbind(df_chemo, df_chemoimmuno)

save(df, file = "data/figure_3e_dataset.RData")
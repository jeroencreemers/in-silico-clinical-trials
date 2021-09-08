library(tidyverse)

load("data/lookup_table_survival_chemo_2year_effect.RData")

set.seed(124)

# Sample n patients per arm in a dataframe
simulated_data <- df %>%
  group_by(randomization) %>% 
  sample_n(size = 800) %>% 
  ungroup()

save(simulated_data, file = "data/suppl_figure_2_data_panel_1.RData")
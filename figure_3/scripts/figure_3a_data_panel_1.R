library(tidyverse)

load("data/lookup_table_survival_chemo.RData")

set.seed(125)

# Sample n patients per arm in a dataframe
simulated_data <- df %>%
  group_by(randomization) %>% 
  sample_n(size = 800) %>% 
  ungroup()

save(simulated_data, file = "data/figure_3a_data_panel_1.RData")
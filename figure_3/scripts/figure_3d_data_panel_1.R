load("data/figure_3d_dataset.RData")

library(tidyverse)

set.seed(123)

# Sample n patients per arm in a dataframe
simulated_data <- df %>%
  group_by(therapy) %>% 
  sample_n(size = 800) %>% 
  ungroup()

save(simulated_data, file = "data/figure_3d_data_panel_1.RData")
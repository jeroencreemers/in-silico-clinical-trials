################################################################################
#### Figure 6C - Data Wrangling ####
################################################################################
library(tidyverse)
library(ggsankey)

load("data/figure_6c.RData")

data <- data %>% 
  mutate(result = case_when(pval > cutoff ~ "neg", 
                            pval < cutoff & hr < 1 ~ "pos", 
                            pval < cutoff & hr > 1 ~ "harm")) %>%
  select(-c(pval, hr, cutoff, time)) %>% 
  pivot_wider(names_from = num_analysis, values_from = result) %>%
  
  # Set values of analyses to NA after first analysis is positive or harmful
  pivot_longer(cols = c(-total_analyses, -study_nr)) %>% 
  mutate(is_pos_inconcl = if_else(value %in% c("pos", "harm"), 1, 0)) %>% 
  group_by(total_analyses, study_nr) %>% 
  mutate(should_na = cumsum(cumsum(is_pos_inconcl))) %>% 
  mutate(value = if_else(should_na > 1, NA_character_, value)) %>% 
  select(total_analyses, study_nr, name, value) %>% 
  pivot_wider(names_from = "name",
              values_from = "value") %>% 
  ungroup() %>% 
  mutate(BL = "neg")

save(data, file = "data/figure_6c_wrangled.RData")

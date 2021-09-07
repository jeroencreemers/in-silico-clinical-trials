# Create data for Kaplan Meier curve of NCCTG lung dataset
# Specifically filter data < ca. 24 months

library(survival)
library(dplyr)

data <- lung %>% 
  filter(time < 740) %>% 
  select(c(time, status)) %>% 
  mutate(status = status - 1)

save(data, file = "data/figure_1a_KM_NCCTG.RData")


library(dplyr)

load("data/isosurface.RData")

survival_to_param <- function(survival_value){
  df %>% 
    filter(survival == survival_value) %>% 
    select(-survival) %>%
    sample_n(size = 1, replace = TRUE) %>% 
    flatten_dbl()
}
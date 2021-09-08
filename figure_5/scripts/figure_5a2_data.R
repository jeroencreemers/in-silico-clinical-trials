### Figure 5A2 - Data ###
library(tidyverse)
library(survival)
library(furrr)

load("data/lookup_table_survival_chemo.RData")

plan(multisession, workers = 4)

trim_cohort <- function(timepoint, data){
  data <- data %>% 
    mutate(status = if_else(OS > timepoint, 0, 1), 
           OS = if_else(OS > timepoint, timepoint, OS))
  return(data)
}


simulate <- function(size_arm_1, size_arm_2, timepoint){
  df <- df %>% 
    group_split(randomization) %>% 
    map2_dfr(c(size_arm_1, size_arm_2), ~ slice_sample(.x, n = .y))
  
  df <- trim_cohort(timepoint, df)
  
  diff <- survdiff(Surv(OS, status)~as.factor(randomization), data = df)
  
  pvalue <- pchisq(diff$chisq, length(diff$n)-1, lower.tail = FALSE)
  
  return(pvalue)
}


replicates <- 1000
study_parameters <- data.frame(size_arm_1 = rep(c(150, 200, 225, 180), each = 8), 
                               size_arm_2 = rep(c(150, 100, 75, 120), each = 8),
                               ratio = rep(c("1:1", "2:1", "3:1", "3:2"), each = 8),
                               time = round(30.44*seq(3, 24, 3))) %>%
  slice(rep(row_number(), replicates)) %>% 
  arrange(time)

output <- future_pmap(.l = list(study_parameters$size_arm_1, study_parameters$size_arm_2, study_parameters$time), 
                      .f = simulate, .progress = TRUE, 
                      .options = furrr_options(seed = TRUE) )

output <- do.call(rbind, output) %>%
  as_tibble(.name_repair = ~ c("pvalue")) %>%
  bind_cols(study_parameters, .) 

df <- output %>% 
  group_by(ratio, time) %>% 
  count(significance = pvalue<0.05) %>% 
  filter(significance == TRUE) %>% 
  mutate(power = (n/replicates)*100) %>% 
  ungroup() %>%
  select(-c(significance, n))

save(df, file = "data/figure_5a2.RData")
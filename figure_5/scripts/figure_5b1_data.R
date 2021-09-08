### Figure 5B1 - Data ###
library(tidyverse)
library(survival)
library(furrr)

load("data/lookup_table_survival_immuno.RData")

plan(multisession, workers = 4)

trim_cohort <- function(timepoint, data){
  data <- data %>% 
    mutate(status = if_else(OS > timepoint, 0, 1), 
           OS = if_else(OS > timepoint, timepoint, OS))
  return(data)
}

simulate <- function(cohort_size, timepoint){
  df <- df %>% 
    group_by(randomization) %>% 
    sample_n(cohort_size) %>% 
    ungroup()
    
  df <- trim_cohort(timepoint, df)
  
  diff <- survdiff(Surv(OS, status)~as.factor(randomization), data = df)
  
  observed_placebo <- diff$obs[1]
  observed_treatment <- diff$obs[2]
  
  pvalue <- prop.test(x = c(observed_placebo, observed_treatment), 
                      n = rep(cohort_size, 2))$p.value
  
  return(pvalue)
}

study_vector <- rep(c(100, 200, 400, 600), each = 1000)
timepoints <- round(30.44*seq(3, 24, 3)) # every 3 months up to 2 years
study_parameters <- expand_grid(size = study_vector, time = timepoints)

output <- future_map2(.x = study_parameters$size, .y = study_parameters$time, 
                      .f = simulate, .progress = TRUE, 
                     .options = furrr_options(seed = TRUE) )

output <- do.call(rbind, output) %>%
  as_tibble(.name_repair = ~ c("pvalue")) %>%
  bind_cols(study_size = study_parameters$size, 
            timepoint = study_parameters$time) 

power_microsimulation <- output %>% 
  group_by(study_size, timepoint) %>% 
  count(significance = pvalue<0.05) %>% 
  filter(significance == TRUE) %>% 
  mutate(power_microsimulation = (n/1000)*100, 
         arm_size = study_size) %>% 
  ungroup() %>%
  select(-c(study_size, significance, n)) %>%
  mutate(arm_size = as.factor(arm_size))

save(power_microsimulation, file = "data/figure_5b1.RData")

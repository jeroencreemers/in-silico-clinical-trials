library(tidyverse)
library(furrr)
library(survival)

plan(multisession, workers = 4)

################################################################################
# Function to perform logrank test on study. Returns a p-value only!
simulate_study_log_rank <- function(number_patients){
  df <- df %>% 
    group_by(randomization) %>%
    sample_n(number_patients) %>%
    ungroup()
  
  df$OS <- ifelse(df$OS>=730, 730, df$OS)
  df$status <- ifelse(df$OS>=730, 0, df$status)
  
  diff <- survdiff(Surv(OS, status)~as.factor(randomization), data = df)
  pvalue <- pchisq(diff$chisq, length(diff$n)-1, lower.tail = FALSE)
  return(pvalue)
}

simulate_study_proportions_test <- function(number_patients){
  df <- df %>% 
    group_by(randomization) %>%
    sample_n(number_patients) %>%
    ungroup()
  
  df$OS <- ifelse(df$OS>=730, 730, df$OS)
  df$status <- ifelse(df$OS>=730, 0, df$status)
  
  diff <- survdiff(Surv(OS, status)~as.factor(randomization), data = df)
  observed_placebo <- diff$obs[1]
  observed_treatment <- diff$obs[2]
  
  pvalue <- prop.test(x = c(observed_placebo, observed_treatment), 
                      n = rep(number_patients, 2))$p.value
  return(pvalue)
}

# Set study sizes
study_sizes <- c(seq(10, 50, 10), 
                 seq(75, 100, 25), 
                 seq(150, 600, 50))

# Set study repetitions
study_repetitions <- 1000
study_vector <- rep(study_sizes, each = study_repetitions)

rearrange_output <-  function(output_from_simulation){
  output <- do.call(rbind, output_from_simulation) %>%
    as_tibble(.name_repair = ~ c("pvalue")) %>%
    bind_cols(study_size = study_vector) 
  
  power_table <- output %>% 
    group_by(study_size) %>% 
    count(significance = pvalue<0.05) %>% 
    filter(significance == TRUE) %>% 
    mutate(power = (n/study_repetitions)*100, 
           arm_size = study_size) %>% 
    ungroup() %>%
    select(-c(significance, n, study_size))
  
  return(power_table)
}


################################################################################
# Chemotherapy vs. placebo -> Log-rank test #
load("data/lookup_table_survival_immuno.RData")

output <- future_map(.x = study_vector, .f = simulate_study_log_rank, .progress = TRUE,
                     .options = furrr_options(seed = TRUE) )

power_immuno_logrank <- rearrange_output(output)
################################################################################
# Chemotherapy vs. placebo -> Pearson's Chi-squared test #
output <- future_map(.x = study_vector, .f = simulate_study_proportions_test, .progress = TRUE,
                     .options = furrr_options(seed = TRUE) )

power_immuno_proptest <- rearrange_output(output)
################################################################################

df <- bind_rows(list(logrank = power_immuno_logrank, proptest = power_immuno_proptest), .id="ID")

################################################################################

save(df, file = "data/figure_4b_data.RData")
library(tidyverse)
library(furrr)
library(survival)

plan(multisession, workers = 4)

################################################################################
# Function to perform logrank test on study. Returns a p-value only!
simulate_study_log_rank <- function(number_patients){
  df <- df %>% 
    group_by(therapy) %>%
    sample_n(number_patients) %>%
    ungroup()
  
  df$OS <- ifelse(df$OS>=730, 730, df$OS)
  df$status <- ifelse(df$OS>=730, 0, df$status)
  
  diff <- survdiff(Surv(OS, status)~as.factor(therapy), data = df)
  pvalue <- pchisq(diff$chisq, length(diff$n)-1, lower.tail = FALSE)
  return(pvalue)
}

simulate_study_proportions_test <- function(number_patients){
  df <- df %>% 
    group_by(therapy) %>%
    sample_n(number_patients) %>%
    ungroup()
  
  df$OS <- ifelse(df$OS>=730, 730, df$OS)
  df$status <- ifelse(df$OS>=730, 0, df$status)
  
  diff <- survdiff(Surv(OS, status)~as.factor(therapy), data = df)
  observed_placebo <- diff$obs[1]
  observed_treatment <- diff$obs[2]
  
  pvalue <- prop.test(x = c(observed_placebo, observed_treatment), 
                      n = rep(number_patients, 2))$p.value
  return(pvalue)
}

# Set study sizes
study_sizes <- seq(250, 3000, 250)

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
# Chemotherapy vs. Immunotherapy -> Log-rank test #
load("data/lookup_table_survival_chemo.RData")
df_chemo <- cbind(df, therapy = "chemo") %>% 
  filter(randomization == "treatment")

load("data/lookup_table_survival_immuno.RData")
df_immuno <- cbind(df, therapy = "immuno") %>% 
  filter(randomization == "treatment")

df <- rbind(df_chemo, df_immuno)

output <- future_map(.x = study_vector, .f = simulate_study_log_rank, .progress = TRUE, 
                     .options = furrr_options(seed = TRUE) )

power_chemovsimmuno_logrank <- rearrange_output(output)
################################################################################
# Chemotherapy vs. Immunotherapy -> Pearson's Chi-squared test #
output <- future_map(.x = study_vector, .f = simulate_study_proportions_test, .progress = TRUE,
                     .options = furrr_options(seed = TRUE) )

power_chemovsimmuno_proptest <- rearrange_output(output)
################################################################################

df <- bind_rows(list(logrank = power_chemovsimmuno_logrank, proptest = power_chemovsimmuno_proptest), .id="ID")

################################################################################

save(df, file = "data/figure_4d_data.RData")

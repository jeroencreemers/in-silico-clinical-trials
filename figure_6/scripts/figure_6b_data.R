################################################################################
#### Figure 6B - Data ####
################################################################################
library(tidyverse)
library(survival)
library(furrr)
library(ldbounds)

load("data/6b_lookup_table_simulated_survival.RData")

plan(multisession, workers = 4)

################################################################################
#### Functions ####
################################################################################
# Creates vector of n equally spaced intervals from 0 to 1
seq_times <- function(x) {
  seq(from = 1 / x, 1, length.out = x)
}

# Creates vector of n equally spaced intervals from 0 to 730
time_analysis <- function(x) {
  seq(from = 730 / x, 730, length.out = x)
}

# Returns vector of bounds for p-values from the alpha spending function
p_val_bounds <- function(x) {
  bounds(seq_times(x), iuse = c(1, 1), alpha = c(0.025, 0.025))$diff.pr
}

# Function to trim the survival length of the cohort and adapt the censoring
# status accordingy
trim_cohort <- function(timepoint, data) {
  data <- data %>%
    mutate(status = if_else(OS > timepoint, 0, 1),
           OS = if_else(OS > timepoint, timepoint, OS))
  return(data)
}

# Analyse trial with log-rank test
calculate_pvalue <- function(df) {
  diff <- survdiff(Surv(OS, status) ~ as.factor(randomization), data = df)
  #pvalue <- pchisq(diff$chisq, length(diff$n) - 1, lower.tail = FALSE)
  observed_placebo <- diff$obs[1]
  observed_treatment <- diff$obs[2]
  
  pvalue <- prop.test(x = c(observed_placebo, observed_treatment), 
                      n = rep(600, 2))$p.value
  
  hr <- summary(coxph(Surv(OS, status) ~ as.factor(randomization), data = df))$coef[2]
  
  return(c(pvalue, hr))
}

# Function to simulate trials
simulate <- function(arm_size, num_analyses) {
  
  # Sample patients for trial
  df <- df %>% group_by(randomization) %>% sample_n(arm_size) %>% ungroup()
  
  # Calculate pvalue and hr per interim analysis
  temp_func <- function(x) {
    calculate_pvalue(trim_cohort(time_analysis(num_analyses)[x], df))
  }
  
  temp <- map_dfr(.x = seq(1, num_analyses, 1), 
                  .f = ~setNames(temp_func(.x), c("pval", "hr"))) %>%
    bind_cols(total_analyses = num_analyses, 
              num_analysis = seq(1, num_analyses, 1), 
              .)
  return(temp)
}


# Execute studie 1000 times and put log rank pvalues in a dataframe
getOutput <- function(numberOfInterimAnalysis) {
  future_map_dfr(
    .x = 1:1000,
    .f = ~ simulate(600, numberOfInterimAnalysis),
    .progress = TRUE,
    .options = furrr_options(seed = TRUE), 
    .id = "study_nr"
  )
}

################################################################################
#### Calculations ####
################################################################################
# Execute simulating of 1000 studies with 1 to 5 interim analyses
output <- map_dfr(.x = 1:5, .f = getOutput)

# Create dataframe with p values per number of interim analyses
p_value_cutoffs <- map(.x = seq(1, 5, 1), .f = p_val_bounds) %>%
  unlist %>%
  bind_cols(total_analyses = rep(seq(5), seq(5)), 
        num_analysis = sequence(seq_len(5)), 
        cutoff = ., 
        time = map(.x = 1:5, ~time_analysis(.x)) %>% unlist %>% round()
        )

data <- full_join(output, p_value_cutoffs)

save(data, file = "data/figure_6b.RData")
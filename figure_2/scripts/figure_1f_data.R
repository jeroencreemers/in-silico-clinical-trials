### Figure 1F data ###

# Load libraries
library(tidyverse)
library(furrr) 
library(flexsurv)

# Set seed
set.seed(74)

# Set cores to use
plan(multisession, workers = 4)

# Source functions to:
# (1) Call ODE model
source("../model/call_model_function.R")

# Load 
load("data/figure_1c_KM_melanoma.RData")
original_data <- df %>%
  filter(id == "dtic") %>% 
  select(-id) %>%
  mutate(time = time * 30.44) # convert months to days

# Fit Weibull model to IPI melanoma dataset
# and sample two sets of survival values from 
# the model: one to simulate untreated and one
# to simulate treated patients.
model <- flexsurvreg(Surv(time, status) ~ 1, data = original_data, dist = "weibull")
shape <- model$res[1]
scale <- model$res[2]

n <- 420
weibull_sim <- data.frame(survival = rweibull(n = n+10,
                                              shape = shape,
                                              scale = scale),
                          status = rep(1, n+10)) %>% 
  mutate(survival = round(survival),
         survival = if_else(survival > 800, 800, survival),
         status = if_else(survival == 800, 0, 1)) %>%
  filter(survival >= 6) %>%
  sample_n(size = n) %>% 
  mutate(randomization = sample(rep(c("placebo", "treatment"), each = n/2), 
                                n(), 
                                replace = FALSE))


# Calculate parameter combinations for tumor growth, drift and decay rate
# corresponding to suvival values in the melanoma dataset
source("scripts/survival_to_param_function.R")

survival_params <- future_map(.x = weibull_sim$survival, 
                              .f = survival_to_param, 
                              .progress = TRUE, .options = furrr_options(seed = TRUE))

survival_params <- do.call(rbind, survival_params) %>%
  as_tibble(.name_repair = ~ c("growth_rate", "drift", "growth_decay")) %>%
  bind_cols(randomization = weibull_sim$randomization, 
            status = weibull_sim$status) %>%
  mutate(treatment_effect = if_else(randomization == "placebo", 1, 17))

simulated_data <- future_pmap(list(R = survival_params$growth_rate, 
                                   drift_r = survival_params$drift, 
                                   growth_decay = survival_params$growth_decay, 
                                   raise_killing = survival_params$treatment_effect),
                              call.model, .progress= TRUE, .options = furrr_options(seed = TRUE)) %>%
  
  # Combine the dataframes by row and add an ID per patient
  bind_rows(.id = "id") %>% 
  group_by(id) %>% 
  select(OS) %>% 
  distinct() %>%
  ungroup()

simulated_data <- bind_cols(survival_params, OS = simulated_data$OS)

# Save simulated survival data
save(simulated_data, file = "data/figure_1f_data.RData")

### Figure 1D data ###

# Load libraries
library(tidyverse)
library(furrr) 
library(flexsurv)

# Set cores to use
plan(multisession, workers = 4)

# Set seed
set.seed(9)

# Source functions to:
# (1) Calculate paramater values corresponding to a certain survival
# (2) Call ODE model
source("scripts/survival_to_param_function.R") # Dependedent on isosurface.RData
source("../../model/call_model_function.R")

# Load 
load("data/figure_1a_KM_NCCTG.RData")


# Fit Weibull model to NTTCG lung cancer dataset
# and sample survival values from model
model <- flexsurvreg(Surv(time, status) ~ 1, data = data, dist = "weibull")
shape <- model$res[1]
scale <- model$res[2]

n <- 217
random_vals_weibull <- data.frame(survival = rweibull(n = n+10, 
                                                      shape = shape, 
                                                      scale = scale), 
                                  status = rep(1, n+10)) %>% 
  mutate(survival = round(survival),
         survival = if_else(survival > 800, 800, survival),
         status = if_else(survival == 800, 0, 1)) %>%
  filter(survival >= 6) %>%
  sample_n(size = n)


# Calculate parameter combinations for tumor growth, drift and decay rate
# corresponding to suvival values in the NCCTG lung dataset
survival_params <- future_map(.x = random_vals_weibull$survival, 
                              .f = survival_to_param, 
                              .progress = TRUE, .options = furrr_options(seed = TRUE))

survival_params <- do.call(rbind, survival_params) %>%
  as_tibble(.name_repair = ~ c("growth_rate", "drift", "growth_decay")) 

simulated_survival_data <- future_pmap(list(R = survival_params$growth_rate, 
                                            drift_r = survival_params$drift, 
                                            growth_decay = survival_params$growth_decay),
                                       call.model, .progress= TRUE, .options = furrr_options(seed = TRUE)) %>%
  
# Combine the dataframes by row and add an ID per patient
  bind_rows(.id = "id") %>% 
  group_by(id) %>% 
  select(OS) %>% 
  distinct() %>%
  ungroup()

# Save simulated survival data
save(simulated_survival_data, file = "data/figure_1d_data.RData")
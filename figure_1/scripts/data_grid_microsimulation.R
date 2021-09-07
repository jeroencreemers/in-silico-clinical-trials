library(dplyr)
library(tidyr)
library(furrr) 
library(purrr)

source("../../model/call_model_function.R")

plan(multisession, workers = 4)
###############################################################################
# Create data (max. OS = 952)
param_R <- c(seq(1.76, 2, length.out=100), exp(seq(log(2.01), log(150), length.out = 20)))
param_drift_r <- seq(0, -0.6, length.out = 50)
param_decay <- seq(0, -2, length.out = 50)

parameters <- expand_grid(R = param_R, drift_r = param_drift_r, growth_decay = param_decay)

# Calculate the overall survival for all combinations in data
data <- future_pmap(list(R = parameters$R, drift_r = parameters$drift_r, growth_decay = parameters$growth_decay), 
                    call.model, .progress = TRUE) %>%
  
  # Combine the dataframes by row and add an ID per patient
  bind_rows(.id = "id")  %>%
  
  # Set objects to proper types
  mutate(id = as.numeric(id), 
         OS = as.numeric(OS)) %>%
  
  # Extract the first row of the simulation data from each patient, 
  # select the OS column, and discard the rest
  group_by(id) %>%
  slice(1) %>%
  select(OS) %>%
  ungroup() %>% 
  
  # Bind OS to input parameters
  cbind(., parameters)

save(data, file = "data/data_grid_microsimulation.RData")
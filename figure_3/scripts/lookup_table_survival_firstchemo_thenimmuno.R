library(tidyverse)
library(furrr)
plan(multisession, workers = 4)

load("data/lookup_table_parameters.RData")
source("../../model/call_model_function.R")

# Split data in censored and uncensored data
# Censored data doesn't need to be simulated
censored_data <- survival_params %>% filter(status == 0)
uncensored_data <- survival_params %>% filter(status == 1)

# Filter unique values from uncensored data
# To speed up calculation of the look up table
uncensored_data_unique <- uncensored_data %>% 
  distinct(across(c(growth_rate, drift, growth_decay, immuno_effect, chemo_effect)))

# Split dataframe in n parts
num_groups = 5
uncensored_data_unique_split <- uncensored_data_unique %>% 
  group_by((row_number()-1) %/% 
             (n()/num_groups)) %>%
  nest %>% 
  pull(data)

# Function to simulate based on input dataframe
simulate <- function(df){
  future_pmap(list(R = df$growth_rate, 
                   drift_r = df$drift, 
                   growth_decay = df$growth_decay,
                   raise_killing = df$immuno_effect,
                   lower_growth = df$chemo_effect, 
                   chemo_start = 0, 
                   chemo_duration = 182, 
                   immuno_start = 183),
              call.model, .progress= TRUE, .options = furrr_options(seed = TRUE)) %>%
    
    # Combine the dataframes by row and add an ID per patient
    bind_rows(.id = "id") %>% 
    group_by(id) %>% 
    select(OS) %>% 
    distinct() %>%
    ungroup()
}

sim_part_1 <- simulate(uncensored_data_unique_split[[1]])
sim_part_2 <- simulate(uncensored_data_unique_split[[2]])
sim_part_3 <- simulate(uncensored_data_unique_split[[3]])
sim_part_4 <- simulate(uncensored_data_unique_split[[4]])
sim_part_5 <- simulate(uncensored_data_unique_split[[5]])

simulated_data <- bind_rows(sim_part_1, sim_part_2, sim_part_3, sim_part_4, sim_part_5) %>% select(OS)
rm(sim_part_1, sim_part_2, sim_part_3, sim_part_4, sim_part_5)

simulated_data <- bind_cols(uncensored_data_unique, OS_sim = simulated_data$OS)

uncensored_data <- full_join(uncensored_data, simulated_data) %>% 
  mutate(status = if_else(OS_sim > 800, 0, 1), 
         OS_sim = if_else(OS_sim > 800, as.integer(800), OS_sim)) %>% 
  mutate(OS = OS_sim) %>% 
  select(-OS_sim)

df <- rbind(censored_data, uncensored_data)

save(df, file = "data/lookup_table_survival_chemoimmuno.RData")

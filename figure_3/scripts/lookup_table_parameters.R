#### Figure 3 - Sample survival values from Weibull model ####
library(furrr)
library(tidyverse)

plan(multisession, workers = 4)

load("data/digitized_data.RData") # figure 1B - ipilimumab data


#### Sample survival values from Weibull model ####
set.seed(1)

original_data <- df %>%
  filter(id == "placebo") %>% 
  select(-id) %>%
  mutate(time = time * 30.44) # convert months to days

# Fit Weibull model to IPI melanoma dataset
# and sample two sets of survival values from 
# the model: one to simulate untreated and one
# to simulate treated patients.
model <- flexsurv::flexsurvreg(survival::Surv(time, status) ~ 1, data = original_data, dist = "weibull")
shape <- model$res[1]
scale <- model$res[2]

n <- 5e5
surv_vals_weibull_mdl <- data.frame(survival = rweibull(n = n+10000,
                                              shape = shape,
                                              scale = scale),
                          status = rep(1, n+10000)) %>% 
  mutate(survival = round(survival),
         survival = if_else(survival > 800, 800, survival),
         status = if_else(survival == 800, 0, 1)) %>%
  filter(survival >= 6) %>%
  sample_n(size = n) %>% 
  mutate(randomization = sample(rep(c("placebo", "treatment"), each = n/2), 
                                n(), 
                                replace = FALSE))



#### Search for corresponding model parameters ####
load("data/isosurface.RData")

func_survival_to_param <- function(survival_value){
  df %>% 
    filter(survival == survival_value) %>% 
    select(-survival) %>%
    sample_n(size = 1, replace = TRUE) %>% 
    flatten_dbl()
}

survival_params <- future_map(.x = surv_vals_weibull_mdl$survival, 
                              .f = func_survival_to_param, 
                              .progress = TRUE, .options = furrr_options(seed = TRUE))


survival_params <- do.call(rbind, survival_params) %>%
  as_tibble(.name_repair = ~ c("growth_rate", "drift", "growth_decay")) %>%
  bind_cols(randomization = surv_vals_weibull_mdl$randomization, 
            status = surv_vals_weibull_mdl$status) %>%
  mutate(immuno_effect = if_else(randomization == "placebo", 1, 7), 
         chemo_effect = if_else(randomization == "placebo", 1, 0.8)) %>%
  cbind(OS = surv_vals_weibull_mdl$survival, .)

save(survival_params, file = "data/lookup_table_parameters.RData")




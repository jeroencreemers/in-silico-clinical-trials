library(tidyverse)
library(bshazard)

load("data/figure_3e_dataset.RData")
################################################################################################
### Figure 3E: Hazard plot data (panel 2) ###
################################################################################################
# Sample n patients per arm in a dataframe
df <- df %>%
  group_by(randomization) %>% 
  sample_n(size = 100000) %>% 
  ungroup()

# Estimate the hazard functio non-parametrically from a survival object
fit_placebo <- bshazard(Surv(OS, status)~1, data = df[df$therapy=="immuno", ], nbin = 48, lambda = 10000, alpha = 1) # two week bins
fit_treatment <- bshazard(Surv(OS, status)~1, data = df[df$therapy=="firstchemo_thenimmuno", ], nbin = 48, lambda = 10000, alpha = 1)

# Create dataframe with hazard estimates and confidence intervals
hazards_df <- data.frame(time_treated = fit_treatment$time, 
                         hazard_arm_treated = fit_treatment$hazard,
                         ci_low_arm_treated = fit_treatment$lower.ci, 
                         ci_high_arm_treated = fit_treatment$upper.ci,
                         time_placebo = fit_placebo$time,
                         hazard_arm_placebo = fit_placebo$hazard, 
                         ci_low_arm_placebo = fit_placebo$lower.ci, 
                         ci_high_arm_placebo = fit_placebo$upper.ci)

# Check if time columns are similar (then remove one) -> in large samples 
# times columns will be similar, otherwise, timepoints need to be interpolated.
# Interpolation code is not yet written in this scripts. 
if(all.equal(hazards_df$time_treated, hazards_df$time_placebo)){
  hazards_df <- hazards_df %>% 
    mutate(time = time_treated) %>%
    select(-c(time_treated, time_placebo))
}

# Convert to tidy dataframe
figure_3e_data_panel_2 <- pivot_longer(hazards_df, -time, names_sep = "_arm_", names_to = c(".value", "arm"))

save(figure_3e_data_panel_2, file = "data/figure_3e_data_panel_2.RData")


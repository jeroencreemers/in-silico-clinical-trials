### Figure 3B - Panel 3: Proportional Hazard Plot - Data ###
library(tidyverse)
library(survival)

# Calculate the proportional hazard
load("data/lookup_table_survival_immuno.RData")

res.cox <- coxph( Surv(OS, status) ~ as.factor(randomization), data = df)
res.cox
prop_haz <- summary(res.cox)$coefficients[2]

#Calculcate the hazard ratio over time
load("data/figure_3b_data_panel_2.RData")

df <- figure_3b_data_panel_2

df_placebo <- df %>% filter(arm == "placebo")
df_treatment <- df %>% filter(arm == "treated")

hazard_ratio <- df_treatment$hazard/df_placebo$hazard

df_placebo <- cbind(df_placebo, hazard_ratio)
df_treatment <- cbind(df_treatment, hazard_ratio)

ratio_df <- full_join(df_placebo, df_treatment)

save(ratio_df, prop_haz, file = "data/figure_3b_data_panel_3.RData")
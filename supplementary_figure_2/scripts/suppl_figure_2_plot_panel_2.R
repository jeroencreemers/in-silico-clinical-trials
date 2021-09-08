### Suppl. Figure 2 Panel 2 Plot ###
library(ggplot2)

source("scripts/theme.R")

load("data/suppl_figure_2_data_panel_2.RData")

suppl_figure_2_panel_2 <- ggplot(suppl_figure_2_data_panel_2, aes(x = time)) +
  geom_ribbon(aes(ymin = ci_low, ymax = ci_high, group = arm), alpha = 0.2) +
  geom_line(aes(y = hazard, col = arm)) +
  scale_color_manual(values = c("grey", "black")) +
  scale_x_continuous(name = "Time (months)", breaks = seq(0, 24, 4)*30.44, labels = seq(0,24, 4)) + 
  scale_y_continuous(name = "Hazard Estimate", limits = c(0,0.003)) +
  mytheme 

save(suppl_figure_2_panel_2, file = "data/suppl_figure_2_panel_2.RData")
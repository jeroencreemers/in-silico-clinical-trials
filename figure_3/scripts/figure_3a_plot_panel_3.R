### Figure 3A Panel 3 Plot ###
library(ggplot2)

source("scripts/theme.R")

load("data/figure_3a_data_panel_3.RData")

figure_3a_panel_3 <- ggplot() +
  geom_line(data = ratio_df, aes(x = time, y = hazard_ratio), col = "grey") +
  geom_hline(yintercept = 1, size = 0.3, linetype = 2, col = "grey50") +
  geom_segment(aes(x = 730, y = 1, xend = 730, yend = 2), arrow = arrow(length = unit(0.1, "cm")), col = "grey50") +
  geom_segment(aes(x = 730, y = 1, xend = 730, yend = 0.5), arrow = arrow(length = unit(0.1, "cm")), col = "grey50") +
  geom_point(aes(x = 730, y = 1), size = 0.5) +
  annotate( "point", y=prop_haz, x = -Inf, col = "red") +
  scale_x_continuous(name = "Time (months)", breaks = seq(0, 24, 4)*30.44, labels = seq(0,24, 4), limits = c(0, (2*365))  ) + 
  scale_y_continuous(name = "Hazard ratio", trans = "log10", limits = c(0.2, 3), breaks = c(.3, .5, 1, 2, 3)) +
  mytheme +
  annotate("text", x=730, y=2.5, label= "C", size = 2.5) +
  annotate("text", x=730, y=0.4, label= "T", size = 2.5) +
  coord_cartesian(clip = "off")

save(figure_3a_panel_3, file = "data/figure_3a_panel_3.RData")
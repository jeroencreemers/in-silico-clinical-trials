### Figure 3 - Panel D ###
library(patchwork)
library(ggplot2)

load("data/figure_3d_panel_1.RData")
load("data/figure_3d_panel_2.RData")
load("data/figure_3d_panel_3.RData")

(figure_3d_panel_1 + figure_3d_panel_2 + figure_3d_panel_3)

ggsave(filename = "plots/figure_3D.pdf", plot = last_plot(), width = 16, height = 4, units = "cm", useDingbats = FALSE)
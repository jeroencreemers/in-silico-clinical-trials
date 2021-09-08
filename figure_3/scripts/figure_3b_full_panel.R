### Figure 3 - Panel B ###
library(patchwork)
library(ggplot2)

load("data/figure_3b_panel_1.RData")
load("data/figure_3b_panel_2.RData")
load("data/figure_3b_panel_3.RData")

(figure_3b_panel_1 + figure_3b_panel_2 + figure_3b_panel_3)

ggsave(filename = "plots/figure_3B.pdf", plot = last_plot(), width = 16, height = 4, units = "cm", useDingbats = FALSE)
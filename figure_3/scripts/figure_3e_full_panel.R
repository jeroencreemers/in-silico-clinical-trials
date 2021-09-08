### Figure 3 - Panel E ###
library(patchwork)
library(ggplot2)

load("data/figure_3e_panel_1.RData")
load("data/figure_3e_panel_2.RData")
load("data/figure_3e_panel_3.RData")

(figure_3e_panel_1 + figure_3e_panel_2 + figure_3e_panel_3)

ggsave(filename = "plots/figure_3E.pdf", plot = last_plot(), width = 16, height = 4, units = "cm", useDingbats = FALSE)
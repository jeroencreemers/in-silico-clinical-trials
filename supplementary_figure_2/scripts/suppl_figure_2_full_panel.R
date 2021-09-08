### Supplementary figure 2 ###
library(patchwork)
library(ggplot2)

load("data/suppl_figure_2_panel_1.RData")
load("data/suppl_figure_2_panel_2.RData")
load("data/suppl_figure_2_panel_3.RData")

(suppl_figure_2_panel_1 + suppl_figure_2_panel_2 + suppl_figure_2_panel_3)

ggsave(filename = "plots/suppl_figure_2.pdf", plot = last_plot(), width = 16, height = 4, units = "cm", useDingbats = FALSE)
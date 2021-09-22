### Figure 5B1 - Plot ###
library(ggplot2)

source("scripts/theme.R")
dir.create(file.path(getwd(), "plots"), showWarnings = FALSE)
load("data/figure_5b1.RData")

ggplot(power_microsimulation, aes(x = timepoint, y = power_microsimulation, linetype = as.factor(arm_size))) + 
  geom_line() +
  geom_point(size = 1) +
  geom_hline(yintercept = 80, linetype = "dotted", col = "grey") +
  scale_x_continuous(name = "OS endpoint (months)", breaks = 30.44*seq(3, 24, 3), labels = seq(3, 24, 3)) +
  scale_y_continuous(name = "Power (%)", limits = c(0, 100), breaks = seq(0, 100, 20)) +
  scale_linetype_discrete(name = "Study arm size") +
  mytheme +
  theme(legend.position = "bottom", 
        legend.title = element_text()) + 
  guides(linetype = guide_legend(title.position = "top"))

ggsave(filename = "plots/figure_5B1.pdf", plot = last_plot(), width = 6, height = 6, units = "cm", useDingbats = FALSE)

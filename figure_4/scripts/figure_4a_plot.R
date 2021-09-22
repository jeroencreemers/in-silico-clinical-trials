##########################################################
### Figure 4A - Plot ###
library(ggplot2)

load("data/figure_4a_data.RData")
dir.create(file.path(getwd(), "plots"), showWarnings = FALSE)
source("scripts/theme.R")

# Plot
ggplot(df, aes(x = arm_size, y = power, lty = ID)) +
  geom_line() +
  geom_point(size = 1) +
  geom_hline(yintercept = 80, lty = "dashed", col = "grey") +
  scale_x_continuous(name = "Patients per arm (n)", breaks = c(50, seq(100, 600, 100))) +
  scale_y_continuous(name = "Power (%)", breaks = seq(10, 100, 10)) +
  scale_linetype_manual(labels = c("Log-rank test", "Pearson's chi-squared test"), 
                        values = c(1,2)) +
  mytheme +
  theme(plot.margin = margin(0,0,0,0, "mm"),
        legend.position = "bottom", 
        legend.margin = margin(0, 0, 0, 0))
  

ggsave(filename = "plots/figure_4A.pdf", plot = last_plot(), width = 6.5, height = 5, units = "cm", useDingbats = FALSE)
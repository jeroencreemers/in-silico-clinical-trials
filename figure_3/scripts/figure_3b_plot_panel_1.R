### Figure 3B Panel 1 Plot ###
library(ggplot2)
library(survival)

source("scripts/theme.R")

load("data/figure_3b_data_panel_1.RData")

fit <- survfit(Surv(OS, status)~randomization, data = simulated_data)

figure_3b_panel_1 <- survminer::ggsurvplot(fit = fit, palette = c("grey", "red"), 
                                            break.x.by = 4*30.44, xlim = c(0, 24.1*30.44),
                                            conf.int = FALSE, risk.table = FALSE, size = 0.5,
                                            censor.shape = 124, censor.size = 2,
                                            legend = "none", fontsize = 2.5)$plot + 
  scale_x_continuous(name = "Time (months)",  breaks = seq(0, 24, 4)*30.44, labels = seq(0,24, 4)) +
  scale_y_continuous(name = "Proportion Alive", breaks = seq(0,1,0.2)) + 
  mytheme +
  coord_cartesian(xlim = c(0, 24*30.44)) +
  annotate("text", x = 0, y = c(0.02, 0.12), label = c("C", "T"), size = 2, col = c("grey", "red")) +
  geom_segment(x = 40, y = 0.11, xend = 730, yend = 0.11, size = 0.4, lineend = "round", col = "red")

save(figure_3b_panel_1, file = "data/figure_3b_panel_1.RData")
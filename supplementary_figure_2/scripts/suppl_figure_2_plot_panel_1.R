### Suppl. Figure 2 Panel 1 Plot ###
library(ggplot2)
library(survival)

source("scripts/theme.R")

load("data/suppl_figure_2_data_panel_1.RData")

fit <- survfit(Surv(OS, status)~randomization, data = simulated_data)

suppl_figure_2_panel_1 <- survminer::ggsurvplot(fit = fit, palette = c("grey", "black"), 
                                            break.x.by = 4*30.44, xlim = c(0, 24.1*30.44),
                                            conf.int = FALSE, risk.table = FALSE, size = 0.5,
                                            censor.shape = 124, censor.size = 2,
                                            legend = "none", fontsize = 2.5)$plot + 
  scale_x_continuous(name = "Time (months)",  breaks = seq(0, 24, 4)*30.44, labels = seq(0,24, 4)) +
  scale_y_continuous(name = "Proportion Alive", breaks = seq(0,1,0.2)) + 
  mytheme +
  coord_cartesian(xlim = c(0, 24*30.44)) +
  annotate("text", x = 0, y = c(0.02, 0.12), label = c("C", "T"), size = 2, col = c("grey", "black")) +
  geom_segment(x = 40, y = 0.11, xend = 730, yend = 0.11, size = 0.4, lineend = "round")

save(suppl_figure_2_panel_1, file = "data/suppl_figure_2_panel_1.RData")
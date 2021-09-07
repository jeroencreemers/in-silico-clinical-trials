library(ggplot2)
library(dplyr)
library(survminer)
library(survival)

source("../../misc/theme.R")
load("data/figure_1f_data.RData")


fit<- survfit( Surv(OS, status)~randomization, data = simulated_data)

res <- ggsurvplot(fit, data = simulated_data, palette = c("black", "red"), 
                  break.x.by = 3*30.44, xlim = c(0, 24.1*30.44),
                  conf.int = FALSE, risk.table = TRUE, size = 0.5,
                  censor.shape = 124, censor.size = 2,
                  legend = "none", fontsize = 2.5, 
                  surv.median.line = "hv")

res$table <- res$table + 
  theme_survminer(font.tickslab = 8) +
  theme(axis.line = element_blank(), 
        axis.ticks = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_blank(), 
        axis.title.x = element_blank(), 
        axis.title.y = element_blank()) +
  scale_y_discrete(labels = c("DTIC", "Nivo"), limits = rev)

res$plot <- res$plot + 
  scale_x_continuous(name = "Time (months)",  breaks = seq(0, 24, 3)*30.44, labels = seq(0,24, 3)) +
  scale_y_continuous(name = "Proportion Alive", breaks = seq(0,1,0.2)) + 
  mytheme +
  theme(axis.title.y = element_blank()) +
  coord_cartesian(xlim = c(0, 24*30.44))

ggsave(filename = "plots/figure_1f.pdf", plot = print(res, newpage = FALSE), width = 6, height = 5, units = "cm", useDingbats = FALSE)
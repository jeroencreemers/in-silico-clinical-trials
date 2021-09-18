library(ggplot2)
library(dplyr)
library(survminer)
library(survival)

source("../misc/theme.R")
load("data/figure_1a_KM_NCCTG.RData")

fit<- survfit( Surv(time, status)~1, data = data)

res <- ggsurvplot(fit, data = data, break.x.by = 4*30.44, palette = "black",
                  conf.int = FALSE, risk.table = TRUE, size = 0.5,
                  censor.shape = 124, censor.size = 2,
                  legend = "none", fontsize = 2.5,
                  surv.median.line = "hv")

res$table <- res$table + 
  theme_survminer(font.tickslab = 8) +
  theme(axis.line = element_blank(), 
        axis.ticks = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_text(size = 8, hjust = -0.2), 
        axis.title.x = element_blank(), 
        axis.title.y = element_blank()) +
  scale_y_discrete(labels = c("NCCTG")) +
  ggtitle("No. at risk") 

res$plot <- res$plot + 
  scale_x_continuous(name = "Time (months)",  breaks = seq(0, 24, 4)*30.44, labels = seq(0,24, 4)) +
  scale_y_continuous(name = "Proportion Alive", breaks = seq(0,1,0.2)) + 
  mytheme +
  coord_cartesian(xlim = c(0, 24*30.44))

ggsave(filename = "plots/plot_lung_ncctg.pdf", plot = print(res, newpage = FALSE), width = 6, height = 5, units = "cm", useDingbats = FALSE)

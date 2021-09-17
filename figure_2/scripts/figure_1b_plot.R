library(ggplot2)
library(survminer)
library(survival)
library(dplyr)

source("../misc/theme.R")

load("data/figure_1b_KM_melanoma.RData")

res <- ggsurvplot(fit = fit, data = df, palette = c("red", "black"),
                  conf.int = FALSE, risk.table = TRUE, size = 0.5, 
                  censor.shape = 124, censor.size = 2,  legend = "none",  
                  xlim = c(0,24.1), break.x.by = 4, fontsize = 2.5, 
                  surv.median.line = "hv") 

res$table <- res$table + 
  theme_survminer(font.tickslab = 8) +
  theme(axis.line = element_blank(), 
        axis.ticks = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_blank(), 
        axis.title.x = element_blank(), 
        axis.title.y = element_blank()) +
  scale_y_discrete(labels = c("DTIC", "Ipi+DTIC"))

res$plot <- res$plot + 
  scale_x_continuous(name = "Time (months)", breaks = seq(0, 24, 4), labels = seq(0,24, 4)) +
  scale_y_continuous(breaks = seq(0,1,0.2)) + 
  mytheme +
  theme(axis.title.y = element_blank()) +
  coord_cartesian(xlim = c(0, 24))

ggsave(filename = "plots/figure_1b_ipi_placebo.pdf", plot = print(res, newpage = FALSE), width = 6, height = 5, units = "cm", useDingbats = FALSE)

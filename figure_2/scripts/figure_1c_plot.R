library(survminer)
library(survival)
library(dplyr)

source("../misc/theme.R")

load("data/figure_1c_KM_melanoma.RData")

res <- ggsurvplot(fit = fit, data = df, palette = c("black", "red"), 
                  conf.int = FALSE, risk.table = TRUE, size = 0.5, 
                  censor.shape = 124, censor.size = 2,  legend = "none",  
                  break.x.by = 3, fontsize = 2.5, surv.median.line = "hv") 

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
  scale_x_continuous(name = "Time (months)",  breaks = seq(0, 24, 3), labels = seq(0,24, 3)) +
  scale_y_continuous(breaks = seq(0,1,0.2)) + 
  mytheme +
  theme(axis.title.y = element_blank()) +
  coord_cartesian(xlim = c(0, 24))

ggsave(filename = "plots/figure_1c_dtic_nivo.pdf", plot = print(res, newpage = FALSE), width = 6, height = 5, units = "cm", useDingbats = FALSE)

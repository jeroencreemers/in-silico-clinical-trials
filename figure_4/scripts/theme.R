library(ggplot2)
library(grid)

#General plotting theme
mytheme <-  theme_classic() +
  theme(
    line=element_line(size=2),
    text=element_text(size=8, color = "black"),
    axis.line.x=element_line(size=0.3, color = "black"),
    axis.line.y=element_line(size=0.3, color = "black"),
    axis.ticks=element_line(size=0.3, color = "black"),
    
    legend.position = "None", 
    plot.title = element_text(hjust = 0.5, size = 9, face = "bold"), 
    axis.text = element_text(size = 8, color = "black"),
    axis.title = element_text(size = 8),
    axis.text.y = element_text(hjust = 0),
    legend.text = element_text(size = 8), 
    #legend.title = element_text(size = 10),
    legend.title=element_blank(),
    #plot.margin = margin(1,1,1,1, "cm"),
    plot.margin = unit(c(0.3,0.5,0.3,0.3), "lines")
  )

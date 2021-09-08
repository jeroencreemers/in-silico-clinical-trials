################################################################################
#### Figure 6B - Plot ####
################################################################################
library(tidyverse)
library(ggsankey)
library(cowplot)

load("data/figure_6b_wrangled.RData")

# Function to prepare dataset for plot
prepare_dataset <- function(x){
  df <- data %>% 
    filter(total_analyses == x) %>% 
    select(-total_analyses) %>% 
    modify_at(c("BL", "1", "2", "3", "4", "5"), factor) %>% 
    make_long("BL","1", "2", "3", "4", "5")
  
  # Compute counts per node
  df_nr <- df %>% 
    filter(!is.na(node)) %>% 
    group_by(x, node)%>% 
    summarise(count = n())
  
  # Join counts per node to Sankey dataframe
  df <- df %>% left_join(df_nr) %>% filter(!is.na(count))
  return(df)
}

data_lst <- map(1:4, prepare_dataset)

create_plot <- function(dataset){
  ggplot(as.data.frame(data_lst[dataset]), aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = factor(node), label = count)) +
    geom_sankey(flow.alpha = .2) +
    geom_sankey_label(aes(fill = factor(node)), size = 2, color = "white") +
    theme_sankey(base_size = 10) +
    scale_x_discrete(name = "Time (months)", labels = seq(0, 24, 24/dataset) ) + 
    theme(legend.position = "none", legend.title = element_blank()) +
    scale_fill_manual(values = c("grey", "deepskyblue2", "red"), labels = c("Running", "Positive", "Negative")) 
}

one_analysis <- create_plot(1) 
two_analyses <- create_plot(2) + 
  scale_fill_manual(values = c("red", "grey", "deepskyblue2"), labels = c("Running", "Positive", "Negative"))
three_analyses <- create_plot(3)
four_analyses <- create_plot(4) + 
  scale_fill_manual(values = c("red", "grey", "deepskyblue2"), labels = c("Running", "Positive", "Negative"))

p <- plot_grid(one_analysis, two_analyses, three_analyses, four_analyses, ncol = 4, align = "v")

ggsave("plots/figure_6b.pdf", plot = p, width = 18, height = 4, units = "cm", useDingbats = FALSE)

library(tidyverse)
library(oce)

load("data/data_grid_microsimulation.RData")

###############################################################################
# Create an array with values
size_R <- n_distinct(data$R) #length(unique(...))
size_drift_R <- n_distinct(data$drift_r)
size_decay_rate <- n_distinct(data$growth_decay) 

dimensions <- c(size_R, size_drift_R, size_decay_rate)

data <- data[order(data$growth_decay, data$drift_r, data$R),]

OS <- data$OS

v <- array(data = OS, dim=dimensions)

vR <- array( data=data$R, dim=dimensions )
vDrift <- array( data=data$drift_r, dim=dimensions )
vDecay <- array( data=data$growth_decay, dim=dimensions )

isosurface <- function(level){
  isosurface <- misc3d::computeContour3d(vol = v,
                                 maxvol = max(v), 
                                 level = level) %>%
    as.data.frame() %>%
    distinct() %>% # remove duplicate rows
    rowwise() %>% 
    mutate(R = approx3d(seq_len(size_R), seq_len(size_drift_R), seq_len(size_decay_rate), vR, V1, V2, V3), 
           drift_r = approx3d(seq_len(size_R), seq_len(size_drift_R), seq_len(size_decay_rate), vDrift, V1, V2, V3), 
           decay_rate = approx3d(seq_len(size_R), seq_len(size_drift_R), seq_len(size_decay_rate), vDecay, V1, V2, V3)) %>%
    na.omit() %>% # Remove rows with NAs
    select(-c(V1, V2, V3)) %>% 
    ungroup() %>%
    rownames_to_column(var = "id") %>% 
    mutate(id = as.numeric(id))

  return(isosurface)
}

level_vals = seq(5, 800, 1) #max 800 days

df <- level_vals %>%
  set_names() %>% 
  map_df(., .f= isosurface, .id = "level_vals") %>% 
  mutate(level_vals = as.numeric(level_vals))

save(df, file = "data/isosurface.RData")
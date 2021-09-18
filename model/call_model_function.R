#
# Function to call C++ model from within R. This function is called from within the subfolders of the  
# "figure[n]/"-folders.
#

call.model <- function(R=5, xi=0.001, 
                       stochastic_killing=0, stochastic_growth=0, 
                       raise_killing=1, 
                       treatment_duration=730, 
                       drift_r=0, 
                       drift_xi=0, 
                       seed = 0, 
                       diagnosis_threshold = 65*1e8, 
                       growth_decay = 0, 
                       lower_growth = 1, 
                       chemo_duration=182, 
                       immuno_start=0, 
                       chemo_start=0,
                       path.to.model="../model/tumormodel"){
	require( dplyr )
  read.table(text=system2(path.to.model, c("--R",R,
                                                    "--xi",xi,
                                                    "--stochastic-killing", stochastic_killing, 
                                                    "--stochastic-growth", stochastic_growth, 
                                                    "--raise-killing", raise_killing, 
                                                    "--treatment-duration", treatment_duration, 
                                                    "--drift-R", drift_r, 
                                                    "--drift-xi", drift_xi, 
                                                    "--seed", seed, 
                                                    "--diagnosis-threshold", diagnosis_threshold, 
                                                    "--growth-decay", growth_decay, 
                                                    "--lower-growth", lower_growth, 
                                                    "--chemo-duration", chemo_duration,
                                                    "--immuno-start", immuno_start,
                                                    "--chemo-start", chemo_start), 
                          stdout=T)) %>% 
    
    # Rename variables 
    rename(time=V1, 
           R = V2, 
           xi = V3, 
           drift_r = V4,
           decay_rate = V5,
           tumor_cells = V6, 
           immune_cells = V7, 
           specific_cells = V8, 
           naive_cells = V9) %>%
    
    # Add diagnosis threshold and time of diagnosis to dataframe
    mutate(diagnosis_threshold = diagnosis_threshold, 
           time_diagnosis = time[tumor_cells > diagnosis_threshold][1]) %>%
    
    # Remove unnecessary rows from dataframe: 
    # if no diagnosis: simulation output = 5 years (1:1825)
    # if diagnosis: follow-up = 5 years, simulation output = time of diagnosis + 5 years
    slice(if(is.na(time_diagnosis[1])) 1:1825 else 1:(time_diagnosis[1] + 1825)) %>% 
    
    # Add column with overall survival
    mutate(OS = ifelse(test = is.na(time_diagnosis[1]), # test if time_diagnosis == NA
                       yes = NA,                        # OS = NA
                       no = length(time) - time_diagnosis[1]), # OS = time from diagnosis to end of simulation (either death or uncensored)
           status = if_else(OS[1] == 1825, true = 0, false = 1)
           ) 
}

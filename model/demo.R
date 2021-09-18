
## Demonstration of the model.

## This demo will call the model and perform a virtual "clinical trial" with random allocation 
## of patients to treatment. The results will be visualized as a Kaplan-Meier curve.

source("call_model_function.R")

set.seed( 42 )

# This function determines just the overall survival of a simulated
# patient as a function of the tumor growth rate and the immunotherapy effect size.
get.os <- Vectorize( function( R=5, raise_killing=1 ){
	x <- call.model( R=R, raise_killing=raise_killing, seed= )
	x[1,"OS"]
} )

# Simulate a trial with 70 patients in the control arm and 140 patients in the immunotherapy arm.
immunotherapy <- c(rep(0,70),rep(1,140))

# Raise the immune system killing rate by a factor of 50 for treated patients. 
# Sample the tumor growth rate for each patient from a heavy-tailed distribution.
# Generate survival data for each patient.
os <- get.os(R=rgamma( 210, 1.5, .25 ), raise_killing=50*immunotherapy)

# Patients who don't die from the tumor get assigned "infinite" survival.
status <- as.integer(!is.na( os ))
os[is.na(os)] <- Inf

# Plot survival curves for treated and untreated patients.
plot(survfit( Surv( os, status ) ~ immunotherapy ), col=1:2, xlim=c(0,2*365),
	xlab="time from diagnosis (days)", ylab="survival")

legend( "topright", c("control","treatment"), lty=1, col=c("black","red") )

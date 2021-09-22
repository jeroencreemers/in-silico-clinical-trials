# Simulation model for cancer immunotherapy and chemotherapy trials 

This repository contains code and data related to the following manuscript: 

_In silico_ cancer immunotherapy trials uncover the consequences of therapy-specific response patterns for clinical trial design and outcome
Jeroen H.A. Creemers, Kit C.B. Roes, Niven Mehra, Carl G. Figdor, I. Jolanda M. de Vries, Johannes Textor
medRxiv 2021.09.09.21263319; doi: https://doi.org/10.1101/2021.09.09.21263319

The manuscript proposes a simulation model for cancer patient survival data with different immunotherapy treatments. This repository contains the source code of the [simulation model itself](model/model.cpp), which is written in C++, as well as [R scripts to call the simulation model](model/call_model_function.R) from within R. Further, there is one folder for each data figure in the paper that contains all code an (possibly) external data required to reproduce the plots shown in that figure.

## System requirements

The model should run on any system that has a C++ compiler supporting the C++11 standard (for instance, the GNU C++ compiler version 9 or Apple's clang version 10). The ``boost'' libraries are required; these are shipped with most modern C++ compilers. You can compile the model [using the provided Makefile](model/Makefile), which has been tested on Mac OS X Mojave (10.14.6) and Ubuntu Linux bionic (18.04).

To run the compiled model from within R, you need R and the dplyr package installed. This has been tested on R version 4.0.1 and the dplyr package version 1.0.7, but it should work using earlier versions of R and dplyr as well.


## Installation

No installation is required to run this software, but you do need to compile the [simulation model](model/model.cpp). Since this is just a single file, it should only take a couple of seconds on a reasonably modern computer.

## Demo and instructions

The [provided demo script in R](model/demo.R) shows an example how you can run the simulation model to generate a virtual immunotherapy trial with 140 patients in the treatment arm and 70 patients in the control arm. This should generate a Kaplan-Meier plot showing a favourable effect of the treatment. You can change the difference between the curves by setting the treatment effect size to a different value. Simulating 210 patients should take less than a minute on a typical desktop computer. 

To adapt the demo to change further parameter settings, have a look at [the R function that calls the simulation model](model/call_model_function.R), which lists all parameters. See the manuscript for the default values we used. Typically you will want to generate parameters randomly by drawing their values from some distribution that models heterogeneity between patients; for instance, in our demo, we use a Gamma distribution to generate a tumor growth rate for each patient.

## List of R packages

- Tidyverse collection of packages
- survival (version 3.2-7)
- survminer (version 0.4.8)
- flexsurv (1.1.1)
- IPDfromKM (version 0.1.10)
- oce (version 1.3-0)
- bshazard (version 1.1)
- patchwork (version 1.1.1)
- cowplot (version 1.1.1)

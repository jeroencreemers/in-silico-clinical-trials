# in-silico-clinical-trials

This repository contains code and data related to the following manuscript: 

_In silico_ cancer immunotherapy trials uncover the consequences of therapy-specific response patterns for clinical trial design and outcome
Jeroen H.A. Creemers, Kit C.B. Roes, Niven Mehra, Carl G. Figdor, I. Jolanda M. de Vries, Johannes Textor
medRxiv 2021.09.09.21263319; doi: https://doi.org/10.1101/2021.09.09.21263319

The manuscript proposes a simulation model for cancer patient survival data with different immunotherapy treatments. This repository contains the source code of the [simulation model itself](model/model.cpp), which is written in C++, as well as [R scripts to call the simulation model](model/call_model_function.R) from within R. Further, there is one folder for each data figure in the paper that contains all code an (possibly) external data required to reproduce the plots shown in that figure.

## System requirements

The model should run on any system that has a decent C++ compiler. 

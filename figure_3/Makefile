.DELETE_ON_ERROR: # If error, then generated files will be deleted
.SECONDARY:
### This makefile generates figure 3 for the microsimulation paper ###
# It shows how a microsimulation can predict the hazard function of a clinical
# trial
#
# R packages: tidyverse, survival, furrr, flexsurv,
#							survminer, bshazard, patchwork
#

# List all target files, that this makefile should generate
all : ../model/tumormodel \
			plots/figure_3.pdf

../model/tumormodel : ../model/model.cpp
	cd ../model && make

###################################################################
###################################################################
# First lookup tables are constructed from which the parameter
# values that lead to a specific survival can be derived,
# omitting the need to run the microsimulation repeatedly.

# The first lookup table contains the parameter values and survival times,
# which are derived from the isosurface.
# data/lookup_table_parameters.RData : scripts/lookup_table_parameters.R \
# 																 		 data/digitized_data.RData \
# 															 	 	 	 data/isosurface.Rdata
# 	Rscript $<

# The next three lookup tables contain the simulated survival times (untreated
# and treated) of patients in different studies (chemo vs. placebo, immuno vs.
# placebo and chemoimmuno vs. placebo)
# data/lookup_table_survival_chemo.RData : scripts/lookup_table_survival_chemo.R \
# 																						 data/lookup_table_parameters.RData \
# 																						 ../model/call_model_function.R
# 	Rscript $<
#
# data/lookup_table_survival_immuno.RData : scripts/lookup_table_survival_immuno.R \
# 																						 data/lookup_table_parameters.RData \
# 																						 ../model/call_model_function.R
# 	Rscript $<
#
# data/lookup_table_survival_chemoimmuno.RData : scripts/lookup_table_survival_chemoimmuno.R \
# 																						 data/lookup_table_parameters.RData \
# 																						 ../model/call_model_function.R
# 	Rscript $<

###################################################################
# NOTE: Data are also provided to prevent the need to run the simulation again.
###################################################################

######## Figure 3A panel 1 ########
data/figure_3a_data_panel_1.RData : scripts/figure_3a_data_panel_1.R \
																		data/lookup_table_survival_chemo.RData
	Rscript $<

data/figure_3a_panel_1.RData : scripts/figure_3a_plot_panel_1.R \
															 data/figure_3a_data_panel_1.RData \
															 scripts/theme.R
	Rscript $<

# ######## Figure 3A panel 2 ########
data/figure_3a_data_panel_2.RData : scripts/figure_3a_data_panel_2.R \
																		data/lookup_table_survival_chemo.RData
	Rscript $<

data/figure_3a_panel_2.RData : scripts/figure_3a_plot_panel_2.R \
															 data/figure_3a_data_panel_2.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3A panel 3 ########
data/figure_3a_data_panel_3.RData : scripts/figure_3a_data_panel_3.R \
																		data/lookup_table_survival_chemo.RData \
																		data/figure_3a_data_panel_2.RData
	Rscript $<

data/figure_3a_panel_3.RData : scripts/figure_3a_plot_panel_3.R \
															 data/figure_3a_data_panel_3.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3A full panel ########
plots/figure_3A.pdf : scripts/figure_3a_full_panel.R \
											data/figure_3a_panel_1.RData \
											data/figure_3a_panel_2.RData \
											data/figure_3a_panel_3.RData
	Rscript $<

###################################################################

######## Figure 3B panel 1 ########
data/figure_3b_data_panel_1.RData : scripts/figure_3b_data_panel_1.R \
																		data/lookup_table_survival_immuno.RData
	Rscript $<

data/figure_3b_panel_1.RData : scripts/figure_3b_plot_panel_1.R \
															 data/figure_3b_data_panel_1.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3B panel 2 ########
data/figure_3b_data_panel_2.RData : scripts/figure_3b_data_panel_2.R \
																		data/lookup_table_survival_immuno.RData
	Rscript $<

data/figure_3b_panel_2.RData : scripts/figure_3b_plot_panel_2.R \
															 data/figure_3b_data_panel_2.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3B panel 3 ########
data/figure_3b_data_panel_3.RData : scripts/figure_3b_data_panel_3.R \
																		data/lookup_table_survival_immuno.RData \
																		data/figure_3b_data_panel_2.RData
	Rscript $<

data/figure_3b_panel_3.RData : scripts/figure_3b_plot_panel_3.R \
															 data/figure_3b_data_panel_3.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3B full panel ########
plots/figure_3B.pdf : scripts/figure_3b_full_panel.R \
											data/figure_3b_panel_1.RData \
											data/figure_3b_panel_2.RData \
											data/figure_3b_panel_3.RData
	Rscript $<
###################################################################

######## Figure 3C panel 1 ########
data/figure_3c_dataset.RData : scripts/figure_3c_dataset.R \
															 data/lookup_table_survival_chemoimmuno.RData \
														 	 data/lookup_table_survival_chemo.RData
	Rscript $<

data/figure_3c_data_panel_1.RData : scripts/figure_3c_data_panel_1.R \
																		data/figure_3c_dataset.RData
	Rscript $<

data/figure_3c_panel_1.RData : scripts/figure_3c_plot_panel_1.R \
															 data/figure_3c_data_panel_1.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3C panel 2 ########
data/figure_3c_data_panel_2.RData : scripts/figure_3c_data_panel_2.R \
																		data/figure_3c_dataset.RData
	Rscript $<

data/figure_3c_panel_2.RData : scripts/figure_3c_plot_panel_2.R \
															 data/figure_3c_data_panel_2.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3C panel 3 ########
data/figure_3c_data_panel_3.RData : scripts/figure_3c_data_panel_3.R \
																		data/figure_3c_dataset.RData \
																		data/figure_3c_data_panel_2.RData
	Rscript $<

data/figure_3c_panel_3.RData : scripts/figure_3c_plot_panel_3.R \
															 data/figure_3c_data_panel_3.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3C full panel ########
plots/figure_3C.pdf : scripts/figure_3c_full_panel.R \
											data/figure_3c_panel_1.RData \
											data/figure_3c_panel_2.RData \
											data/figure_3c_panel_3.RData
	Rscript $<
###################################################################
######## Figure 3D panel 1 ########
data/figure_3d_dataset.RData : scripts/figure_3d_dataset.R \
															 data/lookup_table_survival_chemo.RData \
														 	 data/lookup_table_survival_immuno.RData
	Rscript $<

data/figure_3d_data_panel_1.RData : scripts/figure_3d_data_panel_1.R \
																		data/figure_3d_dataset.RData
	Rscript $<

data/figure_3d_panel_1.RData : scripts/figure_3d_plot_panel_1.R \
															 data/figure_3d_data_panel_1.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3D panel 2 ########
data/figure_3d_data_panel_2.RData : scripts/figure_3d_data_panel_2.R \
																		data/figure_3d_dataset.RData
	Rscript $<

data/figure_3d_panel_2.RData : scripts/figure_3d_plot_panel_2.R \
															 data/figure_3d_data_panel_2.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3D panel 3 ########
data/figure_3d_data_panel_3.RData : scripts/figure_3d_data_panel_3.R \
																		data/figure_3d_dataset.RData \
																		data/figure_3d_data_panel_2.RData
	Rscript $<

data/figure_3d_panel_3.RData : scripts/figure_3d_plot_panel_3.R \
															 data/figure_3d_data_panel_3.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3D full panel ########
plots/figure_3D.pdf : scripts/figure_3d_full_panel.R \
											data/figure_3d_panel_1.RData \
											data/figure_3d_panel_2.RData \
											data/figure_3d_panel_3.RData
	Rscript $<

###################################################################

######## Figure 3E panel 1 ########
data/figure_3e_dataset.RData : scripts/figure_3e_dataset.R \
															 data/lookup_table_survival_firstchemo_thenimmuno.RData \
														 	 data/lookup_table_survival_immuno.RData
	Rscript $<

data/figure_3e_data_panel_1.RData : scripts/figure_3e_data_panel_1.R \
																		data/figure_3e_dataset.RData
	Rscript $<

data/figure_3e_panel_1.RData : scripts/figure_3e_plot_panel_1.R \
															 data/figure_3e_data_panel_1.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3E panel 2 ########
data/figure_3e_data_panel_2.RData : scripts/figure_3e_data_panel_2.R \
																		data/figure_3e_dataset.RData
	Rscript $<

data/figure_3e_panel_2.RData : scripts/figure_3e_plot_panel_2.R \
															 data/figure_3e_data_panel_2.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 3E panel 3 ########
data/figure_3e_data_panel_3.RData : scripts/figure_3e_data_panel_3.R \
																		data/figure_3e_dataset.RData \
																		data/figure_3e_data_panel_2.RData
	Rscript $<

data/figure_3e_panel_3.RData : scripts/figure_3e_plot_panel_3.R \
															 data/figure_3e_data_panel_3.RData \
															 scripts/theme.R
	Rscript $<


######## Figure 3E full panel ########
plots/figure_3E.pdf : scripts/figure_3e_full_panel.R \
											data/figure_3e_panel_1.RData \
											data/figure_3e_panel_2.RData \
											data/figure_3e_panel_3.RData
	Rscript $<


######## Combine plots ########
plots/figure_3.pdf : scripts/figure_3.tex \
											plots/figure_3A.pdf \
											plots/figure_3B.pdf \
											plots/figure_3C.pdf \
											plots/figure_3D.pdf \
											plots/figure_3E.pdf
	pdflatex -output-directory=plots/ $<


################################################################################
clean :
	rm plots/*.aux \
	plots/*.log \
	Rplots.pdf \
	data/figure_2*

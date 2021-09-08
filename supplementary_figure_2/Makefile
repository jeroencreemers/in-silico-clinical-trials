.DELETE_ON_ERROR: # If error, then generated files will be deleted
.SECONDARY:
### Supplementary figure 2 ###
#
# R packages: tidyverse, survival, furrr, flexsurv,
#							survminer, bshazard, patchwork
#

# List all target files, that this makefile should generate
all : ../model/tumormodel \
			plots/supplementary_figure_2.pdf

../model/tumormodel : ../model/model.cpp
	cd ../model && make

################################################################################
# Note: the lookup tables are constructed as for Figure 3 (see Makefile). The
# only difference between the lookup table for figure 3 and supplementary figure
# 2 is the fact that in supplementary figure 2 the chemotherapy effect lasts for
# 2 years instead of 6 months.

# To accommodate easy replication of the experiments, we have added the data
# files in the data folder.
################################################################################


######## Supplementary Figure 2 panel 1 ########
data/suppl_figure_2_data_panel_1.RData : scripts/suppl_figure_2_data_panel_1.R \
																		data/lookup_table_survival_chemo_2year_effect.RData
	Rscript $<

data/suppl_figure_2_panel_1.RData : scripts/suppl_figure_2_plot_panel_1.R \
															 data/suppl_figure_2_data_panel_1.RData \
															 scripts/theme.R
	Rscript $<

# ######## Supplementary Figure 2 panel 2 ########
data/suppl_figure_2_data_panel_2.RData : scripts/suppl_figure_2_data_panel_2.R \
																		data/lookup_table_survival_chemo_2year_effect.RData
	Rscript $<

data/suppl_figure_2_panel_2.RData : scripts/suppl_figure_2_plot_panel_2.R \
															 data/suppl_figure_2_data_panel_2.RData \
															 scripts/theme.R
	Rscript $<

######## Supplementary Figure 2 panel 3 ########
data/suppl_figure_2_data_panel_3.RData : scripts/suppl_figure_2_data_panel_3.R \
																		data/lookup_table_survival_chemo_2year_effect.RData \
																		data/suppl_figure_2_data_panel_2.RData
	Rscript $<

data/suppl_figure_2_panel_3.RData : scripts/suppl_figure_2_plot_panel_3.R \
															 data/suppl_figure_2_data_panel_3.RData \
															 scripts/theme.R
	Rscript $<

######## Figure 2A full panel ########
plots/supplementary_figure_2.pdf : scripts/suppl_figure_2_full_panel.R \
											data/suppl_figure_2_panel_1.RData \
											data/suppl_figure_2_panel_2.RData \
											data/suppl_figure_2_panel_3.RData
	Rscript $<

################################################################################
clean :
	rm plots/*.aux \
	plots/*.log \
	Rplots.pdf \
	data/figure_2*

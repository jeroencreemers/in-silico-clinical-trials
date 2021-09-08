.DELETE_ON_ERROR: # If error, then generated files will be deleted
.SECONDARY:

### Figure 4 ###
#
# R packages: tidyverse, survival, furrr, patchwork
#

# List all target files, that this makefile should generate
all : ../model/tumormodel \
			plots/figure_4.pdf

../model/tumormodel : ../model/model.cpp
	cd ../model && make

###################################################################
# The lookup tables are constructed for figure 3 (see Makefile).
# They are also provided as data files in figure_4/data
###################################################################

################################################################################
data/figure_4a_data.RData : scripts/figure_4a_data.R \
														data/lookup_table_survival_chemo.RData
	Rscript $<

plots/figure_4A.pdf : scripts/figure_4a_plot.R \
											scripts/theme.R \
											data/figure_4a_data.RData
	Rscript $<

data/figure_4b_data.RData : scripts/figure_4b_data.R \
														data/lookup_table_survival_immuno.RData
	Rscript $<

plots/figure_4B.pdf : scripts/figure_4b_plot.R \
											scripts/theme.R \
											data/figure_4b_data.RData
	Rscript $<

data/figure_4c_data.RData : scripts/figure_4c_data.R \
														data/lookup_table_survival_chemoimmuno.RData \
														data/lookup_table_survival_chemo.RData
	Rscript $<

plots/figure_4C.pdf : scripts/figure_4c_plot.R \
											scripts/theme.R \
											data/figure_4c_data.RData
	Rscript $<

data/figure_4d_data.RData : scripts/figure_4d_data.R \
														data/lookup_table_survival_chemo.RData \
														data/lookup_table_survival_immuno.RData
	Rscript $<

plots/figure_4D.pdf : scripts/figure_4d_plot.R \
											scripts/theme.R \
											data/figure_4d_data.RData
	Rscript $<

plots/figure_4.pdf : scripts/figure_4.tex \
											plots/figure_4A.pdf \
											plots/figure_4B.pdf \
											plots/figure_4C.pdf \
											plots/figure_4D.pdf
	pdflatex -output-directory=plots/ $<



clean :
	rm plots/*.aux \
	plots/*.log \
	Rplots.pdf

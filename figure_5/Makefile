.DELETE_ON_ERROR: # If error, then generated files will be deleted
.SECONDARY:

### Figure 5 ###
#
# Packages: tidyverse, survival, furrr

# List all target files, that this makefile should generate
all : ../model/tumormodel \
		plots/figure_5.pdf


../model/tumormodel : ../model/model.cpp
	cd ../model && make

###################################################################
# The lookup tables are constructed for figure 3 (see Makefile).
# They are also provided as data files in figure_5/data
###################################################################
data/figure_5a1.RData : scripts/figure_5a1_data.R \
											 data/lookup_table_survival_chemo.RData
	Rscript $<

plots/figure_5A1.pdf : scripts/figure_5a1_plot.R \
											data/figure_5a1.RData \
											scripts/theme.R
	Rscript $<
###################################################################
data/figure_5a2.RData : scripts/figure_5a2_data.R \
											 data/lookup_table_survival_chemo.RData
	Rscript $<

plots/figure_5A2.pdf : scripts/figure_5a2_plot.R \
											data/figure_5a2.RData \
											scripts/theme.R
	Rscript $<
###################################################################
data/figure_5b1.RData : scripts/figure_5b1_data.R \
											 data/lookup_table_survival_immuno.RData
	Rscript $<

plots/figure_5B1.pdf : scripts/figure_5b1_plot.R \
											data/figure_5b1.RData \
											scripts/theme.R
	Rscript $<
###################################################################
data/figure_5b2.RData : scripts/figure_5b2_data.R \
											 data/lookup_table_survival_immuno.RData
	Rscript $<

plots/figure_5B2.pdf : scripts/figure_5b2_plot.R \
											data/figure_5b2.RData \
											scripts/theme.R
	Rscript $<
###################################################################
plots/figure_5.pdf : scripts/figure_5.tex \
											plots/figure_5B1.pdf \
											plots/figure_5A1.pdf \
											plots/figure_5B2.pdf \
											plots/figure_5A2.pdf
	pdflatex -output-directory=plots/ $<

clean :
	rm plots/figure_5.aux \
	plots/figure_5.log \
	Rplots.pdf

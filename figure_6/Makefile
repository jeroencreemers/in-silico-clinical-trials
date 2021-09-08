.DELETE_ON_ERROR: # If error, then generated files will be deleted
.SECONDARY:

### Figure 6 ###

# R packages: tidyverse, survival, furrr, ldbounds, ggsankey, cowplot

# List all target files, that this makefile should generate
all : ../model/tumormodel \
		plots/figure_6.pdf

################################################################################
# Note: the lookup tables are constructed as for Figure 3 (see Makefile). The
# only difference between the lookup table for figure 6A and figures 6B/C is the
# 'Treatment effet' (i.e., the amplification factor for the T cell killing rate.
# For Figure 6A/B/C, the treatment effect is 7(=standard), 3, and 0, respectively.

# To accommodate easy replication of the experiments, we have added the data
# files in the data folder.
################################################################################


################################################################################
../../model/tumormodel : ../model/model.cpp
	cd ../model && make

################################################################################
data/figure_6a.RData : scripts/figure_6a_data.R \
												data/lookup_table_survival_immuno.RData
	Rscript $<

data/figure_6a_wrangled.RData : scripts/figure_6a_wrangling.R \
																data/figure_6a.RData
	Rscript $<

plots/figure_6a.pdf : scripts/figure_6a_plot.R \
											data/figure_6a_wrangled.RData
	Rscript $<

################################################################################
data/figure_6b.RData : scripts/figure_6b_data.R \
												data/6b_lookup_table_simulated_survival.RData
	Rscript $<

data/figure_6b_wrangled.RData : scripts/figure_6b_wrangling.R \
																data/figure_6b.RData
	Rscript $<

plots/figure_6b.pdf : scripts/figure_6b_plot.R \
											data/figure_6b_wrangled.RData
	Rscript $<

################################################################################
data/figure_6c.RData : scripts/figure_6c_data.R \
												data/6c_lookup_table_simulated_survival.RData
	Rscript $<

data/figure_6c_wrangled.RData : scripts/figure_6c_wrangling.R \
																data/figure_6c.RData
	Rscript $<

plots/figure_6c.pdf : scripts/figure_6c_plot.R \
											data/figure_6c_wrangled.RData
	Rscript $<
################################################################################


plots/figure_6.pdf : scripts/figure_6.tex \
											plots/figure_6a.pdf \
											plots/figure_6b.pdf \
											plots/figure_6c.pdf
	pdflatex -output-directory=plots/ $<

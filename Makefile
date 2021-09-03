# Makefile of different commands


########################
# Cleaning of raw data
# ----------------------

data_fmd:
	python src/data/clean_fmd_case_study_data.py \
		"data/raw/" \
		"data/processed/"

data_ebola:
	python src/data/clean_ebola_case_study_data.py \
		"data/raw/" \
		"data/processed/"

# Command to clean both datasets
data: data_fmd data_ebola


###################
# Main analysis
# -----------------
main_analysis: data
	python src/analysis/main_analysis_case_studies.py \
		"data/processed/" \
		"output/tables/"

mean_projections:
	python src/analysis/calculate_mean_projections_case_studies.py \
		"data/processed/" \
		"output/tables/"

########################
# Sensitivity analyses
# ----------------------
sensitivity_analysis_random_models: data
	python src/analysis/sensitivity_analysis_random_models.py \
		"data/processed/" \
		"output/tables/results_sensitivity_analysis_random_models_N100.csv" \
		100

sensitivity_analysis_biased_models: data
	python src/analysis/sensitivity_analysis_biased_models.py \
		"data/processed/" \
		"output/tables/results_sensitivity_analysis_biased_models_N100.csv" \
		100


################################
# Figures and additional tables
# ------------------------------

all_figs: fig_random_models fig_biased_models fig_fmd_data fig_ebola_data

# Figure of the input data (figure 1)
fig_random_models:
	Rscript src/viz/plot_analysis_random_models.R \
		"output/tables/results_sensitivity_analysis_random_models_N100.csv" \
		"output/figures/fig2_sensitivity_analysis_random_models_N100" \
		"output/figures/fig3_sensitivity_analysis_random_models_N100_ebola" \
		"png"

# Figure of the input data (figure 2 and S3)
fig_biased_models:
	Rscript src/viz/plot_analysis_biased_models.R \
		"output/tables/results_sensitivity_analysis_biased_models_N100.csv" \
		"output/figures/fig4_sensitivity_analysis_biased_models_N100_fmd_duration" \
		"output/figures/figS3_sensitivity_analysis_biased_models_N100_fmd_cattle_culled" \
		"output/figures/fig5_sensitivity_analysis_biased_models_N100_ebola" \
		"png"


# Figure of the input data (figure S1)
fig_fmd_data: data_fmd
	Rscript src/viz/plot_fmd_data.R \
		"data/processed/fmd_data_cleaned_duration.csv" \
		"data/processed/fmd_data_cleaned_cattle_culled.csv" \
		"output/figures/figS1_fmd_raw_data" \
		"png"


# Figure of the input data (figure S2)
fig_ebola_data: data_ebola
	Rscript src/viz/plot_ebola_data.R \
		"data/processed/ebola_data_cleaned.csv" \
		"output/figures/figS2_ebola_raw_data" \
		"png"

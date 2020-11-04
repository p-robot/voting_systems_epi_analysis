# Makefile of different commands

# Clean the FMD data
data_fmd:
	python src/data/clean_fmd_case_study_data.py \
		"data/raw/" \
		"data/processed/"

# Clean the EV data
data_ebola:
	python src/data/clean_ebola_case_study_data.py \
		"data/raw/" \
		"data/processed/"

# Command to clean both datasets
data: data_fmd data_ebola


# Run the main analysis applying vote processing rules to two case studies
analysis1: data
	python src/analysis/analysis1_case_studies.py \
		"data/processed/" \
		"output/tables/"

sensitivity_biased_models: data
	echo "make sensitivity_biased_models"

sensitivity_random_models: data
	echo "make sensitivity_random_models"

clean:
	echo "make clean"

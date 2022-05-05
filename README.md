# `voting_systems_epi_analysis`


Python code for applying vote-processing rules to output from multiple epidemiological models.  This repository contains the scripts for running the analysis in the manuscript, the code for the vote processing rules is housed in a separate Python module (`voting_systems`).  


A slide deck of the different voting rules and some of the tests used to verify the coded algorithms is provided in [doc/voting_systems.pdf](doc/voting_systems.pdf).  


### Data requirements

Two datasets are required to run the analyses: 

* Model output from 5 models of the spread of foot-and-mouth disease (FMD) in a hypothetical outbreak in the UK county of Cumbria ([Probert et al., 2016](https://www.sciencedirect.com/science/article/pii/S175543651500095X)).  These can be downloaded from [https://github.com/p-robot/objectives_matter](https://github.com/p-robot/objectives_matter), place the files `model_a.csv, ... model_e.csv` in the folder `voting_systems_epi_analysis/data/raw`.  
* Model output from 37 models of the spread of Ebola virus (EV) from the 2014 Ebola outbreak ([Li et al., 2017](https://www.pnas.org/content/114/22/5659)).  


### Software requirements

* Python >3.6 and the Python modules listed in [`requirements.txt`](requirements.txt).  
* We recommend running analyses with a Python virtual environment which can be set up in the following manner: 

```python
# Change to project directory
cd voting_systems_epi_analysis

# Create and activate a python virtual environment
python -m venv venv
source venv/source/activate

# Install requirements
pip install -m requirements.txt
```
The virtual environment can be deactivated using the `deactivate` command.  

### Usage

* **Data pre-processing**: Once downloaded, the following commands will clean and prepare both the FMD and EV data (and place it in the folder `data/processed`).  
```
make data
```

* **Main analysis**: The two datasets can be processed under each vote processing rule (first-past-the-post, Borda Count, Coombs Method, Alternative Vote) in the following manner:  
```
make main_analysis
```
This will generate a file called `results_main_analysis.csv` and place them in the folder `output/tables`.  

* **Sensitivity analysis to adding random models**: 

```
make sensitivity_analysis_random_models
```

* **Sensitivity analysis to biased models**: 

```
make sensitivity_analysis_biased_models
```

### Additional commands

* `make data_fmd` will clean the FMD data.  
* `make data_ebola` will clean the EV data.  
* `fig_random_models` make figure for sensitivity analysis that adds models that randomly rank interventions to the original cohort
* `fig_biased_models` make figure for sensitivity analysis that adds biased models to the original cohort
* `fig_fmd_data` make figure of raw FMD data
* `fig_ebola_data` make figure of raw Ebola data

### Tests

The `voting_systems` module that includes the algorithms for the vote processing rules is tested using [`pytest`](https://docs.pytest.org/en/stable/).  


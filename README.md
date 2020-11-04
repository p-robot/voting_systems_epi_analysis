`voting_systems_epi_analysis`
-----------------

Python code for applying vote processing rules to output from multiple epidemiological models.  


### Data requirements

Two datasets are required to run this script: model output on foot-and-mouth disease (FMD) from Probert et al., 2016 and Ebola from Li et al., 2017.  

* Model output from 5 models of foot-and-mouth disease spread in a hypothetical outbreak in UK county of Cumbria is from ... 
* Model output from 37 models of the spread of EBV in the 2014 West Africa Ebola outbreak is from ...  

### Software requirements

* Analyses require Python >3.6 and the Python modules listed in `requirements.txt`.  
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
The virtual environment can be deactivate using the `deactivate` command.  

### Usage

* **Data pre-processing**: Once downloaded, the following commands will clean/prepare both the FMD and EBV data.  
```
make data
```

* **Main analysis**: Processing the two datasets under each vote processing rule (first-past-the-post, Borda Count, Coombs Method, Alternative Vote) can be performed in the following manner.  
```
make analysis1
```

* **Sensitivity analysis to random models**: 

```
make sensitivity_random_models
```

* **Sensitivity analysis to biased models**: 

```
make sensitivity_biased_models
```


### Additional commands

* `make data_fmd` will clean the FMD data.  
* `make data_ebola` will clean the EBV data.  

### Output


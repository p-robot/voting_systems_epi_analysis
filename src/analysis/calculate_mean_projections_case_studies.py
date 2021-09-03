#!/usr/bin/env python3
"""
Script for calculating the mean projections for each case study 
and calculating ranks of interventions from these mean projections.  

W. Probert, 2021
"""

import numpy as np, pandas as pd, os, sys
from os.path import join
from datetime import datetime

dataset_files = [\
    "ebola_data_cleaned.csv",
    "fmd_data_cleaned_cattle_culled.csv",
    "fmd_data_cleaned_duration.csv"
    ]

if __name__ == "__main__":
    
    # Parse command-line arguments
    if len(sys.argv) > 1:
        DATA_DIR = sys.argv[1]
    else:
        DATA_DIR = "data"

    if len(sys.argv) > 2:
        OUTPUT_DIR = sys.argv[2]
    else: 
        OUTPUT_DIR = "."
    
    # Pull today's date (for saving in output files)
    now = datetime.today().strftime('%Y-%m-%d %H:%M:%S')
    
    # List for storing results
    results = []
    extra_output = []
    
    # Loop through datasets
    for filename in dataset_files:
        # Load dataset
        df = pd.read_csv(join(DATA_DIR, filename))

        if "run" in df.columns:
            df = df[[c for c in df.columns if c != "run"]]
        
        # Calculate mean of projections for each action across models
        means = df.mean(axis = 0).reset_index()
        means.columns = ["intervention", "mean_projection"]
        
        # Calculate rankings
        means['intervention_rank'] = means.mean_projection.rank(ascending = True)

        # Save filename to the dataframe
        means["filename"] = filename
        
        # Output dataframe to output folder
        means.to_csv(join(OUTPUT_DIR, "mean_projections_" + filename), index = False)

#!/usr/bin/env python3
"""
Investigating the effect of adding models with random results

W. Probert, 2020
"""

import numpy as np, pandas as pd, os, sys
from os.path import join
from datetime import datetime

import voting_systems as voting

vote_processing_rules = [\
    voting.fpp, \
    voting.borda_count, \
    voting.coombs_method, \
    voting.alternative_vote]

datasets = [\
    "fmd_data_votes_cattle_culled.csv", \
    "fmd_data_votes_duration.csv", \
    "ebola_data_votes_cases.csv"]

n_random_models = [50, 50, 370]
candidates_list = [np.arange(5), np.arange(5), np.arange(6)]
n_votes_list = [100, 100, 1]



if __name__ == "__main__":
    
    # Parse command-line arguments
    if len(sys.argv) > 1:
        DATA_DIR = sys.argv[1]
    else:
        DATA_DIR = "data"

    if len(sys.argv) > 2:
        OUTPUT_FILE = sys.argv[2]
    else: 
        OUTPUT_FILE = "."
    
    if len(sys.argv) > 3:
        n_experiment_replicates = int(sys.argv[3])
    else: 
        n_experiment_replicates = 100
    
    # Set seed for repeatable results
    np.random.seed(2022)
    
    # Pull today's date (for saving in output files)
    now = datetime.today().strftime('%Y-%m-%d %H:%M:%S')
    
    # List for storing results
    results = []
    
    # Loop through datasets
    for f, n_random, cand, nvotes in zip(datasets, n_random_models, candidates_list, n_votes_list):
        
        # Load dataset
        df_votes = pd.read_csv(join(DATA_DIR, f))
        
        # Extract votes from dataframe
        vote_cols = [c for c in df_votes.columns if "rank" in c]
        votes = df_votes[vote_cols].to_numpy().astype(int)
        
        # Add up to n_random models to the current votes
        for N in np.arange(1, n_random + 1):
            print("Running for ", N, " additional models with randomly allocated ranks")
            print("for the ", f, " case study")
            
            # Replicate each experiment a number of times
            for exp_replicate in range(1, n_experiment_replicates + 1):
                
                random_votes = [np.random.permutation(cand) \
                                                        for i in range(nvotes) \
                                                            for j in range(N)]
                new_votes = np.vstack((votes, random_votes))
            
                # Process the votes for all vote-processing rule
                for rule in vote_processing_rules:
            
                    # Run vote-processing rule
                    (winner, winner_index), (candidates, output) = rule(new_votes)
            
                    # Save outputs in an array
                    results.append([f, rule.__name__, N, exp_replicate, winner, now])
    
    # Coerce array to dataframe
    df_results = pd.DataFrame(results)
    df_results.columns = ["dataset", "vote_processing_rule", \
        "number_random_models", "experiment_replicate", "winner", "time"]
    
    df_results = df_results.sort_values(by = ["dataset", "vote_processing_rule", \
        "number_random_models"])
    
    # Output dataframe to output folder
    df_results.to_csv(join(OUTPUT_FILE), index = False)

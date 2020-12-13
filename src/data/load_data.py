#!/usr/bin/env python
"""
Module to load data for use in running analyses for the voting_systems module

Available datasets:
    ebola
    fmd
"""

import pandas as pd
from os.path import join, dirname

ebola = pd.read_csv(join(dirname(__file__), \
    'ebola.csv'))

model_a = pd.read_table(join(dirname(__file__), \
    'model_a.csv'), sep = ' ', header = None)

#!/usr/bin/env Rscript
# 
# Script to plot the output from the sensitivity analysis from adding models that randomly allocate
# ranks to the original cohort of models.  

############
# Imports
# ---------
require(tidyverse)
require(ggplot2)
require(here)

# For "okabe_ito_colors"
source(file.path(here(), "src", "viz", "plotting_constants.R"))

######################################
# Parse command line args
# ------------------------------------

args <- commandArgs(trailingOnly = TRUE)

input_file <- args[1]
output_file_fmd <- args[2]
file_format <- args[3]

######################################
# Read data and process for plotting
# ------------------------------------

df <- read.csv(input_file, stringsAsFactors = FALSE)
df$winner[grepl(" ", df$winner)] <- "tie"

df$vote_processing_rule <- factor(df$vote_processing_rule, 
    levels = c("fpp", "borda_count", "coombs_method", "alternative_vote"), order = TRUE)
levels(df$vote_processing_rule) <- c("FPP", "Borda Count", "Coombs Method", "Alternative Vote")


df$dataset_name <- factor(df$dataset, 
    levels = c("fmd_data_votes_duration.csv", "fmd_data_votes_cattle_culled.csv", "fmd_data_votes_livestock_culled.csv","ebola_data_votes_cases.csv"), order = TRUE)
levels(df$dataset_name) <- c("Outbreak duration", "Cattle culled", "Livestock culled", "Cases") 



##################################################################
# Count the number of times each winner occurs in each experiment
# ----------------------------------------------------------------

df_random <- df %>% 
    group_by(dataset, dataset_name, vote_processing_rule, number_random_models, winner) %>%
    tally()


################################################
# Plot data from experiment using FMD case study
# ----------------------------------------------

df_plot <- df_random[grepl("fmd", df_random$dataset),]

df_plot$winner <- factor(df_plot$winner, levels = c("0", "1", "2", "3", "4", "tie"), order = TRUE)
levels(df_plot$winner) <- c("IP culling", "IP & DC culling", "Ring culling (3km)", "Ring vaccination (3km)", "Ring vaccination (10km)", "Tie")

p <- ggplot(subset(df_plot, dataset_name == "Cattle culled"), 
    aes(x = number_random_models, y = n, fill = winner)) +
    geom_bar(stat = "identity", width = 1) +
    facet_grid(cols = vars(vote_processing_rule)) +
    theme_classic() + coord_fixed(ratio = 0.5) +
    scale_fill_manual(name = "Chosen intervention", values = okabe_ito_colors, drop = FALSE) +
    scale_x_continuous(breaks = c(1, 25, 50), expand = c(0, 0)) +
    scale_y_continuous(breaks = seq(0, 100, 20), expand = c(0, 0)) +
    theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        strip.background = element_blank(),
        panel.spacing = unit(1, "lines"),
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 20),
        strip.text = element_text(size = 14),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 14),
        legend.position = "right"
    ) +
    xlab("Number of additional models with interventions ranked randomly") +
    ylab("Percent of experiments with\nintervention ranked as best")

ggsave(paste0(output_file_fmd, ".", file_format), p, width = 4*3+1, height = 2*3+0.5)


#!/usr/bin/env Rscript
# 
# Script to plot the output from the sensitivity analysis from adding biased models to the 
# original cohort of models.  

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
output_file_fmd_duration <- args[2]
output_file_fmd_cattle_culled <- args[3]
output_file_ebola <- args[4]
file_format <- args[5]

######################################
# Read data and process for plotting
# ------------------------------------

df <- read.csv(input_file, stringsAsFactors = FALSE)

df$winner[grepl(" ", df$winner)] <- "tie"

df$vote_processing_rule <- factor(df$vote_processing_rule, 
    levels = c("fpp", "borda_count", "coombs_method", "alternative_vote"), order = TRUE)
levels(df$vote_processing_rule) <- c("FPP", "Borda Count", "Coombs Method", "Alternative Vote")


df$dataset_name <- factor(df$dataset, 
    levels = c("fmd_data_votes_duration.csv", "fmd_data_votes_cattle_culled.csv", 
                "ebola_data_votes_cases.csv"), order = TRUE)
levels(df$dataset_name) <- c("Outbreak duration", "Cattle culled", "Cases") 


##################################################################
# Count the number of times each winner occurs in each experiment
# ----------------------------------------------------------------

df_random <- df %>% 
    group_by(dataset, dataset_name, vote_processing_rule, 
            number_biased_models, biased_candidate, winner) %>%
    tally()


#################################################################
# Plot FMD data with an objective of minimizing cattle culled
# ---------------------------------------------------------------

df_plot <- df_random[grepl("fmd_data_votes_cattle_culled", df_random$dataset),]

df_plot$winner <- factor(df_plot$winner, levels = c("0", "1", "2", "3", "4", "tie"), order = TRUE)
levels(df_plot$winner) <- c("IP culling (IP)", "IP & DC culling (IPDC)", "Ring culling (3km) (RC3)", "Ring vaccination (3km) (V3)", "Ring vaccination (10km) (V10)", "Tie")

df_plot$biased_candidate <- factor(df_plot$biased_candidate, levels = c("0", "1", "2", "3", "4"), order = TRUE)
levels(df_plot$biased_candidate) <- c("IP", "IPDC", "RC3", "V3", "V10")

p <- ggplot(df_plot, aes(x = number_biased_models, y = n, fill = winner)) +
    geom_bar(stat = "identity", width = 1) +
    facet_grid(cols = vars(vote_processing_rule), rows = vars(biased_candidate)) +
    theme_classic() + coord_fixed(ratio = 5/100) +
    scale_fill_manual(name = "Chosen intervention", values = okabe_ito_colors, drop = FALSE) +
    scale_x_continuous(breaks = c(1, 5), expand = c(0, 0)) +
    scale_y_continuous(breaks = seq(0, 100, 20), expand = c(0, 0)) +
    theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        strip.background = element_blank(),
        panel.spacing = unit(1, "lines"),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 20),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16),
        strip.text = element_text(size = 20),
        legend.position = "right"
    ) +
    xlab("Number of additional models with interventions biased") +
    ylab("Percent of experiments with intervention ranked as best using voting rule")

ggsave(paste0(output_file_fmd_cattle_culled, ".", file_format), p, width = 5*3+1, height = 5*3+0.5)


#####################################################################
# Plot FMD data with an objective of minimizing outbreak duration
# -------------------------------------------------------------------

df_plot <- df_random[grepl("fmd_data_votes_duration", df_random$dataset),]

df_plot$winner <- factor(df_plot$winner, levels = c("0", "1", "2", "3", "4", "tie"), order = TRUE)
levels(df_plot$winner) <- c("IP culling (IP)", "IP & DC culling (IPDC)", "Ring culling (3km) (RC3)", "Ring vaccination (3km) (V3)", "Ring vaccination (10km) (V10)", "Tie")

df_plot$biased_candidate <- factor(df_plot$biased_candidate, levels = c("0", "1", "2", "3", "4"), order = TRUE)
levels(df_plot$biased_candidate) <- c("IP", "IPDC", "RC3", "V3", "V10")

p <- ggplot(df_plot, aes(x = number_biased_models, y = n, fill = winner)) +
    geom_bar(stat = "identity", width = 1) +
    facet_grid(cols = vars(vote_processing_rule), rows = vars(biased_candidate)) +
    theme_classic() + coord_fixed(ratio = 5/100) +
    scale_fill_manual(name = "Chosen intervention", values = okabe_ito_colors, drop = FALSE) +
    scale_x_continuous(breaks = c(1, 5), expand = c(0, 0)) +
    scale_y_continuous(breaks = seq(0, 100, 20), expand = c(0, 0)) +
    theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        strip.background = element_blank(),
        panel.spacing = unit(1, "lines"),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 20),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16),
        strip.text = element_text(size = 20),
        legend.position = "right"
    ) +
    xlab("Number of additional models with interventions biased") +
    ylab("Percent of experiments with intervention ranked as best using voting rule")

ggsave(paste0(output_file_fmd_duration, ".", file_format), p, width = 5*3+1, height = 5*3+0.5)


##############################################################
# Plot Ebola data with an objective of minimizing caseload
# ------------------------------------------------------------

df_plot <- df_random[grepl("ebola", df_random$dataset),]

df_plot$winner <- factor(df_plot$winner, 
    levels = c("0", "1", "2", "3", "4", "5", "tie"), order = TRUE)

levels(df_plot$winner) <- c(
    "Increasing hospitalization proportion (IHP)", 
    "No management (NM)", 
    "Reducing community transmission (RCT)", 
    "Reducing funeral transmission (RFT)", 
    "Reducing hospital transmission (RHT)",
    "Reducing mortality ratio (RMR)", 
    "Tie")

df_plot$biased_candidate <- factor(df_plot$biased_candidate, levels = c("0", "1", "2", "3", "4", "5"), order = TRUE)
levels(df_plot$biased_candidate) <- c("IHP", "NM", "RCT", "RFT", "RHT", "RMR")

p <- ggplot(df_plot, aes(x = number_biased_models, y = n, fill = winner)) + 
    geom_bar(stat = "identity", width = 1) + 
    facet_grid(cols = vars(vote_processing_rule), rows = vars(biased_candidate)) + 
    theme_classic() + coord_fixed(ratio = 37/100) + 
    scale_fill_manual(name = "Chosen intervention", values = okabe_ito_colors, drop = FALSE) + 
    scale_x_continuous(breaks = c(1, 10, 20, 30, 37), expand = c(0, 0)) + 
    scale_y_continuous(breaks = seq(0, 100, 20), expand = c(0, 0)) + 
    theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        strip.background = element_blank(),
        panel.spacing = unit(1, "lines"),
        axis.text = element_text(size = 18), 
        axis.title.x = element_text(size = 24), 
        axis.title.y = element_text(size = 24), 
        legend.title = element_text(size = 26),
        legend.text = element_text(size = 26),
        strip.text = element_text(size = 28),
        legend.position = "right"
    ) + 
    xlab("Number of additional models with interventions ranked randomly") + 
    ylab("Percent of experiments with intervention ranked as best using voting rule")

ggsave(paste0(output_file_ebola, ".", file_format), p, width = 8*3+1, height = 8*3+0.5)

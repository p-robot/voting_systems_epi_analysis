#!/usr/bin/env Rscript
# 
# Script to plot the raw Ebola data

############
# Imports
# ---------
require(tidyverse)
require(ggplot2)
require(reshape2)

######################################
# Parse command line args
# ------------------------------------
args <- commandArgs(trailingOnly = TRUE)

input_file <- args[1]
output_file <- args[2]
file_format <- args[3]

################
# Read the data
# --------------
df_values <- melt(read.csv(input_file), id.vars = c("model"))

#########################################
# Make extra variables that plot nicely
# --------------------------------------

df_values <- rename(df_values, intervention = variable)
df_values$intervention_label <- paste0(toupper(substring(df_values$intervention, 1, 1)),
                                       substring(df_values$intervention, 2))
df_values$intervention_label <- gsub("_", " ", df_values$intervention_label)


####################################################
# Plot projections across models and interventions
# --------------------------------------------------

p <- ggplot(df_values, aes(y = model, x = value,
                      colour = intervention_label, fill = intervention_label)) +
    geom_point(size = 3.5, alpha = 0.8) + 
    scale_fill_brewer(name = "Intervention", palette = "Set1") +
    scale_colour_brewer(name = "Intervention", palette = "Set1") +
    scale_x_continuous(labels = scales::comma) +
    xlab("Projected caseload") + ylab("Model") +
    theme_classic() +
    theme(
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 8),
    axis.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    legend.position = "top"
    ) + 
    guides(fill = guide_legend(ncol = 2))

ggsave(paste0(output_file, ".", file_format), p, width = 12, height = 14)

#!/usr/bin/env Rscript
# 
# Script to plot the raw FMD data

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

fmd_dataset_duration <- args[1]
fmd_dataset_cattle_culled <- args[2]
output_file <- args[3]
file_format <- args[4]

################
# Read the data
# --------------

# Datasets
fmd_datasets <- c(fmd_dataset_duration, fmd_dataset_cattle_culled)

# Read both datasets
dataset_list <- list(); i <- 1
for(dataset in fmd_datasets){
  df <- read.csv(dataset)
  df <- melt(df, id.vars = c("objective", "model", "run"))
  df$dataset <- dataset
  dataset_list[[i]] <- df; i <- i + 1
}
df_values <- do.call(rbind, dataset_list)


################################################
# Make additional variables so they plot nicely
# ----------------------------------------------

df_values <- rename(df_values, intervention = variable)
df_values$model <- paste("Model", df_values$model)
df_values$intervention <- toupper(df_values$intervention)

df_values$objective_label <- paste0(toupper(substring(df_values$objective, 1, 1)), substring(df_values$objective, 2))
df_values$objective_label <- gsub("_", " ", df_values$objective_label)


####################################################
# Plot projections across models and interventions
# --------------------------------------------------

# Plot projections across models and interventions
p <- ggplot(df_values, aes(x = intervention, y = value, colour = intervention, 
            fill = intervention)) + 
    geom_violin(width = 1.0, alpha = 0.8) + 
    facet_grid(cols = vars(model), rows = vars(objective_label), scales = "free_y") + 
    scale_fill_brewer(name = "Intervention", palette = "Set1") + 
    scale_colour_brewer(name = "Intervention", palette = "Set1") + 
    scale_y_continuous(labels = scales::comma) + 
    xlab("") + ylab("") + 
    theme_classic() + 
    theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    strip.text = element_text(size = 20)
    )

ggsave(paste0(output_file, ".", file_format), p, width = 10, height = 6)

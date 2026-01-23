# ----------------------------------
# Project: Education, Institutions, and Environmental Quality in Africa
# File: tables.R
# Author: Emmanuel Kodom
# ----------------------------------

library(stargazer)
library(fixest)

# Load models from analysis_panel.R

# Compare all models in one table
stargazer(
  gmm_m1, gmm_m2, gmm_m3, gmm_m4,
  type = "text",
  title = "Difference GMM Results (Education, Governance, Interaction, and Controls",
  dep.var.labels = "Log CO2 Emissions per Capita",
  out = "~/Downloads/gmm_main_models.doc")

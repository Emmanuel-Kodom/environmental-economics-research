# ----------------------------------
# Project: Education, Institutions, and Environmental Quality in Africa
# File: clean_data.R
# Author: Emmanuel Kodom
# ----------------------------------

# Load libraries
library(tidyverse)
library(readr)

# -------------------------------
# Data Import
# -------------------------------
# Load the pollution data
pollution <- read_csv("clean_pollution_data.csv")

####################################################################################################
#================= Dynamic Panel Data GMM Estimation ==============================
# 1. Check how many observations you actually have
pollution_clean <- pollution %>%
  select(country, year, co2_pc, edu, gov, gdp_pc, urban_share, industry_gdp) %>%
  filter(complete.cases(.)) %>%
  group_by(country) %>%
  filter(n() >= 5) %>%   # your threshold
  ungroup()

nrow(pollution_clean)  # Should be much more than 39

# 2. Create balanced panel

pollution_balanced <- pollution_clean %>%
  mutate(
    # simple global time trend (0,1,2,...) over the sample
    trend = as.integer(year - min(year, na.rm = TRUE))
  )
# Save cleaned dataset
write_csv(pollution_balanced, "data/clean_pollution_data.csv")

#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------


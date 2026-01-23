# ----------------------------------
# Project: Environmental Kuznets Curve (US)
# File: figures.R
# Author: Emmanuel Kodom
# ----------------------------------

# Load libraries
library(tidyverse)
library(ggplot2)

# Load cleaned data
ekc <- read_csv("data/clean_ekc_data.csv")

# Create figures directory if it doesn't exist
if (!dir.exists("figures")) {
  dir.create("figures")
}

# -------------------------------
# Figure 1: Pollution vs Income
# -------------------------------
p1 <- ggplot(ekc, aes(x = gdp_pc, y = pollution)) +
  geom_point(alpha = 0.4) +
  labs(
    title = "Pollution and Economic Development in the U.S.",
    x = "GDP per Capita",
    y = "Pollution"
  ) +
  theme_minimal()

ggsave("figures/pollution_income_scatter.png", p1, width = 7, height = 5)

# -----------------------------------------
# Figure 2: EKC with Quadratic Fit
# -----------------------------------------
p2 <- ggplot(ekc, aes(x = gdp_pc, y = pollution)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2), se = FALSE) +
  labs(
    title = "Environmental Kuznets Curve (U.S.)",
    x = "GDP per Capita",
    y = "Pollution"
  ) +
  theme_minimal()

ggsave("figures/ekc_quadratic_fit.png", p2, width = 7, height = 5)

# -----------------------------------------
# Figure 3: Time Trend of Pollution
# -----------------------------------------
ekc_time <- ekc %>%
  group_by(year) %>%
  summarise(avg_pollution = mean(pollution, na.rm = TRUE))

p3 <- ggplot(ekc_time, aes(x = year, y = avg_pollution)) +
  geom_line() +
  labs(
    title = "Average Pollution Over Time in the U.S.",
    x = "Year",
    y = "Average Pollution"
  ) +
  theme_minimal()

ggsave("figures/pollution_time_trend.png", p3, width = 7, height = 5)


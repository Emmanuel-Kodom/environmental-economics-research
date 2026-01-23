# ----------------------------------
# Project: Education, Institutions, and Environmental Quality in Africa
# File: analysis_panel.R
# Author: Emmanuel Kodom
# ----------------------------------

# Load libraries
library(tidyverse)
library(fixest)
library(plm)

# Load cleaned data
pollution <- read_csv("data/clean_pollution_data.csv")

    
pollution_panel <- pdata.frame(pollution_balanced, index = c("country","year"))
#-----------------------------------------------------------------------------------------
#======================= SYSTEM GMM ESTIMATION ==========================================
# (1) Edu only
gmm_m1 <- pgmm(
  co2_pc ~ lag(co2_pc, 1) + edu |
    lag(co2_pc, 2:2) + lag(edu, 2:2),
  data = pollution_panel,
  effect = "individual",
  model = "twosteps",
  transformation = "ld",
  collapse = TRUE
); print_gmm_diag(gmm_m1)
##----------------------------------------------------------------------------
# (2) Gov only
gmm_m2 <- pgmm(
  co2_pc ~ lag(co2_pc, 1) + gov |
    lag(co2_pc, 2:2) + lag(gov, 2:2),
  data = pollution_panel,
  effect = "individual",
  model = "twosteps",
  transformation = "ld",
  collapse = TRUE
); print_gmm_diag(gmm_m2)
#------------------------------------------------------------------------------
# (3) Edu + Gov + Interaction
gmm_m3 <- pgmm(
  co2_pc ~ lag(co2_pc, 1) + edu + gov + edu*gov |
    lag(co2_pc, 2:2) + lag(edu, 2:2) + lag(gov, 2:2) + lag(edu*gov, 2:2),
  data = pollution_panel,
  effect = "individual",
  model = "twosteps",
  transformation = "ld",
  collapse = TRUE
); print_gmm_diag(gmm_m3)
#--------------------------------------------------------------------------
# (4) Full model
gmm_m4 <- pgmm(
  co2_pc ~ lag(co2_pc, 1) + edu + gov + edu*gov +
    gdp_pc + urban_share + industry_gdp |
    lag(co2_pc, 2:2) + lag(edu, 2:2) + lag(gov, 2:2) + lag(edu*gov, 2:2) +
    gdp_pc + urban_share + industry_gdp,
  data = pollution_panel,
  effect = "twoways",          
  model = "twosteps",
  transformation = "ld",
  collapse = TRUE
); print_gmm_diag(gmm_m4)

#### ====================STARGAZER TABLES ==========================================
# Main four models (Edu only, Gov only, Edu+Gov+Int, Full + Time FE)
stargazer(gmm_m1, gmm_m2, gmm_m3, gmm_m4, type = "text",
          title = "System-GMM Estimates for CO2 per Capita (Main Models)",
          dep.var.labels = "CO2 per capita",
          column.labels = c("Edu only","Gov only","Edu+Gov+Int","Full model"),
          out = "C:/Users/ekodom/Desktop/ECON 602/PROJECT/gmm_main_models.html",
          digits = 3)


#################################################################################################
# ----------Difference GMM-----------------------------------
# ---------------------------------------------
pdata <- pdata.frame(pollution, index = c("country", "year"))

# ---------------------------------------------
# 2. Transform variables
# ---------------------------------------------
pdata$lco2       <- log(pmax(pdata$co2_pc, 1e-6))
pdata$ledu       <- log(pmax(pdata$edu, 1e-6))
pdata$lgdp       <- log(pmax(pdata$gdp_pc, 1e-6))
pdata$lenergy    <- log(pmax(pdata$energy_use, 1e-6))
pdata$lurban     <- log(pmax(pdata$urban_share, 1e-6))

pdata$ledu_gov   <- pdata$ledu * pdata$gov

# ---------------------------------------------
# 3. MODEL 1: Education only
# ---------------------------------------------
gmm_m1 <- pgmm(
  lco2 ~ lag(lco2, 1) + ledu |
    lag(lco2, 2:5) + lag(ledu, 2:5) |
    1,
  data = pdata,
  effect = "individual",
  model = "twosteps",
  transformation = "d"
)

# ---------------------------------------------
# 4. MODEL 2: Education + Governance
# ---------------------------------------------
gmm_m2 <- pgmm(
  lco2 ~ lag(lco2, 1) + ledu + gov |
    lag(lco2, 2:5) + lag(ledu, 2:5) |
    gov,
  data = pdata,
  effect = "individual",
  model = "twosteps",
  transformation = "d"
)

# ---------------------------------------------
# 5. MODEL 3: Edu + Gov + Interaction
# ---------------------------------------------
gmm_m3 <- pgmm(
  lco2 ~ lag(lco2, 1) + ledu + gov + ledu_gov |
    lag(lco2, 2:5) + lag(ledu, 2:5) + lag(ledu_gov, 2:5) |
    gov,
  data = pdata,
  effect = "individual",
  model = "twosteps",
  transformation = "d"
)

# ---------------------------------------------
# 6. MODEL 4: Full model with controls
# ---------------------------------------------
gmm_m4 <- pgmm(
  lco2 ~ lag(lco2, 1) + ledu + gov + ledu_gov + lenergy + lurban +
    lgdp + industry_gdp |
    
    lag(lco2, 2:5) + lag(ledu, 2:5) |
    
    gov + lgdp + lenergy + urban_share + industry_gdp,
  
  data = pdata,
  effect = "individual",
  model = "twosteps",
  transformation = "d"
)


# ---------------------------------------------
# 7. Summaries
# ---------------------------------------------
summary(gmm_m1, robust = TRUE)
summary(gmm_m2, robust = TRUE)
summary(gmm_m3, robust = TRUE)
summary(gmm_m4, robust = TRUE)

# Compare all models in one table
stargazer(
  gmm_m1, gmm_m2, gmm_m3, gmm_m4,
  type = "text",
  title = "Difference GMM Results (Education, Governance, Interaction, and Controls",
  dep.var.labels = "Log CO2 Emissions per Capita",
  out = "~/Downloads/gmm_main_models.doc")
#===========================================================================================

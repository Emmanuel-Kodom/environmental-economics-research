# Education, Institutional Quality, and Environmental Quality in Africa

This project examines the role of **human capital development and institutional quality** in shaping environmental outcomes across African countries.

The analysis focuses on **per capita CO₂ emissions** as a measure of environmental pollution and uses panel data methods to identify the effects of education and governance while accounting for unobserved heterogeneity and endogeneity.

---

## Research Questions
- How does human capital development affect environmental quality in Africa?
- What role do institutions play in mitigating environmental degradation?
- Do education and institutional quality complement each other in reducing pollution?

---

## Data
The dataset is an unbalanced panel of African countries covering the period **2002–2023**, compiled from multiple international sources:

- CO₂ emissions per capita: World Bank (WDI)
- Human capital index (education): Penn World Table (v10.0)
- Institutional quality: Worldwide Governance Indicators (WGI)
- Macroeconomic controls (GDP per capita, energy use, trade, industry, urbanization): World Bank (WDI)

Data cleaning and variable construction are documented in `clean_data.R`.

---

## Empirical Strategy
The analysis employs panel data econometric methods, including:

- Two-way fixed effects models to control for country-specific and time-specific unobserved heterogeneity
- Dynamic panel estimation using Generalized Method of Moments (GMM) to address endogeneity concerns
- Robust and clustered standard errors at the country level

The main estimations are implemented in `analysis_panel.R`.

---

## Results (Summary)
The findings suggest that:
- Higher levels of human capital are associated with lower per capita CO₂ emissions
- Stronger institutional quality mitigates environmental degradation
- Accounting for endogeneity materially affects estimated coefficients, highlighting the importance of dynamic panel methods

Detailed regression results are reported in the paper and generated via `tables.R`.

---

## Supplementary Analysis
Additional descriptive statistics, exploratory figures, and geographic visualizations are provided in `data_appendix.Rmd`.

---

## Status
Ongoing working paper.  
This project originated as graduate coursework and is being developed for submission-quality research.

---

## Author
**Emmanuel Kodom**

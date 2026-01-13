# Biostatistics Project: Poisson-Based Analysis of Covid-19 Death Data

This repository contains an R-based biostatistical analysis investigating whether reported Covid-19 death counts exhibit statistically unusual regularity under a Poisson model.

The project was conducted as part of the BMM422 – Biostatistics course and focuses on variance-based anomaly detection using simulation techniques.

---

## Problem Motivation

For rare and independent events, the Poisson distribution provides a natural baseline model in which the mean and variance are approximately equal. In real epidemiological data, overdispersion (variance greater than the mean) is common due to clustering and superspreading events. However, variance that is systematically lower than Poisson expectations may represent a statistical red flag.

The goal of this project is not to claim data manipulation, but to evaluate whether reported death counts show variability that is statistically unlikely under a Poisson model with matched mean.

---

## Dataset

- Daily reported Covid-19 death counts at the country level  
- Time span: March 2020 – February 2023  
- Target country: Germany  
- Comparison country: United States of America  
- Visualization window: 28 Dec 2020 – 09 Jan 2022  

The dataset is provided in CSV format and included in this repository as `ProjectData.csv`.

---

## Methodology

For each of 10 selected weeks in Germany, daily death counts were extracted and the observed mean and variance were calculated. Using the observed mean as the Poisson parameter (λ), 1000 synthetic weeks were simulated via the Poisson distribution.

For each week, the proportion of simulated variances smaller than the observed variance was computed as  
`prob_smaller = (# simulated variances < observed variance) / 1000`.

Weeks with `prob_smaller < 0.05` were labeled as statistically suspicious; all others were considered normal.

In addition, daily deaths per million people were compared between Germany and the USA to contextualize temporal trends and variability.

---

## Key Results

- None of the analyzed weeks for Germany were flagged as statistically suspicious under the Poisson baseline.  
- All observed weekly variances were consistent with or greater than expectations from Poisson simulations.  
- The Germany–USA comparison shows higher and more variable death rates in the USA across the selected time window.

These findings indicate no evidence of unusually low variance in the selected German data under the assumptions of this model.

---

## How to Run the Analysis

1. Clone or download this repository  
2. Open the R script `analysis.R`  
3. Ensure `ProjectData.csv` is located in the same directory  
4. Run the script in R or RStudio  

No additional packages are required.

---

## Reproducibility

All code and data required to reproduce the analysis are included in this repository. The analysis is fully reproducible using base R functions.

---

## Related Project Page

A detailed project description, interpretation, and visual results are available in my academic portfolio:

→ Notion Portfolio: https://www.notion.so/ACADEMIC-PORTFOLIO-TOPRAK-KAYIRAN-2e7d237c87378073a997c2ae01efd037?source=copy_link 

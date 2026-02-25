### Report on exploration of factors associated with diabetes

## Overview
The project explores the socio-demographic, biological, behavioral characteristics related to diabetes based on the responses collected among the adults in the United States using Behavioral Risk Factor Surveillance System (BRFSS) in 2023.

## Project overview
* Dataset size: 400,000+ rows
* Data Source: https://www.cdc.gov/brfss/annual_data/annual_2023.html under the filename [2023 BRFSS Data (SAS Transport Format)].
* Tool used: R programming language
* Techniques applied: Data cleaning, Exploratory Data Analysis (EDA) with visualizations

## Variables description
* id_no = Sequence number
* state_name = Name of the State
* age = Age of the respondent
* sex = Sex of the respondent
* income_level= Annual Household income from all sources
* BMI = Body Mass Index
* physical_activity = Any physical activity in past month?
* smoking = Current smoking status
* tobacco_use = Current tobacco use
* alc_drnk_30days = At least one drink of alcohol in the past 30 days
* diab_first_known = Age when first told had diabetes
* diabetes_status = Diabetes status

## Data cleaning script overview
* Loads .XPT format file
* Subsets a dataset with relevant variables
* Converts .XPT format to .csv format compressed file
* Loads .csv format file
* Prepares data: label, recode, rescale
* Handles missing values
* Saves cleaned data to a .rds format file

## Descriptive statistics
* Socio-demographic:
    * Population pyramid (Age & Sex)
* Biological:
    * Mean BMI 
* Behavioral:
    * 2×2 panel (multi-panel): physical activity, smoking, alcohol intake, tobacco use
* Diabetes related
   * Diabetes status by income level
   * US States by diabetes prevalence: BRFSS, 2023
   * Mean age of first diabetes diagnosis
### Diabetes Behaviroral Factors Analysis Project

## Overview
This project examines the association of behavioral factors with diabetes among adults in the United States using Behavioral Risk Factor Surveillance System (BRFSS) data collected on 2023. The dataset is filtered for the relevant variables to meet the objective. These variables included: socio-demographic, biological, behavioral and diabetes related variables. The outcome variable is of "Diabetes Status". This project is done as a requirement to pass the course "Fundamental of Programming".

## Project objectives
1. To explore the socio-demographic, biological and behvarioural characteristics of the respondents
2. To examine the association of behavioral factors with the diabetes status

## Project overview
Dataset size: 400,000+ rows
Data Source: https://www.cdc.gov/brfss/annual_data/annual_2023.html under the filename [2023 BRFSS Data (SAS Transport Format)].
Tool used: R programming language
Techniques applied: Data cleaning, Exploratory Data Analysis (EDA) with visualizations, Calculate Logistic Regression

## Variables description
Predictors:

id_no = Sequence number

state_name = Name of the State

age = Age of the respondent
sex = Sex of the respondent
income_level= Annual Household income from all sources
BMI = Body Mass Index
physical_activity = Any physical activity in past month?
smoking = Current smoking status
tobacco_use = Current tobacco use
alc_drnk_30days = At least one drink of alcohol in the past 30 days
diab_first_known = Age when first told had diabetes
          
Outcome variable:
diabetes_status = Diabetes status


## Data cleaning script overview
Loads .XPT format file
Converts .XPT format to .rds format compressed file
Loads .rds format compressed file
Subsets a dataset with relevant variables for the objectives
Formats column names
Assigns value labels to variables
Handles missing values
Saves cleaned data to a .rds format file

## Visualizations
Socio-demographic:
    Mean age
    Population age pyramid based on sex
    Income level categorization based on state on map
Biological:
    Mean BMI 
Behavioral:
    2×2 panel (multi-panel): physical activity, smoking, alcohol intake, tobacco use

## Logistic Regression
Loads .rda dataset
Reorder of the level
Multiple logistic regression calculation
Interpretation

## Conclusion
The application of logistic regression to multiple behavioral variables showed that physical activity in the past month and alcohol intake in the past 30 days are statistically significant (p < 0.001) factors associated with having diabetes among respondents, based on the 2023 BRFSS data.


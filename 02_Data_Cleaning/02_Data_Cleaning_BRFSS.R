# Install packages: 
if (!requireNamespace("haven")) install.packages("haven")
if (!requireNamespace("Hmisc")) install.packages("Hmisc")


# Load library:
# library("haven") # to load SAS format (.XPT) data in R
library("Hmisc") # to assign labels to variables

# Load dataset:
# Loading .XPT format data
# whole_brfss <- read_xpt("01_Datasets/whole_BRFSS_2023.XPT") #(uncomment to load)
# Issue: Large file size (> 1 GB), did not push to Github

# Solution: Creating a dataframe with filtered variables and converting .XPT
# file to .csv, this format is of less size and can be pushed to Github
# short_brfss <- whole_brfss[c("SEQNO", "_STATE", "_AGE80", "SEXVAR", "_INCOMG1",
#                             "_BMI5", "EXERANY2", "_RFSMOK3", "USENOW3",
#                             "DRNKANY6", "DIABETE4", "DIABAGE4")]

# Save as .csv file with the filtered columns name
# (uncomment following to save)
# write.csv(short_brfss, "01_Datasets/short_brfss.csv", row.names = FALSE)

# Read .csv dataframe and rename the variables
short_brfss <- read.table("01_Datasets/short_brfss.csv",
                          header = TRUE,
                          sep = ",",
                          col.names = c("id_no",
                                        "state_name",        # Name of the State
                                        "age",               # Age of the respondent
                                        "sex",               # Sex of the respondent
                                        "income_level",      # Annual Household income from all sources
                                        "BMI",               # Body Mass Index
                                        "physical_activity", # Any physical activity in past month?
                                        "smoking",           # Current smoking status
                                        "tobacco_use",       # Current tobacco use
                                        "alc_drnk_30days",   # At least one drink of alcohol in the past 30 days
                                        "diabetes_status",   # Diabetes status
                                        "diab_first_known"),  # Age when first told had diabetes,
                          stringsAsFactors = FALSE)


# Examine the filtered dataframe:
str(short_brfss)


factor_labels <- function(data, var, levels, labels) {
  data[[var]] <- factor(data[[var]],
                        levels = levels,
                        labels = labels)
  return(data)
}

# labels for states 
state_labels <- c("1" = "Alabama", "2" = "Alaska", "4" = "Arizona", 
                  "5" = "Arkansas", "6" = "California", "8" = "Colorado", 
                  "9" = "Connecticut", "10" = "Delaware", 
                  "11" = "District of Columbia", "12" = "Florida", 
                  "13" = "Georgia", "15" = "Hawaii", "16" = "Idaho", 
                  "17" = "Illinois", "18" = "Indiana", "19" = "Iowa", 
                  "20" = "Kansas", "22" = "Louisiana", "23" = "Maine", 
                  "24" = "Maryland", "25" = "Massachusetts", "26" = "Michigan",
                  "27" = "Minnesota", "28" = "Mississippi", "29" = "Missouri", 
                  "30" = "Montana", "31" = "Nebraska", "32" = "Nevada", 
                  "33" = "New Hampshire", "34" = "New Jersey", 
                  "35" = "New Mexico", "36" = "New York", "37" = "North Carolina",
                  "38" = "North Dakota", "39" = "Ohio", "40" = "Oklahoma", 
                  "41" = "Oregon", "44" = "Rhode Island", 
                  "45" = "South Carolina", "46" = "South Dakota", 
                  "47" = "Tennessee", "48" = "Texas", "49" = "Utah", 
                  "50" = "Vermont", "51" = "Virginia", "53" = "Washington", 
                  "54" = "West Virginia", "55" = "Wisconsin", "56" = "Wyoming", 
                  "66" = "Guam", "72" = "Puerto Rico", "78" = "Virgin Islands"
)

# labels for income
income_labels <- c("1" = "Less than $15,000",
                   "2" = "$15,000 to < $25,000",
                   "3" = "$25,000 to < $35,000",
                   "4" = "$35,000 to < $50,000",
                   "5" = "$50,000 to < $100,000",
                   "6" = "$100,000 to < $200,000",
                   "7" = "$200,000 or more",
                   "9" = "Don't know/Not sure/Missing"
)

all_labels <- list(
  state_name = list(
    levels = as.numeric(names(state_labels)),
    labels = state_labels
  ),
  
  sex = list(
    levels = c(1,2),
    labels = c("Male","Female")
  ),
  
  income_level = list(
    levels = as.numeric(names(income_labels)),
    labels = income_labels
  ),
  
  physical_activity = list(
    levels = c(1,2,7,9),
    labels = c("Yes","No","Don't know/Not Sure","Refused")
  ),
  
  smoking = list(
    levels = c(2,1,9),
    labels = c("Yes", "No","Don't know/Refused/Missing")
  ),
  
  alc_drnk_30days = list(
    levels = c(1,2,7,9),
    labels = c("Yes","No","Don't know/Not Sure","Refused")
  ),
  
  tobacco_use = list(
    levels = c(1, 2, 3, 7, 9),
    labels = c("Every day", "Some days", "Not at all", 
               "Don't know/Not Sure", "Refused")
  ),
  
  diabetes_status = list(
    levels = c(1,2,3,4,7,9),
    labels = c("Yes", "Gestational diabetes", "No",
               "Pre-diabetes", "Don't know/Not Sure",
               "Refused")
  )
)

# Apply the factor conversion in loop
for (var in names(all_labels)) {
  short_brfss <- factor_labels(
    short_brfss,
    var,
    all_labels[[var]]$levels,
    all_labels[[var]]$labels
  )
}

# Re-coding tobacco use 
short_brfss$tobacco_use <- as.character(short_brfss$tobacco_use)
short_brfss$tobacco_use[short_brfss$tobacco_use %in% 
                          c("Every day", "Some days")] <- "Yes"
short_brfss$tobacco_use[short_brfss$tobacco_use == 
                          "Not at all"] <- "No"

# Re-coding diabetes_status 
short_brfss$diabetes_status[short_brfss$diabetes_status == 
                              "Gestational diabetes"] <- "Yes"
short_brfss$diabetes_status[short_brfss$diabetes_status == 
                              "Pre-diabetes"] <- "No"

# Re-scale numerical variable BMI by dividing by 100
short_brfss$BMI <- short_brfss$BMI/100

# List of variables with empty levels to be replaced with NA
to_be_replaced <- list(
  income_level = c("Don't know/Not sure/Missing"),
  physical_activity = c("Don't know/Not Sure","Refused"),
  smoking         = c("Don't know/Refused/Missing"),
  tobacco_use     = c("Don't know/Not Sure", "Refused"),
  alc_drnk_30days = c("Don't know/Not Sure","Refused"),
  diabetes_status = c("Don't know/Not Sure", "Refused")
)

# Function to replace  
replace_with_na <- function(df, to_be_replaced) {
  for (v in names(to_be_replaced)) 
  {
    df[[v]][df[[v]] %in% to_be_replaced[[v]]] <- NA
  }
  return(df)
}

# Applying function
short_brfss <- replace_with_na(short_brfss, to_be_replaced)

# Clean empty level: income_level 
short_brfss$income_level <- factor(short_brfss$income_level, 
                                   levels = c( "Less than $15,000",
                                               "$15,000 to < $25,000",
                                               "$25,000 to < $35,000",
                                               "$35,000 to < $50,000",
                                               "$50,000 to < $100,000",
                                               "$100,000 to < $200,000",
                                               "$200,000 or more"))

# Clean empty levels using loop
YN_vars <- c("physical_activity",
             "smoking",
             "tobacco_use",
             "alc_drnk_30days",
             "diabetes_status")

for (v in YN_vars) {
  short_brfss[[v]] <- factor(short_brfss[[v]], levels = c("Yes", "No"))
}

# Handling missing values 

# Check frequency and levels of each variable
lapply(short_brfss[, c("diabetes_status", "physical_activity", "smoking", 
                       "tobacco_use", "alc_drnk_30days")], table)

# Check NAs in all columns at once
sapply(short_brfss, function(x) sum(is.na(x)))

# "Complete Case Analysis", involving removing entire rows(cases) that contain 
# any missing values would not be appropriate as this would reduce the sample 
# size and also it would introduce bias as these data are not missing completely
# at random. Therefore, we would do "Available Case Analysis" where we use the 
# data that are present for a respondent and skips for data that are missing. 
# Example: For specific visualizations requiring selected variables, rows with 
# missing values for all selected variables were dropped there to ensure 
# comparative presentation. 
# (Ref: <https://www.tandfonline.com/doi/full/10.1080/10696679.2024.2376052#d1e575>)

# Assigning labels to variables 
# This is placed here because with earlier variables transformation overwrote 
# the objects and removed the labels.
labs <- c(id_no = "Sequence number", 
          state_name = "Name of the State",
          age = "Age of the respondent",
          sex = "Sex of the respondent",
          income_level= "Annual Household income from all sources",
          BMI = "Body Mass Index",
          physical_activity = "Any physical activity in past month?",
          smoking = "Current smoking status",
          tobacco_use = "Current tobacco use",
          alc_drnk_30days = "At least one drink of alcohol in the past 30 days",
          diabetes_status = "Diabetes status",
          diab_first_known = "Age when first told had diabetes")

label(short_brfss) <- as.list(labs[match(names(short_brfss),
                                         names(labs))])

# Export the dataset for further analysis, the dataset was saved to .rds 
# format to preserve the metadata of factor levels and value labels.
saveRDS(short_brfss, 
        file = "./01_Datasets/diabetes_brfss_cleaned.rds", 
        compress = FALSE)

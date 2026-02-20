# Install package: 
# if (!requireNamespace("haven", quitely = TRUE)) install.packages("haven")
# if (!requireNamespace("Hmisc", quitely = TRUE)) install.packages("Hmisc")


# Load library:
library("haven") #to load SAS format data in R
library("Hmisc")

# Load dataset:
# Reads the .XPT file format
# The dataset includes the data on health risk behaviors, chronic diseases and 
# conditions, access to health care, and use of preventive health services 
# related to the leading causes of death and disability in different states of
# the United States of America for the year 2023. The dataset is abbreviated as 
# "BRFSS" for the Behavioral Risk Factor Surveillance System. It was retrieved
# from following url: https://www.cdc.gov/brfss/annual_data/annual_2023.html

whole_brfss <- read_xpt("01_Datasets/whole_BRFSS_2023.XPT")

# Quick snapshot of the dataset:
print(head(whole_brfss))
head_whole_brfss <- head(whole_brfss)

# For the following research question "Are behavioral factors associated 
# with the Diabetes among adults in the USA based on Behavioral Risk 
# Factor Surveillance System data of 2023?, the dataset is filtered for the 
# relevant variables. These variables included: socio-demographic, biological,
# behavioral and diabetes related variables. The outcome variable is of "Diabetes
# Status". 

# Filtering the dataset based on the relevant variables for the research question.
short_brfss <- whole_brfss[c("SEQNO", 
                            "_STATE", 
                            "_AGE80", 
                            "SEXVAR", 
                            "_INCOMG1",
                            "_BMI5",
                            "EXERANY2",
                            "_RFSMOK3", 
                            "USENOW3", 
                            "DRNKANY6",
                            "DIABETE4")] 

# Examine the filtered dataframe:
str(short_brfss)
summary(short_brfss)

# Rename the variables for easy readability: 
names(short_brfss) <- c("id_no", 
                        "state_name", 
                        "age",
                        "sex", 
                        "income_level",
                        "BMI",
                        "physical_activity", 
                        "smoking", 
                        "tobacco_use",
                        "alc_drnk_30days", 
                        "diabetes_status")



# Assigning value labels to categorical variables
# variable: state_name
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

short_brfss$state_name <- factor(short_brfss$state_name,
                                 levels = as.numeric(names(state_labels)),
                                 labels = state_labels
                                 )

# variable: sex
short_brfss$sex <- factor(short_brfss$sex, 
                              levels = c(1, 2),
                              labels = c("Male", "Female"))

# variable: income_level
income_labs <- c("1" = "Less than $15,000",
                         "2" = "$15,000 to < $25,000",
                         "3" = "$25,000 to < $35,000",
                         "4" = "$35,000 to < $50,000",
                         "5" = "$50,000 to < $100,000",
                         "6" = "$100,000 to < $200,000",
                         "7" = "$200,000 or more",
                         "9" = "Don't know/Not sure/Missing")

short_brfss$income_level<- factor(short_brfss$income_level,
                                  levels = as.numeric(names(income_labs)),
                                  labels = income_labs)


# variable: physical_activity
short_brfss$physical_activity <- factor(short_brfss$physical_activity,
                                            levels = c(1, 2, 7, 9),
                                            labels = c("Yes",
                                                       "No",
                                                       "Don't know/Not Sure",
                                                       "Refused"))

# variable: smoking
short_brfss$smoking <- factor(short_brfss$smoking,
                                      levels = c(1, 2, 9),
                                      labels = c("No",
                                                 "Yes",
                                                 "Don't know/Refused/Missing"))
#Reorder the levels 
short_brfss$smoking <- factor(short_brfss$smoking, levels = c("Yes", "No"))


# variable: tobacco_use
short_brfss$tobacco_use <- factor(short_brfss$tobacco_use,
                              levels = c(1, 2, 3, 7, 9),
                              labels = c("Every day",
                                         "Some days",
                                         "Not at all",
                                         "Don't know/Not Sure",
                                         "Refused"))

# Modification to classify current tobacco users into two levels
short_brfss$tobacco_use <- ifelse(short_brfss$tobacco_use %in% 
                                    c("Every day", "Some days"), "Yes",
                           ifelse(short_brfss$tobacco_use == "Not at all", "No", NA))


# variable: alc_intake_30days
short_brfss$alc_drnk_30days <- factor(short_brfss$alc_drnk_30days,
                                      levels = c(1, 2, 7, 9),
                                      labels = c("Yes",
                                                 "No",
                                                 "Don't know/Not Sure",
                                                 "Refused"))

# variable: diabetes_status
short_brfss$diabetes_status <- factor(short_brfss$diabetes_status,
                                      levels = c(1, 2, 3, 4, 7, 9),
                                      labels = c("Yes",
                                                 "Gestational diabetes",
                                                 "No",
                                                 "Pre-diabetes",
                                                 "Don't know/Not Sure",
                                                 "Refused"))

# Since a lot of initial rows seemed blank, it was not clear if the value labels
# were assigned correctly, therefore, I checked for the count of each types and 
# which row had the first instance.
table(short_brfss$diabetes_type)
which(short_brfss$diabetes_type == 2)

# Additionally, we will modify the level "Gestational diabetes" to "Yes" and 
# "Pre-diabetes" to "No". This would be crucial for later logistics regression 
# as in R it needs outcome variable "Y" with a factor with two levels.
short_brfss$diabetes_status[short_brfss$diabetes_status == "Gestational diabetes"] <- "Yes"
short_brfss$diabetes_status[short_brfss$diabetes_status == "Pre-diabetes"] <- "No"

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
          diabetes_status = "Diabetes status")

label(short_brfss) <- as.list(labs[match(names(short_brfss),
                                         names(labs))])


# Adding 2 decimal places for numerical variable: BMI
short_brfss$BMI <- short_brfss$BMI/100

# Handling missing values section
# Replace the values like missing, don't know/not sure, refused, to NA for 
# easier missing value calculation

to_be_replaced <- list(
  income_level = c("Don't know/Not sure/Missing"),
  physical_activity = c("Don't know/Not Sure","Refused"),
  smoking         = c("Don't know/Refused/Missing"),
  alc_drnk_30days = c("Don't know/Not Sure","Refused"),
  diabetes_status = c("Don't know/Not Sure", "Refused")
  )

replace_with_na <- function(df, to_be_replaced) {
  for (v in names(to_be_replaced)) 
    {
    df[[v]][df[[v]] %in% to_be_replaced[[v]]] <- NA
    }
  return(df)
  }


short_brfss <- replace_with_na(short_brfss, to_be_replaced)


# Check NAs in all columns at once
sapply(short_brfss, function(x) sum(is.na(x)))


# Deleting empty factor levels from the variables
short_brfss$income_level <- factor(short_brfss$income_level, 
                                   levels = c( "Less than $15,000",
                                               "$15,000 to < $25,000",
                                               "$25,000 to < $35,000",
                                               "$35,000 to < $50,000",
                                               "$50,000 to < $100,000",
                                               "$100,000 to < $200,000",
                                               "$200,000 or more"))

# Reusing Yes, No levels
reuse_yn <- c("Yes", "No")

short_brfss$physical_activity <- factor(short_brfss$physical_activity, 
                                        levels = reuse_yn)

short_brfss$smoking <- factor(short_brfss$smoking, 
                              levels = reuse_yn)

short_brfss$tobacco_use <- factor(short_brfss$tobacco_use, 
                                  levels = reuse_yn)

short_brfss$alc_drnk_30days <- factor(short_brfss$alc_drnk_30days, 
                                      levels = reuse_yn)

short_brfss$diabetes_status <- factor(short_brfss$diabetes_status, 
                                      levels = reuse_yn)

# Check levels of each variable
lapply(short_brfss[, c("diabetes_status", "physical_activity", "smoking", 
                       "tobacco_use", "alc_drnk_30days")], table)

# Given that most predictor variables have large number of missing values, 
# "Complete Case Analysis", involving removing entire rows(cases) that contain 
# any missing values would not be appropriate as this would reduce the sample 
# size and also it would introduce bias as these data are not missing completely 
# at random. Therefore, we would do "Available Case Analysis" at least for the 
# predictor variables where we use the data that are present for a respondent 
# and skips for data that are missing.However, we would only drop those NAs which
# are in the outcome variable (diabetes status) so that it won't affect the model
# performance.  
# (Ref: https://www.tandfonline.com/doi/full/10.1080/10696679.2024.2376052#d1e575)


# Dropping rows from data frame with NA values in diabetes_status
short_brfss <- subset(short_brfss, !is.na(diabetes_status))

# Checks NAs in diabetes_status
sum(is.na(short_brfss$diabetes_status))


# Check structure after deletion
str(short_brfss)

# Export cleaned dataset for further analysis, the dataset was saved to .rds 
# format to preserve the metadata of factor levels and value labels.
saveRDS(short_brfss, 
        file = "./01_Datasets/diabetes_brfss_cleaned.rds", 
        compress = FALSE)









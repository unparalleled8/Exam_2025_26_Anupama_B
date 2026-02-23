# Install packages: 
# if (!requireNamespace("haven")) install.packages("haven")
if (!requireNamespace("Hmisc")) install.packages("Hmisc")


# Load library:
# library("haven") # to load SAS format (.XPT) data in R
library("Hmisc") # to assign labels to variables

# Load dataset:
# At first, I extracted .XPT file and worked on it, however, later, I faced 
# issues while pushing to Github due to large file size (>1 GB. Therefore, I 
# converted it to .rds format to compress the file to around 45 MB which could 
# be pushed to Github. 

# whole_brfss <- read_xpt("01_Datasets/whole_BRFSS_2023.XPT")

# Therefore, I converted it to .rds format to compress the file to 45.8 MB 
# and it could be uploaded to Github. 

# saveRDS(whole_brfss, 
#        file = "./01_Datasets/whole_BRFSS_2023.rds", 
#        compress = TRUE)

whole_brfss <- readRDS("01_Datasets/whole_BRFSS_2023.rds")


# Quick snapshot of the whole dataset:
print(head(whole_brfss))
head_whole_brfss <- head(whole_brfss)

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
                            "DIABETE4",
                            "DIABAGE4")] 


# Rename the variables for easy readability: 
names(short_brfss) <- c("id_no", 
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
                        "diab_first_known")  # Age when first told had diabetes


# Examine the filtered dataframe:
str(short_brfss)


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

# Additionally, we will modify the level "Gestational diabetes" to "Yes" and 
# "Pre-diabetes" to "No". This would be crucial for later logistics regression 
# as in R it needs outcome variable "Y" with a factor with two levels.
short_brfss$diabetes_status[short_brfss$diabetes_status == 
                              "Gestational diabetes"] <- "Yes"
short_brfss$diabetes_status[short_brfss$diabetes_status == 
                              "Pre-diabetes"] <- "No"


# Adding 2 decimal places for numerical variable: BMI
short_brfss$BMI <- short_brfss$BMI/100


# Replace the values like missing, don't know/not sure, refused, to NA for 
# easier missing value calculation
# Function prep to replace with NA
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
# Handling missing values 

# Check NAs in all columns at once
sapply(short_brfss, function(x) sum(is.na(x)))

# Given that most predictor variables have large number of missing values, 
# "Complete Case Analysis", involving removing entire rows(cases) that contain 
# any missing values would not be appropriate as this would reduce the sample 
# size and also it would introduce bias as these data are not missing completely 
# at random. Therefore, we would do "Available Case Analysis" for the predictor 
# variables where we use the data that are present for a respondent and skips 
# for data that are missing. Example: For specific visualizations requiring 
# selected variables, rows with missing values for all selected variables were 
# excluded to ensure comparative presentation.

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









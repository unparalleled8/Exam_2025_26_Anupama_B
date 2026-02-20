#install package:
install.packages("jtools")
# Load library: 


# Load dataset:
df <- readRDS("./01_Datasets/diabetes_brfss_cleaned.rds")

# Calculate logistic regression
# Since we are interested to test the association of behavioral variables 
# with the Diabetes, we will administered only those relevant variables to the
# model. Further, logistic regression predicts the probability of the higher 
# level, hence, for better interpretation of the results, we will reorder the 
# level as "no" and "yes". 

table(df$diabetes_status)
df$diabetes_status <- factor(df$diabetes_status, levels = c("No", "Yes"))

# Logistics regression calculation
LR_1 <- glm(diabetes_status ~ physical_activity + smoking + tobacco_use +
              alc_drnk_30days, 
            family = binomial(link = "logit"), data = df)

# Report estimated odds ratio,p-value and 95% CI. 
jtools::summ(LR_1, exp = T, confint = T, model.fit = F, digits = 3)

# Estimated odds ratio (OR), 95% confidence interval of OR and p-value for each 
# predictor

# physical_activityNo: OR = 2.035 (95% CI:1.996 to 2.074; p-value < 0.001)
# smokingNo: OR = 1.097 (95% CI: 1.066 to 1.129; p-value < 0.001)
# tobacco_useNo: OR = 0.981 (95% CI: 0.929 to 1.037; p-value = 0.502)
# alc_drnk_30daysNo: OR = 2.015 (95% CI: 1.978 to 2.053; p-value < 0.001)

# Interpretation:

# According to multivariable logistic regression, the odds of having diabetes
# among those who are not physically active in a month increases by 2.035 times 
# (95% CI:1.996 to 2.074; p-value < 0.001). Similarly, the odds of having
# diabetes among those who drink alcohol in 30 days increases by 2.015 times 
# (95% CI: 1.978 to 2.053; p-value < 0.001). Interestingly, model showed that
# current non-smokers had statistically significant likelihood of having diabetes
# by 1.097 times (95% CI: 1.066 to 1.129; p-value < 0.001) compared to those who
# did not smoke. However, there is no statistical significant association of 
# current tobacco use with having diabetes OR = 0.981 (95% CI: 0.929 to 1.037; 
# p-value = 0.502). In conclusion, only "Physical Activity in a month" and
# "Alcohol Consumption in 30 days" among the behavioral characteristics, have
# statistical significant association with the diabetes.  


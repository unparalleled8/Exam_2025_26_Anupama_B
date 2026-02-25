# Install packages: 
if (!requireNamespace("ggplot2")) install.packages("ggplot2")
if (!requireNamespace("usmap")) install.packages("usmap")

# Load library:
library("ggplot2")
library("usmap")

# Load dataset:
df <- readRDS("./01_Datasets/diabetes_brfss_cleaned.rds")

# Socio-demographic characteristics:

# 1. Population pyramid (Age & Sex):
# Create age groups
df$age_g <- cut(df$age,
                breaks = c(18, 25, 30, 
                           35, 40, 45, 
                           50, 55, 60, 
                           65, 70, 75, 
                           80, Inf),
                labels = c("18-24", "25-29", 
                           "30-34", "35-39", 
                           "40-44", "45-49",
                           "50-54", "55-59", 
                           "60-64", "65-69", 
                           "70-74", "75-79", 
                           ">= 80"),
                right = FALSE)


# Creating dataframe with age groups and sex for pyramid
py_df <- as.data.frame(table(df$age_g, 
                             df$sex))
colnames(py_df) <- c("age", 
                     "sex", 
                     "count")
# Sum for n value
total_pop <- sum(py_df$Freq)

# Convert count to percentage
py_df$count <- py_df$count / sum(py_df$count) * 100

# Making one sex values negative for pyramid effect
py_df$count <- ifelse(py_df$sex == "Male", 
                      -py_df$count, py_df$count)

# Create population pyramid
ggplot(py_df, 
       aes(x = age, 
           y = count, 
           fill = sex)) +
  geom_bar(stat = "identity") +
  
  # Adding percentage to bars
  geom_text(aes(label = paste0(round(abs(count), 1), "%"),
                hjust = ifelse(sex == "Male", 1.2, -0.2)),
             position = "identity",
                 size = 2.5,
                color = "black") +
  
  scale_y_continuous(labels = function(x) paste0(abs(x), "%"),
                     limits = max(py_df$count) * c(-1.2, 1.2)) +
  
  labs(title = expression(underline("Population Pyramid of BRFSS in 2023")), 
          subtitle = expression(underline("n = 433,323")),
           x = "Age (in years)", 
           y = "Population (in Percentage)") +
  
  scale_colour_manual("Sex", values = c("steelblue", "pink"),
                    aesthetics = c("colour", "fill")) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, 
                              size = 12),
    axis.title = element_text(size = 8),
    axis.text = element_text(size = 8),
    legend.position = "bottom",
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8)) +
  coord_flip()



# 2. Biological Characteristics:
# 2.2 Mean BMI
summary(df$BMI, na.rm = TRUE)

# 3. Behavioral Characteristics: 
# 3.1 2×2 panel (multi-panel): physical activity, smoking, alcohol intake, tobacco use
# Creating dataframe with behavioral variables
behav_char <- df[c("physical_activity", 
                   "smoking", 
                   "tobacco_use", 
                   "alc_drnk_30days")]

# Removing NAs from all to make plots comparable
behav_char_clean <- behav_char[complete.cases(behav_char), ]

# Count observation for n
# nrow(behav_char_clean)

# Counts table
tab_behav <- sapply(behav_char_clean, table)

# Transpose to wide data frame
t_tab_behav <- as.data.frame(t(tab_behav))
t_tab_behav$variable <- rownames(t_tab_behav)

# Reshape to long
l_tab_behav <- reshape(t_tab_behav,
                       varying   = c("Yes", "No"),
                       v.names   = "Count",
                       timevar   = "Response",
                       times     = c("Yes", "No"),
                       direction = "long")
# Set factor orders
l_tab_behav$Response <- factor(l_tab_behav$Response, levels = c("Yes", "No"))
l_tab_behav$variable <- factor(l_tab_behav$variable,
                               levels = c("physical_activity", "smoking",
                                          "tobacco_use", "alc_drnk_30days"),
                               labels = c("Physical activity in month", "Smoking",
                                          "Tobacco use", "Alc intake in 30 days"))
# Bar plot
ggplot(l_tab_behav, aes(x = Response, y = Count, fill = Response)) +
  geom_bar(stat = "identity", width = 0.6) +
  scale_fill_manual(values = c("Yes" = "#1f77b4", "No" = "orange")) +
  scale_y_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.12))) +
  facet_wrap(~ variable, nrow = 2, ncol = 2) +
  geom_text(aes(label = scales::comma(Count)),
            vjust = -0.4, size = 3.2) +
  labs(title = expression(underline("Behavioral Characteristics: BRFSS in 2023")),
       subtitle = expression(underline("n = 399,230")),
       x = NULL, 
       y = "Count",
       caption = "Figure 2: Behavioral Characteristics of the respondents of BRFSS in 2023")  +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, 
                              size = 12),
    plot.subtitle = element_text(hjust = 0.5,
                                 size = 8, 
                                 color = "gray40"),
    axis.title = element_text(size = 8),
    axis.text = element_text(size = 8, 
                             hjust = 1),
    plot.caption = element_text(hjust = 0.5, 
                                face = "italic", 
                                size = 8),
    legend.position    = "none",
    strip.text         = element_text(face = "bold"),
    panel.grid.major.x = element_blank())


# 4. Diabetes related:
# 4.1 Diabetes Status by Income Level
# Keep filled rows in both income_level and diabetes_status, removing NAs
income_diab <- df[c("income_level", "diabetes_status")]
income_diab_clean <- income_diab[complete.cases(income_diab), ]

# barplot
ggplot(income_diab_clean, aes(x = income_level, fill = diabetes_status)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("Yes" = "darkred", "No" = "#4daf4a")) +
  labs(
    title = expression(underline("Diabetes Status by Income Level")),
    subtitle = expression(underline("n = 346,224")),
    x = "Income Level",
    y = "Frequency",
    fill = "Diabetes"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, 
                              size = 12),
    axis.title = element_text(size = 8),
    plot.subtitle = element_text(hjust = 0.5,
                                 size = 7, 
                                 color = "gray40"),
    axis.line = element_line(color = "grey", 
                             linewidth = 0.8),
    axis.text = element_text(size = 8, 
                             angle = 45,
                             hjust = 1))


# 3. Visualize the diabetes status on US MAP
# Create dataframe with state name and diabetes cases
diab_st_df <- as.data.frame(table(df$state_name, df$diabetes_status))
colnames(diab_st_df) <- c("state", 
                     "diabetes_status", 
                     "frequency")

# Widening the df with separate "No" count
diab_st_df <- reshape(diab_st_df, 
                     idvar = names(diab_st_df)[1],
                     timevar = "diabetes_status", 
                     direction = "wide",
                     v.names = "frequency")

# Stripping the "frequency." prefix
names(diab_st_df) <- gsub("frequency\\.", "", names(diab_st_df))

# Adding total column
diab_st_df$total <- diab_st_df$Yes + diab_st_df$No

# Adding prevalence column
diab_st_df$prevalence <- (diab_st_df$Yes / diab_st_df$total) * 100

# Before plotting, verify all U.S. states are represented in diab_state_df
# by comparing against the built-in 'statepop' reference dataset from the
# usmap package.

statepop <- usmap::statepop
setdiff(statepop$full, diab_st_df$state)
# There is no diabetes data available from the "Kentucky", "Pennsylvania" state.
# Sometimes the data are not reported for certain states if they don't fulfill 
# certain requirements.

# Prep to add each state name to label on map

# Plotting the diabetes cases from survey in the US map
plot_usmap(data = diab_st_df,
           regions = "states",
           values = "prevalence",
           include = c(state.abb, "PR"), #default: excludes Puerto Rico
           color = "white",
           labels = TRUE) +  
  scale_fill_continuous(low = "lightyellow", high = "darkred") +
  labs(
    title = expression(underline("US States by Diabetes Prevalence: BRFSS, 2023"),
    fill = "Prevalence")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 15, face = "bold",
                              margin = margin (b = 5)),
    plot.margin = margin(t = 10, r = 10, b = 10, l = 40),
    plot.background = element_rect(fill = "lightblue", color = NA),
    legend.position = "right",
    legend.background = element_rect(fill = "lightblue", color = NA))

# Diabetes related:
# Mean Age of First Known Diabetes Diagnosis
mean_diab_first <- mean(df$diab_first_known, na.rm = TRUE)
print(mean_diab_first)





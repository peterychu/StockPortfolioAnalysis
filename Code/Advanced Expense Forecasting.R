# Load necessary libraries
library(dplyr)
library(ggplot2)
library(forecast)  # For moving average and other time series methods

# Read and clean data
total_expense_average <- read.csv("C:/Users/Hp Omen/Downloads/total_expense_average.csv")
total_expense_average$AverageExpense <- as.numeric(gsub("[\\$,]", "", total_expense_average$Value))

# The dataset inflation_rate_monthly is already in the environment
# No need to load from a CSV file

# Calculate annual inflation and expense growth
months <- names(inflation_rate_monthly)[-1] # Exclude 'Year'
inflation_multipliers <- inflation_rate_monthly
for(month in months) {
  inflation_multipliers[[month]] <- 1 + inflation_rate_monthly[[month]] / 100
}
yearly_change_multipliers <- apply(inflation_multipliers[, -1], 1, prod)  # exclude 'Year'
yearly_percentage_change <- round((yearly_change_multipliers - 1) * 100, 2)
yearly_inflation_change <- data.frame(Year = inflation_rate_monthly$Year, YearlyPercentageChange = yearly_percentage_change)

# Apply Moving Average to smooth yearly changes
smoothed_yearly_change <- ma(yearly_inflation_change$YearlyPercentageChange, order=3)
smoothed_vector <- as.numeric(smoothed_yearly_change)  # Convert ts to numeric vector
mean_smoothed_change <- mean(smoothed_vector, na.rm = TRUE)  # Use mean for uniform predictions

# Predict future expenses using smoothed inflation estimates
last_value_2022 <- tail(total_expense_average$AverageExpense, 1)
future_years <- 2023:2042
predictions <- numeric(length(future_years))
predictions[1] <- last_value_2022 * (1 + mean_smoothed_change / 100)
for (i in 2:length(predictions)) {
  predictions[i] <- predictions[i - 1] * (1 + mean_smoothed_change / 100)
}
predictions_df <- data.frame(Year = future_years, PredictedValue = round(predictions, 2))

# Plot smoothed inflation trends and predictions
ggplot(yearly_inflation_change, aes(x = Year)) +
  geom_line(aes(y = smoothed_vector, color = "Smoothed Changes"), size = 1) +  # Adding a color aesthetic for the line
  geom_point(aes(y = YearlyPercentageChange, color = "Actual Changes"), alpha = 0.4) +  # Adding a color aesthetic for the points
  labs(title = "Smoothed Yearly Inflation Changes", x = "Year", y = "Inflation Change (%)", 
       color = "Legend") +  # Adding a title and labels including a legend title
  theme(plot.title = element_text(hjust = 0.5))

ggplot(predictions_df, aes(x = Year, y = PredictedValue)) +
  geom_line(color = "green") +
  labs(title = "Predicted Average Expenses from 2023 to 2042", x = "Year", y = "Predicted Average Expense ($)")

# Perform Sensitivity Analysis on Inflation Impact
sensitivity_results <- data.frame()
for (inflation_adjustment in seq(-0.01, 0.01, by = 0.005)) {
  adjusted_predictions <- numeric(length(future_years))
  adjusted_predictions[1] <- last_value_2022 * (1 + (mean_smoothed_change + inflation_adjustment) / 100)
  for (i in 2:length(adjusted_predictions)) {
    adjusted_predictions[i] <- adjusted_predictions[i - 1] * (1 + (mean_smoothed_change + inflation_adjustment) / 100)
  }
  sensitivity_results <- rbind(sensitivity_results, data.frame(Year = future_years, PredictedValue = adjusted_predictions, Scenario = paste("Inflation", inflation_adjustment)))
}

ggplot(sensitivity_results, aes(x = Year, y = PredictedValue, color = Scenario)) +
  geom_line() +
  labs(title = "Sensitivity Analysis of Predicted Expenses to Inflation Adjustments", x = "Year", y = "Predicted Expenses ($)", color = "Scenario")

# Output the predicted expense for 2042
predicted_value_2042 <- tail(predictions_df$PredictedValue, 1)
cat("Predicted expense for 2042: $", predicted_value_2042, "\n")

















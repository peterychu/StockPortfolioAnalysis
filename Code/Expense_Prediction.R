# Load necessary libraries
library(dplyr)
library(ggplot2)

total_expense_average <- read.csv("C:/Users/Hp Omen/Downloads/total_expense_average.csv")
inflation_multipliers <- Inflation_monthly_rate
months <- names(Inflation_monthly_rate)[-1] # Exclude 'Year'
for(month in months) {
  inflation_multipliers[[month]] <- 1 + Inflation_monthly_rate[[month]] / 100
}

yearly_change_multipliers <- inflation_multipliers %>%
  select(-Year) %>%
  apply(1, prod)

yearly_percentage_change <- round((yearly_change_multipliers - 1) * 100, 2)
yearly_inflation_change <- data.frame(Year = Inflation_monthly_rate$Year, YearlyPercentageChange = yearly_percentage_change)

# ----- Plot Yearly Inflation Change -----
ggplot(yearly_inflation_change, aes(x = Year, y = YearlyPercentageChange)) +
  geom_point(aes(color = YearlyPercentageChange), size = 4, alpha = 0.6) + 
  geom_smooth(method = "loess", se = FALSE, color = "darkgreen", size = 1.5) + 
  scale_color_gradient(low = "blue", high = "red") + 
  theme_bw() +
  labs(title = "Yearly Inflation Change",
       x = "Year",
       y = "Yearly Percentage Change (%)") +
  scale_x_continuous(breaks = seq(min(yearly_inflation_change$Year), max(yearly_inflation_change$Year), by = 3)) +
  theme(legend.position = "none")

# ----- Average Yearly Percentage Change -----
average_yearly_percentage_change <- mean(yearly_inflation_change$YearlyPercentageChange, na.rm = TRUE)
average_yearly_percentage_change_rounded <- round(average_yearly_percentage_change, 2)

# ----- Total Expense Average Calculation -----
total_expense_average$AverageExpense <- as.numeric(gsub("[\\$,]", "", total_expense_average$Value))
expense_changes <- c(NA, diff(total_expense_average$AverageExpense) / lag(total_expense_average$AverageExpense) * 100)
mean_change <- mean(expense_changes, na.rm = TRUE)
mean_change_rounded <- round(mean_change, 2)

# ----- Predictions from 2022 to 2042 -----
last_value_2022 <- tail(total_expense_average$AverageExpense, 1)
combined_average_rate <- (mean_change_rounded + average_yearly_percentage_change_rounded) / 2
predictions <- numeric(length(2023:2042))
predictions[1] <- last_value_2022 * (1 + combined_average_rate / 100)
for (i in 2:length(predictions)) {
  predictions[i] <- predictions[i - 1] * (1 + combined_average_rate / 100)
}
predictions_df <- data.frame(Year = 2023:2042, PredictedValue = round(predictions, 2))

# ----- Plot Predictions -----
ggplot(predictions_df, aes(x = Year, y = PredictedValue)) +
  geom_point(aes(color = PredictedValue), size = 2) +  
  geom_smooth(method = "lm", color = "blue", se = FALSE) +  
  scale_color_gradient(low = "yellow", high = "red") +  
  theme_minimal() +
  labs(title = "Predicted Average Expenses from 2023 to 2042",
       x = "Year",
       y = "Predicted Average Expense ($)") +
  theme(legend.position = "none")

predicted_value_2042 <- predictions_df[predictions_df$Year == 2042, "PredictedValue"]

# Print the predicted expense for 2042
print(paste("How much will someone spend in the year 2042? They will spend approximately $", predicted_value_2042, ".", sep = ""))

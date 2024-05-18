library(dplyr)
library(PerformanceAnalytics)
library(xts)
library(data.table)
library(lubridate)
library(knitr)
library(tidyverse)
library(tidyquant)
library(ggplot2)

mkt_rfr_ret <- read.csv("Data/Data for use/1_month_T_Bills_yield.csv")
mkt_ret <- read.csv("Data/Data for use/market_monthly_return_2004_2024.csv")

mkt_ret <- mkt_ret[2:(nrow(mkt_ret)-4),]
mkt_rfr_ret <- mkt_rfr_ret[2:(nrow(mkt_rfr_ret)-1),]


mkt <- read.csv("Data/Data for use/market_monthly_return_2004_2024.csv") %>% mutate(Date = paste0(Month, '-01')) %>% select(Date, Return)
mkt <- mkt[2:(nrow(mkt)-4),]  # %>% mutate(mkt_rfr = mkt_ret['Return']) 
mkt <- mkt %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)

mkt$Date <- ymd(mkt$Date)
mkt <- mkt[order(mkt$Date),]
mkt <- xts(mkt[,-1], order.by = mkt[,1],) # -0.1183

# Best portfolio had 50% IVV and 50% QQQ
IVV <- read.csv("Data/Data for use/IVV.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
QQQ <- read.csv("Data/Data for use/QQQ.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)


# Add symbol column for portfolio creation
IVV_mod <- IVV[c('Date', 'returns')] %>% mutate('symbol' = 'IVV')
QQQ_mod <- QQQ[c('Date', 'returns')] %>% mutate('symbol' = 'QQQ')


final_stocks_monthly_returns <- rbind(IVV_mod, QQQ_mod)

final_stocks_monthly_returns$Date <- as.Date(final_stocks_monthly_returns$Date)

final_stocks_multi_monthly_returns <- final_stocks_monthly_returns %>% tq_repeat_df(n = 3)
head(final_stocks_multi_monthly_returns)
head(final_stocks_multi_monthly_returns)
weights <- c(0.5,0.5,0.25,0.75,0.75,0.25)
weights_table <- tibble(c('IVV', 'QQQ')) %>%
  tq_repeat_df(n = 3) %>%
  bind_cols((tibble(weights))) %>%
  group_by(portfolio)

final_portfolio_multi_monthly_returns <-  final_stocks_multi_monthly_returns %>%
  tq_portfolio(assets_col  = symbol, 
               returns_col = returns, 
               weights     = weights_table)

final_portfolio_multi_monthly_growth <- final_stocks_multi_monthly_returns %>%
  tq_portfolio(assets_col   = symbol, 
               returns_col  = returns, 
               weights      = weights_table, 
               col_rename   = "investment.growth",
               wealth.index = TRUE) %>%
  mutate(investment.growth = investment.growth * 1000)

final_portfolio_multi_monthly_growth <- final_portfolio_multi_monthly_growth %>%
  mutate(portfolio = factor(portfolio, levels = c("1", "2", "3"),
                            labels = c("50/50", "25/75", "75/25")))

final_portfolio_multi_monthly_growth %>%
  ggplot(aes(x = Date, y = investment.growth, color = factor(portfolio))) +
  geom_line(size = 2) +
  labs(title = "Portfolio Growth",
       subtitle = "Comparing Multiple Portfolios",
       caption = "Portfolio 2 visually performs the best",
       x = "Year", y = "Portfolio Value",
       color = "Portfolio") +
  geom_smooth(method = "loess") +
  theme_tq() +
  scale_color_tq() +
  scale_y_continuous(labels = scales::dollar)   


# PORTFOLIO 2 DID THE BEST WOW  OK
# VERIFY
mean_50_50 <- mean(final_portfolio_multi_monthly_returns[final_portfolio_multi_monthly_returns$portfolio == 1,]$portfolio.returns)
mean_25_75 <- mean(final_portfolio_multi_monthly_returns[final_portfolio_multi_monthly_returns$portfolio == 2,]$portfolio.returns)
mean_75_25 <- mean(final_portfolio_multi_monthly_returns[final_portfolio_multi_monthly_returns$portfolio == 3,]$portfolio.returns)

sd_50_50 <- sd(final_portfolio_multi_monthly_returns[final_portfolio_multi_monthly_returns$portfolio == 1,]$portfolio.returns)
sd_25_75 <- sd(final_portfolio_multi_monthly_returns[final_portfolio_multi_monthly_returns$portfolio == 2,]$portfolio.returns)
sd_75_25 <- sd(final_portfolio_multi_monthly_returns[final_portfolio_multi_monthly_returns$portfolio == 3,]$portfolio.returns)


df <- data.frame(Weights = c('50/50', '25/75', '75/25'),
                 Mean_Returns = c(mean_50_50, mean_25_75, mean_75_25),
                 Standard_Deviations_Returns = c(sd_50_50, sd_25_75, sd_75_25))
library(knitr)
kable(df)


calculate_initial_amount <- function(monthly_interest_rate, monthly_payment, total_months) {
  pv_payments <- 0
  for (i in 1:total_months) {
    pv_payments <- pv_payments + monthly_payment / ((1 + monthly_interest_rate) ^ i)
  }
  return(pv_payments)
}

plot_initial_amount_over_time_ggplot_varying_years <- function(interest_rate, monthly_payment, years_list) {
  df <- data.frame(time = numeric(), remaining_balance = numeric(), year = character())
  
  for (years in years_list) {
    total_months <- years * 12
    initial_amount <- calculate_initial_amount(interest_rate, monthly_payment, total_months)
    
    remaining_balance <- rep(0, total_months + 1)
    remaining_balance[1] <- initial_amount
    
    for (j in 1:total_months) {
      remaining_balance[j + 1] <- remaining_balance[j] * (1 + interest_rate) - monthly_payment
    }
    
    time <- seq(0, years, by = 1 / 12)
    df <- rbind(df, data.frame(time = time, remaining_balance = remaining_balance, year = as.character(years)))
  }
  
  ggplot(df, aes(x = time, y = remaining_balance, color = year)) +
    geom_line() +
    labs(x = "Years", y = "Remaining Balance", title = "Remaining Balance Over Time") +
    scale_color_discrete(name = "Years") +
    theme(
      plot.margin = unit(c(1, 1, 1, 1), "cm"),
      aspect.ratio = 0.5,
      panel.grid.major = element_line(colour = "grey", size = 0.5),
      panel.grid.minor = element_line(colour = "lightgrey", size = 0.25)
    ) + scale_y_continuous(labels = scales::comma)
}

interest_rate <- 0.01145029  
monthly_payment <- 118553.7 / 12  
years <- c(5, 13, 21)

plot_initial_amount_over_time_ggplot_varying_years(interest_rate, monthly_payment, years)




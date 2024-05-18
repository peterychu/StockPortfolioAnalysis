library(dplyr)
library(PerformanceAnalytics)
library(xts)
library(data.table)
library(lubridate)
library(knitr)

mkt_rfr_ret <- read.csv("Data/Data for use/1_month_T_Bills_yield.csv")
mkt_ret <- read.csv("Data/Data for use/market_monthly_return_2004_2024.csv")

mkt_ret <- mkt_ret[2:(nrow(mkt_ret)-4),]
mkt_rfr_ret <- mkt_rfr_ret[2:(nrow(mkt_rfr_ret)-1),]

tail(mkt_rfr_ret)


QQQ <- read.csv("Data/Data for use/QQQ.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
IVV <- read.csv("Data/Data for use/IVV.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
TLT <- read.csv("Data/Data for use/TLT.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
VSMCX <- read.csv("Data/Data for use/VSMCX.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
XLE <- read.csv("Data/Data for use/XLE.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
XLF <- read.csv("Data/Data for use/XLF.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
XLI <- read.csv("Data/Data for use/XLI.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
XLP <- read.csv("Data/Data for use/XLP.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)
XLV <- read.csv("Data/Data for use/XLV.csv")  %>% select(Date, returns) %>% mutate(mkt_return = mkt_ret$Return) %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)


process_xts_data <- function(TCK) {
    TCK$Date <- ymd(TCK$Date)
    TCK <- TCK[order(TCK$Date), ]
    xts_obj <- xts(TCK[,-1], order.by = TCK[,1],)

    return(xts_obj)

}

# QQQ$Date <- ymd(QQQ$Date)
# QQQ <- QQQ[order(QQQ$Date),]
# QQQ <- xts(QQQ[,-1], order.by = QQQ[,1],)

QQQ <- process_xts_data(QQQ)
IVV <- process_xts_data(IVV)
TLT <- process_xts_data(TLT)
VSMCX <- process_xts_data(VSMCX)
XLE <- process_xts_data(XLE)
XLF <- process_xts_data(XLF)
XLI <- process_xts_data(XLI)
XLP <- process_xts_data(XLP)
XLV <- process_xts_data(XLV)


QQQ_SR <- SharpeRatio(QQQ$returns,QQQ$mkt_rfr)
QQQ_TR <- TreynorRatio(QQQ$returns,QQQ$mkt_return,QQQ$mkt_rfr)
QQQ_model <- lm(returns~mkt_return, data = QQQ)
summary(QQQ_model) # 1.1129, adj = 0.8243
mean(QQQ$mkt_rfr)

IVV_SR <- SharpeRatio(IVV$returns, IVV$mkt_rfr)
IVV_TR <- TreynorRatio(IVV$returns,IVV$mkt_return,IVV$mkt_rfr)
IVV_model <- lm(returns~mkt_return, data = IVV)
summary(IVV_model) # 0.9999, adj = 0.9992 Yahoo: 1, 0.9495

TLT_SR <- SharpeRatio(TLT$returns, TLT$mkt_rfr)
TLT_TR <- TreynorRatio(TLT$returns,TLT$mkt_return,TLT$mkt_rfr)
TLT_model <- lm(returns~mkt_return, data = TLT)
summary(TLT_model) # ??????????-0.106, adj 0.009 Yahoo: 2.53, 78.29

VSMCX_SR <- SharpeRatio(VSMCX$returns, VSMCX$mkt_rfr)
VSMCX_TR <- TreynorRatio(VSMCX$returns,VSMCX$mkt_return,VSMCX$mkt_rfr)
VSMCX_model <- lm(returns~mkt_return, data = VSMCX)
summary(VSMCX_model) # 1.446, adj = 0.4112 Yahoo: 1.38, 0.68

XLE_SR <- SharpeRatio(XLE$returns, XLE$mkt_rfr)
XLE_TR <- TreynorRatio(XLE$returns,XLE$mkt_return,XLE$mkt_rfr)
XLE_model <- lm(returns~mkt_return, data = XLE)
summary(XLE_model) # 1.163, adj = 0.4255 Yahoo: 1.3  41.16

XLF_SR <- SharpeRatio(XLF$returns, XLF$mkt_rfr)
XLF_TR <- TreynorRatio(XLF$returns,XLF$mkt_return,XLF$mkt_rfr)
XLF_model <- lm(returns~mkt_return, data = XLF)
summary(XLF_model) # 1.2495, adj = 0.7332 Yahoo: 1.1, 70.51

XLI_SR <- SharpeRatio(XLI$returns, XLI$mkt_rfr)
XLI_TR <- TreynorRatio(XLI$returns,XLI$mkt_return,XLI$mkt_rfr)
XLI_model <- lm(returns~mkt_return, data = XLI)
summary(XLI_model) # 1.1513, adj = 0.8589 Yahoo: 1.12, 81.3

XLP_SR <- SharpeRatio(XLP$returns, XLP$mkt_rfr)
XLP_TR <-TreynorRatio(XLP$returns,XLP$mkt_return,XLP$mkt_rfr)
XLP_model <- lm(returns~mkt_return, data = XLP)
summary(XLP_model) # 0.6, adj = 0.5661 Yahoo: 0.59, 46.4

XLV_SR <- SharpeRatio(XLV$returns, XLV$mkt_rfr)
XLV_TR <- TreynorRatio(XLV$returns,XLV$mkt_return,XLV$mkt_rfr)
XLV_model <- lm(returns~mkt_return, data = XLV)
summary(XLV_model) # 0.719, adj = 0.6241 Yahoo: 0.73, 59



mkt <- read.csv("Data/Data for use/market_monthly_return_2004_2024.csv") %>% mutate(Date = paste0(Month, '-01')) %>% select(Date, Return)
mkt <- mkt[2:(nrow(mkt)-4),]  # %>% mutate(mkt_rfr = mkt_ret['Return']) 
mkt <- mkt %>% mutate(mkt_rfr = mkt_rfr_ret$Return / 100)

mkt$Date <- ymd(mkt$Date)
mkt <- mkt[order(mkt$Date),]
mkt <- xts(mkt[,-1], order.by = mkt[,1],) # -0.1183

mkt_SR <- SharpeRatio(mkt$Return, mkt$mkt_rfr)
mkt_TR <- TreynorRatio(mkt$Return, mkt$Return, mkt$mkt_rfr)

xts_combined_data <- data.frame(Date = QQQ$Date, QQQ = QQQ$returns, TLT = TLT$returns, 
                        XLE = XLE$returns, XLF = XLF$returns, VSMCX = VSMCX$returns,
                        XLI = XLI$returns, XLV = XLV$returns, XLP = XLP$returns, IVV = IVV$returns, Market = mkt$Return)
xts_combined_data$Date <- ymd(xts_combined_data$Date)
xts_combined_data <- xts_combined_data[order(xts_combined_data$Date),]
xts_combined_data <- xts(xts_combined_data[,-1], order.by = xts_combined_data[,1], )

chart.CumReturns(xts_combined_data, wealth.index = FALSE, geometric = TRUE, legend.loc = 'topleft')


QQQ_cumulative_ret <- Return.cumulative(QQQ$returns, geometric =  TRUE) * 100
IVV_cumulative_ret <- Return.cumulative(IVV$returns, geometric =  TRUE) * 100
TLT_cumulative_ret <- Return.cumulative(TLT$returns, geometric =  TRUE) * 100
VSMCX_cumulative_ret <- Return.cumulative(VSMCX$returns, geometric =  TRUE) * 100
XLF_cumulative_ret <- Return.cumulative(XLF$returns, geometric =  TRUE) * 100
XLI_cumulative_ret <- Return.cumulative(XLI$returns, geometric =  TRUE) * 100
XLP_cumulative_ret <- Return.cumulative(XLP$returns, geometric =  TRUE) * 100
XLV_cumulative_ret <- Return.cumulative(XLV$returns, geometric =  TRUE) * 100
XLE_cumulative_ret <- Return.cumulative(XLE$returns, geometric =  TRUE) * 100
mkt_cumulative_ret <- Return.cumulative(mkt$Return, geometric =  TRUE) * 100

QQQ_cumulative_ret <- sprintf('%.2f%%', QQQ_cumulative_ret)
IVV_cumulative_ret <- sprintf('%.2f%%', IVV_cumulative_ret)
TLT_cumulative_ret <- sprintf('%.2f%%', TLT_cumulative_ret)
VSMCX_cumulative_ret <- sprintf('%.2f%%', VSMCX_cumulative_ret)
XLF_cumulative_ret <- sprintf('%.2f%%', XLF_cumulative_ret)
XLI_cumulative_ret <- sprintf('%.2f%%', XLI_cumulative_ret)
XLP_cumulative_ret <- sprintf('%.2f%%', XLP_cumulative_ret)
XLV_cumulative_ret <- sprintf('%.2f%%', XLV_cumulative_ret)
XLE_cumulative_ret <- sprintf('%.2f%%', XLE_cumulative_ret)
mkt_cumulative_ret <- sprintf('%.2f%%', mkt_cumulative_ret)

QQQ_model_adj_rsq <- sprintf('%.2f', summary(QQQ_model)$adj.r.squared)
IVV_model_adj_rsq <- sprintf('%.2f', summary(IVV_model)$adj.r.squared)
TLT_model_adj_rsq <- sprintf('%.2f', summary(TLT_model)$adj.r.squared)
VSMCX_model_adj_rsq <- sprintf('%.2f', summary(VSMCX_model)$adj.r.squared)
XLF_model_adj_rsq <- sprintf('%.2f', summary(XLF_model)$adj.r.squared)
XLI_model_adj_rsq <- sprintf('%.2f', summary(XLI_model)$adj.r.squared)
XLP_model_adj_rsq <- sprintf('%.2f', summary(XLP_model)$adj.r.squared)
XLV_model_adj_rsq <- sprintf('%.2f', summary(XLV_model)$adj.r.squared)
XLE_model_adj_rsq <- sprintf('%.2f', summary(XLE_model)$adj.r.squared)

QQQ_SR
QQQ_SR <- sprintf('%.2f', QQQ_SR[1])
IVV_SR <- sprintf('%.2f', IVV_SR[1])
TLT_SR <- sprintf('%.2f', TLT_SR[1])
VSMCX_SR <- sprintf('%.2f', VSMCX_SR[1])
XLF_SR <- sprintf('%.2f', XLF_SR[1])
XLI_SR <- sprintf('%.2f', XLI_SR[1])
XLP_SR <- sprintf('%.2f', XLP_SR[1])
XLV_SR <- sprintf('%.2f', XLV_SR[1])
XLE_SR <- sprintf('%.2f', XLE_SR[1])
mkt_SR <- sprintf('%.2f', mkt_SR)

QQQ_TR <- sprintf('%.2f', QQQ_TR)
IVV_TR <- sprintf('%.2f', IVV_TR)
TLT_TR <- sprintf('%.2f', TLT_TR)
VSMCX_TR <- sprintf('%.2f', VSMCX_TR)
XLF_TR <- sprintf('%.2f', XLF_TR)
XLI_TR <- sprintf('%.2f', XLI_TR)
XLP_TR <- sprintf('%.2f', XLP_TR)
XLV_TR <- sprintf('%.2f', XLV_TR)
XLE_TR <- sprintf('%.2f', XLE_TR)
mkt_TR <- sprintf('%.2f', mkt_TR)

QQQ_Beta <- sprintf('%.2f', coefficients(QQQ_model)[2])
IVV_Beta <- sprintf('%.2f', coefficients(IVV_model)[2])
TLT_Beta <- sprintf('%.2f', coefficients(TLT_model)[2])
VSMCX_Beta <- sprintf('%.2f', coefficients(VSMCX_model)[2])
XLF_Beta <- sprintf('%.2f', coefficients(XLF_model)[2])
XLI_Beta <- sprintf('%.2f', coefficients(XLI_model)[2])
XLP_Beta <- sprintf('%.2f', coefficients(XLP_model)[2])
XLV_Beta <- sprintf('%.2f', coefficients(XLV_model)[2])
XLE_Beta <- sprintf('%.2f', coefficients(XLE_model)[2])






output_table <- data.frame(TLT = c(TLT_Beta, TLT_model_adj_rsq, TLT_SR,TLT_TR,TLT_cumulative_ret),
                            QQQ = c(QQQ_Beta, QQQ_model_adj_rsq, QQQ_SR[1],QQQ_TR,QQQ_cumulative_ret),
                            XLF = c(XLF_Beta, XLF_model_adj_rsq, XLF_SR[1],XLF_TR,XLF_cumulative_ret),
                            VSMCX = c(VSMCX_Beta, VSMCX_model_adj_rsq, VSMCX_SR[1],VSMCX_TR,VSMCX_cumulative_ret),
                            IVV = c(IVV_Beta, IVV_model_adj_rsq, IVV_SR[1],IVV_TR,IVV_cumulative_ret),
                            XLV = c(XLV_Beta, XLV_model_adj_rsq, XLV_SR[1],XLV_TR,XLV_cumulative_ret),
                            XLI = c(XLI_Beta, XLI_model_adj_rsq, XLI_SR[1],XLI_TR,XLI_cumulative_ret),
                            XLE = c(XLE_Beta, XLE_model_adj_rsq, XLE_SR[1],XLE_TR,XLE_cumulative_ret),
                            XLP = c(XLP_Beta, XLP_model_adj_rsq, XLP_SR[1],XLP_TR,XLP_cumulative_ret),
                            Market = c(1,1,mkt_SR[1],mkt_TR, mkt_cumulative_ret))

row.names(output_table) <- c('Beta', 'Adj. R-Squared', 'Sharpe Ratio', 'Treynor Ratio', 'Cumulative Returns')

output_table

# IVV <- read.csv('Data/Raw Data/IVV_monthly.csv')
library(dplyr)
library(data.table)

IVV <- read.csv('Data/Raw Data/IVV_monthly.csv')
QQQ <- read.csv('Data/Raw Data/QQQ_monthly.csv')
TLT <- read.csv('Data/Raw Data/TLT_monthly.csv')
VSMCX <- read.csv('Data/Raw Data/VSMCX_monthly.csv')
XLE <- read.csv('Data/Raw Data/XLE_monthly.csv')
XLF <- read.csv('Data/Raw Data/XLF_monthly.csv')
XLI <- read.csv('Data/Raw Data/XLI_monthly.csv')
XLP <- read.csv('Data/Raw Data/XLP_monthly.csv')
XLV <- read.csv('Data/Raw Data/XLV_monthly.csv')


IVV_mod <- IVV
IVV_mod$Date <- ymd(IVV_mod$Date)
IVV_mod <- IVV_mod[order(IVV_mod$Date),]  # nolint
IVV_mod$shifted_close = shift(IVV_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
IVV_mod <- IVV_mod %>% na.omit()
IVV_mod <- IVV_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(IVV_mod, 'Data/Data for use/IVV.csv')



QQQ_mod <- QQQ
QQQ_mod$Date <- ymd(QQQ_mod$Date)
QQQ_mod <- QQQ_mod[order(QQQ_mod$Date),]  # nolint
QQQ_mod$shifted_close = shift(QQQ_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
QQQ_mod <- QQQ_mod %>% na.omit()
QQQ_mod <- QQQ_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(QQQ_mod, 'Data/Data for use/QQQ.csv')

TLT_mod <- TLT
TLT_mod$Date <- ymd(TLT_mod$Date)
TLT_mod <- TLT_mod[order(TLT_mod$Date),]  # nolint
TLT_mod$shifted_close = shift(TLT_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
TLT_mod <- TLT_mod %>% na.omit()
TLT_mod <- TLT_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(TLT_mod, 'Data/Data for use/TLT.csv')

VSMCX_mod <- VSMCX
VSMCX_mod$Date <- ymd(VSMCX_mod$Date)
VSMCX_mod <- VSMCX_mod[order(VSMCX_mod$Date),]  # nolint
VSMCX_mod$shifted_close = shift(VSMCX_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
VSMCX_mod <- VSMCX_mod %>% na.omit()
VSMCX_mod <- VSMCX_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(VSMCX_mod, 'Data/Data for use/VSMCX.csv')

XLE_mod <- XLE
XLE_mod$Date <- ymd(XLE_mod$Date)
XLE_mod <- XLE_mod[order(XLE_mod$Date),]  # nolint
XLE_mod$shifted_close = shift(XLE_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
XLE_mod <- XLE_mod %>% na.omit()
XLE_mod <- XLE_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(XLE_mod, 'Data/Data for use/XLE.csv')

XLF_mod <- XLF
XLF_mod$Date <- ymd(XLF_mod$Date)
XLF_mod <- XLF_mod[order(XLF_mod$Date),]  # nolint
XLF_mod$shifted_close = shift(XLF_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
XLF_mod <- XLF_mod %>% na.omit()
XLF_mod <- XLF_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(XLF_mod, 'Data/Data for use/XLF.csv')

XLI_mod <- XLI
XLI_mod$Date <- ymd(XLI_mod$Date)
XLI_mod <- XLI_mod[order(XLI_mod$Date),]  # nolint
XLI_mod$shifted_close = shift(XLI_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
XLI_mod <- XLI_mod %>% na.omit()
XLI_mod <- XLI_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(XLI_mod, 'Data/Data for use/XLI.csv')

XLP_mod <- XLP
XLP_mod$Date <- ymd(XLP_mod$Date)
XLP_mod <- XLP_mod[order(XLP_mod$Date),]  # nolint
XLP_mod$shifted_close = shift(XLP_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
XLP_mod <- XLP_mod %>% na.omit()
XLP_mod <- XLP_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(XLP_mod, 'Data/Data for use/XLP.csv')

XLV_mod <- XLV
XLV_mod$Date <- ymd(XLV_mod$Date)
XLV_mod <- XLV_mod[order(XLV_mod$Date),]  # nolint
XLV_mod$shifted_close = shift(XLV_mod$Adj.Close, n=1L, fill = NA, type = c('lag'), give.names = FALSE) # nolint
XLV_mod <- XLV_mod %>% na.omit()
XLV_mod <- XLV_mod %>% mutate(returns = (Adj.Close / shifted_close) - 1)

write.csv(XLV_mod, 'Data/Data for use/XLV.csv')

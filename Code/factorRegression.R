# get stargazer library
install.packages("stargazer")
library(stargazer)

# load factor returns and individual security returns data
FF = read.csv("factor_monthly_returns_2004_2024.csv", header = TRUE)
TLT = read.csv("TLT.csv", header = TRUE)
QQQ = read.csv("QQQ.csv", header = TRUE)
XLF = read.csv("XLF.csv", header = TRUE)
XLE = read.csv("XLE.csv", header = TRUE)
VSMCX = read.csv("VSMCX.csv", header = TRUE)
XLP = read.csv("XLP.csv", header = TRUE)
IVV = read.csv("IVV.csv", header = TRUE)
XLI = read.csv("XLI.csv", header = TRUE)
XLV = read.csv("XLV.csv", header = TRUE)

# adjust the unit, convert to "ratio"
FF$MKT = FF$MktRF / 100
FF$SMB = FF$SMB / 100
FF$HML = FF$HML / 100
FF$RMW = FF$RMW / 100
FF$CMA = FF$CMA / 100
FF$RF = FF$RF / 100

# subtract riskfree rate of return
FF$TLT = TLT$returns - FF$RF
FF$QQQ = QQQ$returns - FF$RF
FF$XLF = XLF$returns - FF$RF
FF$XLI = XLI$returns - FF$RF
FF$XLE = XLE$returns - FF$RF
FF$XLP = XLP$returns - FF$RF
FF$IVV = IVV$returns - FF$RF
FF$XLV = XLV$returns - FF$RF
FF$VSMCX = VSMCX$returns - FF$RF

# conduct factor regressions on individual assets
mdlTLT = lm(TLT ~ MKT + SMB + HML + RMW + CMA ,data = FF)
mdlQQQ = lm(QQQ ~ MKT + SMB + HML + RMW + CMA ,data = FF)
mdlXLF = lm(XLF ~ MKT + SMB + HML + RMW + CMA ,data = FF)
mdlXLP = lm(XLP ~ MKT + SMB + HML + RMW + CMA ,data = FF)
mdlXLV = lm(XLV ~ MKT + SMB + HML + RMW + CMA ,data = FF)
mdlXLI = lm(XLI ~ MKT + SMB + HML + RMW + CMA ,data = FF)
mdlIVV = lm(IVV ~ MKT + SMB + HML + RMW + CMA ,data = FF)
mdlXLE = lm(XLE ~ MKT + SMB + HML + RMW + CMA ,data = FF)
mdlVSMCX = lm(VSMCX ~ MKT + SMB + HML + RMW + CMA ,data = FF)

# print summaries
summary(mdlTLT)
summary(mdlQQQ)
summary(mdlXLF)
summary(mdlXLP)
summary(mdlXLE)
summary(mdlIVV)
summary(mdlXLV)
summary(mdlXLI)
summary(mdlVSMCX)

# renaming to shorter variable names to get around the known bug in stargazer software
# https://stackoverflow.com/questions/76452883/stargazer-throws-error-when-more-than-five-models-used
m1 = mdlTLT
m2 = mdlQQQ
m3 = mdlXLF
m4 = mdlVSMCX
m5 = mdlIVV
m6 = mdlXLV
m7 = mdlXLI
m8 = mdlXLE
m9 = mdlXLP

# summaries everything into one table
stargazer(m1,m2,m3,m4,m5,m6,m7,m8,m9,align=TRUE,type="html",out="/Users/kenics/Desktop/gatech/dab/FF5/FactorRegressionResult.html")


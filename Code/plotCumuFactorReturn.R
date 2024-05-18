
# plot cumulative factor returns
CU = read.csv("cumuFactorRet.csv", header=TRUE)
plot(CU$date, CU$cumMktPct, type = "line", col=1, ylim=c(-50,500), xlab = "Month", ylab = "Return (%)")
lines(CU$date, CU$cumSMBPct, type="line", col = 2)
lines(CU$date, CU$cumHMLPct, type="line", col = 3)
lines(CU$date, CU$cumRMWPct, type="line", col = 4)
lines(CU$date, CU$cumCMAPct, type="line", col = 5)
grid(nx = NULL, lty="dashed")
title("Cumulative Factor Returns")
legend(2005,400,legend=c("Market", "Size", "Value","Profitability","Investment"),  fill = c("1","2","3","4","5") )

library(dplyr)
library(psych)
library(Hmisc)
library(car)
library("Hmisc")
library("corrplot")
library("sjPlot")


#load Data
raw_data<-read.csv("analytic_data2023_0.csv")

#Narrow down the 720 columns to the ones we are interested in doing regression on
Life_Expectancy_Table<-raw_data[,c("Life.Expectancy.raw.value","Name","State.Abbreviation","Poor.Mental.Health.Days.raw.value","Adult.Smoking.raw.value","Flu.Vaccinations.raw.value","Air.Pollution...Particulate.Matter.raw.value","Long.Commute...Driving.Alone.raw.value","Median.Household.Income.raw.value")]

#Change blanks to NAs
Life_Expectancy_Table<-Life_Expectancy_Table%>% mutate_all(na_if,"")

#Remove rows in the data that don't have life expectancy data
Life_Expectancy_Table_Clean<-subset(Life_Expectancy_Table,!is.na(Life.Expectancy.raw.value))

#Drop this row since it's not real data
Life_Expectancy_Table_Clean<-Life_Expectancy_Table_Clean[-c(1:1),]

#Change columns to numeric
Life_Expectancy_Table_Clean<-Life_Expectancy_Table_Clean %>% mutate_at(c("Life.Expectancy.raw.value","Poor.Mental.Health.Days.raw.value","Adult.Smoking.raw.value","Flu.Vaccinations.raw.value","Air.Pollution...Particulate.Matter.raw.value","Long.Commute...Driving.Alone.raw.value","Median.Household.Income.raw.value"),as.numeric)





str(Life_Expectancy_Table_Clean)

describe(Life_Expectancy_Table_Clean)
hist(Life_Expectancy_Table_Clean$Life.Expectancy.raw.value,main="Before Trimming",xlab="Life Expectancy")
Life_Expectancy_Table_Clean<-Life_Expectancy_Table_Clean[Life_Expectancy_Table_Clean$Life.Expectancy.raw.value <90,]
Life_Expectancy_Table_Clean<-Life_Expectancy_Table_Clean[Life_Expectancy_Table_Clean$Life.Expectancy.raw.value >67,]


colnames(Life_Expectancy_Table_Clean)<-(c("Life_Expectancy","Name","State","Mental_Health_Days","Adult_Smoking","Flu_Vaccination","Air_Pollution","Long_Commute","Median_Income"))
reg_1<-lm(Life_Expectancy~.-Name-State,data=Life_Expectancy_Table_Clean)
summary(reg_1)

residuals_model <-resid(reg_1)

plot(fitted(reg_1),residuals_model)

qqnorm(residuals_model)

plot(density(residuals_model))

CooksD<-cooks.distance(reg_1)
plot(CooksD,main="Cooks Distance")
print(round(as.numeric(CooksD[(CooksD>1)]),1))
write.csv(Life_Expectancy_Table_Clean,"Life_Expectancy_Clean.csv")
vif_values<-vif(reg_1)

drops<-c("Name","State","Life_Expectancy")
Life_Expectancy_Table_Clean_2<-Life_Expectancy_Table_Clean[,!(names(Life_Expectancy_Table_Clean)%in% drops)]
colnames(Life_Expectancy_Table_Clean_2)<-(c("Mental_Health_Days","Adult_Smoking","Flu_Vaccination","Air_Pollution","Long_Commute","Median_Income"))

str(Life_Expectancy_Table_Clean_2)

M<-cor(Life_Expectancy_Table_Clean_2, use="complete.obs")
print(M)
corrplot(M,method="number")
hist(Life_Expectancy_Table_Clean$Life_Expectancy, main="Life Expectancy Distribution",xlab="Life Expectancy")
par(mar=c(10,8,4.1,2.1))
barplot(vif_values, main = "VIF Values", horiz = FALSE, col = "steelblue",las=3)
tab_model(reg_1)
Name<-c("Alabama","Alabama","Alabama")
State<-c("AL","AL","AL")
Mental_Health_Days<-c(4,5,6)
Adult_Smoking<-c(.3,.2,0)
Flu_Vaccination<-c(0,.8,.5)
Air_Pollution<-c(7,8,6)
Long_Commute<-c(.2,.3,.1)
Median_Income<-c(50000,100000,150000)
Lifers<-data.frame(Name,State,Mental_Health_Days,Adult_Smoking,Flu_Vaccination,Air_Pollution,Long_Commute,Median_Income)
Life_Expectancy<-round(predict(reg_1,newdata = Lifers),0)
Lifers$Life_Expectancy<-Life_Expectancy

print(Lifers)

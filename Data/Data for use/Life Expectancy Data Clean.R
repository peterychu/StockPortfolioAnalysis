library(dplyr)
library(psych)
library(Hmisc)
#load Data
raw_data<-read.csv("analytic_data2023_0.csv")

#Narrow down the 720 columns to the ones we are interested in doing regression on
Life_Expectancy_Table<-raw_data[,c("Life.Expectancy.raw.value","Name","State.Abbreviation","Poor.Mental.Health.Days.raw.value","Adult.Smoking.raw.value","Flu.Vaccinations.raw.value","Air.Pollution...Particulate.Matter.raw.value","Long.Commute...Driving.Alone.raw.value","Median.Household.Income.raw.value")]

#Change columns to numeric
Life_Expectancy_Table<-Life_Expectancy_Table %>% mutate_at(c("Life.Expectancy.raw.value","Poor.Mental.Health.Days.raw.value","Adult.Smoking.raw.value","Flu.Vaccinations.raw.value","Air.Pollution...Particulate.Matter.raw.value","Long.Commute...Driving.Alone.raw.value","Median.Household.Income.raw.value"),as.numeric)

#Drop this row since it's not real data
Life_Expectancy_Table<-Life_Expectancy_Table[-c(1:1),]

#Change blanks to NAs
Life_Expectancy_Table<-Life_Expectancy_Table%>% mutate_all(na_if,"")

#Remove rows in the data that don't have life expectancy data
Life_Expectancy_Table_Clean<-subset(Life_Expectancy_Table,!is.na(Life.Expectancy.raw.value))



str(Life_Expectancy_Table_Clean)

describe(Life_Expectancy_Table_Clean)

#reg_1<-lm(Life_Expectancy_Table_Clean$Life.Expectancy.raw.value~Life_Expectancy_Table_Clean$Air.Pollution...Particulate.Matter.raw.value,data=Life_Expectancy_Table_Clean)
#summary(reg_1)

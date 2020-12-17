#install.packages('covid19.analytics')
#install.packages('dplyr')
#install.packages("prophet", type="source")
#install.packages('lubricate')
#install.packages("gifski")
#install.packages("av")
#install.packages("dyOptions")

library(dygraphs)
library(prophet)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(gganimate)
library(gifski)
library(av)




#############################
############################
####### Analysis
###########################
############################

##Choose global_covid_data_cleaned.csv
#global_covid_data <- read.csv(file.choose(), header = T)

global_covid_data <- read.csv("/Users/satishkumarpola/Documents/DS/project_data/DS785-Project/data_clean/global_covid_data_cleaned.csv", header=T)
attach(global_covid_data)
head(global_covid_data)

covid_us <- global_covid_data[global_covid_data$country=='US',]

## Format the data to make sure that the date is in date format 
## and other fields are in number data type.  
covid_us$report_date <- ymd(covid_us$report_date)
covid_us$confirmed <- as.numeric(covid_us$confirmed)
covid_us$recovered <- as.numeric(covid_us$recovered)
covid_us$deaths <- as.numeric(covid_us$deaths)

##Check the datatypes 
str(covid_us)

### Enables 
options(scipen=10000000)

#CVerify the data. 
qplot(report_date,confirmed, data = covid_us, main = 'COVID-19 US Confirm Cases')


############################
##Analyze confirmed data
############################
ds <- covid_us$report_date
y <- covid_us$confirmed
confirmed_df <- data.frame(ds,y)
confirmed_df

#m <- prophet(confirmed_df, interval.width = 0.70)
m <- prophet(confirmed_df)
summary(m)

## Predict the confirmed covid number for the next 60days. 
future <- make_future_dataframe(m, periods = 60)

###Predict numbers
forecast <- predict(m, future)
summary(forecast)
plot(m,forecast)
options(scipen=0)
dyplot.prophet(m,forecast) %>% dyOptions(maxNumberWidth = 20)


### Gives two plots 
options(scipen=100000)
prophet_plot_components(m,forecast)

#model performance 
pred <- forecast$yhat[1:326]
actual <- m$history$y
plot(actual, pred, main="Confirmed Actial vs Predicted", family="Times", font.main= 1)
abline(lm(pred~actual), col='blue')
summary(lm(pred~actual))

df.cv <- cross_validation(m, initial=250, period = 7, horizon = 60, units = 'days')
head(df.cv)
df.p <- performance_metrics(df.cv)
head(df.p)
plot_cross_validation_metric(df.cv, metric = 'mape')
tail(df.p)




###################
#####Recovered
####################
ds <- covid_us$report_date
y <- covid_us$recovered
recovered_df <- data.frame(ds,y)
recovered_df
m <- prophet(recovered_df)
summary(m)
future <- make_future_dataframe(m, periods = 60)
future
forecast <- predict(m, future)
forecast
plot(m,forecast)
options(scipen=10000000)
dyplot.prophet(m,forecast) %>% dyOptions(maxNumberWidth = 20)


### Gives two plots 
prophet_plot_components(m,forecast)

#model performance 
pred <- forecast$yhat[1:326]
actual <- m$history$y
plot(actual, pred, main="Recovered, Actial vs Predicted", family="Times", font.main= 1)
abline(lm(pred~actual), col='blue')
summary(lm(pred~actual))

df.cv <- cross_validation(m, initial=250, period = 7, horizon = 60, units = 'days')
head(df.cv)
options(dplyr.print_max = 1e9)
df.p <- performance_metrics(df.cv)
head(df.p)
max(df.p$mape)
min(df.p$mape)
plot_cross_validation_metric(df.cv, metric = 'mape')





#################
#####Deaths
#################
ds <- covid_us$report_date
y <- covid_us$deaths
deaths_df <- data.frame(ds,y)
deaths_df
m <- prophet(deaths_df)
summary(m)
future <- make_future_dataframe(m, periods = 60)
future
forecast <- predict(m, future)
forecast
plot(m,forecast)
dyplot.prophet(m,forecast) %>% dyOptions(maxNumberWidth = 20)

### Gives two plots 
prophet_plot_components(m,forecast)


#model performance 
pred <- forecast$yhat[1:326]
actual <- m$history$y
plot(actual, pred, main="Deaths Actial vs Predicted", family="Times", font.main= 1)
abline(lm(pred~actual), col='blue')
summary(lm(pred~actual))

df.cv <- cross_validation(m, initial=250, period = 7, horizon = 60, units = 'days')
head(df.cv)
df.p <- performance_metrics(df.cv)
head(df.p)
min(df.p$mape)
max(df.p$mape)
plot_cross_validation_metric(df.cv, metric = 'mape')







#################################
##          Employment         ##
#################################
##Load unemployment_cleaned.csv##
#################################

##
## Initial Claims
## 

unemployment_data <- read.csv("/Users/satishkumarpola/Documents/DS/project_data/DS785-Project/data_clean/unemployment_cleaned.csv", header=T)
#unemployment_data <- read.csv(file.choose(), header = T)
head(unemployment_data)
summary(unemployment_data)
str(unemployment_data)
unemployment_data$Report_Week <- ymd(unemployment_data$Report_Week)
unemployment_data$INITIAL_S_F <- as.numeric(unemployment_data$INITIAL_S_F)
unemployment_data$Continued_Claims_S_F <- as.numeric(unemployment_data$Continued_Claims_S_F)
str(unemployment_data)

ds <- ymd(unemployment_data$Report_Week)
y <- unemployment_data$INITIAL_S_F

unemployment_data_ini <- data.frame(ds,y)
m <- prophet(unemployment_data_ini)
summary(m)
future <- make_future_dataframe(m, periods = 12, freq = "week")
forecast <- predict(m, future)
summary(forecast)


plot(m,forecast)
dyplot.prophet(m,forecast) %>% dyOptions(maxNumberWidth = 20)


prophet_plot_components(m,forecast)
performance_metrics(m)

#model performance 
pred <- forecast$yhat[1:567]
actual <- m$history$y
plot(actual, pred)
abline(lm(pred~actual), col='blue')
summary(lm(pred~actual))

df.cv <- cross_validation(m, initial=350, period = 52, horizon = 12, units = 'weeks')
head(df.cv)
df.p <- performance_metrics(df.cv)
head(df.p)
plot_cross_validation_metric(df.cv, metric = 'mape')


##
## Continued Claims
## 
ds <- ymd(unemployment_data$Report_Week)
y <- unemployment_data$Continued_Claims_S_F

unemployment_data_ini <- data.frame(ds,y)
m <- prophet(unemployment_data_ini)
summary(m)
future <- make_future_dataframe(m, periods = 12, freq = "week")
forecast <- predict(m, future)
summary(forecast)


plot(m,forecast)
dyplot.prophet(m,forecast) %>% dyOptions(maxNumberWidth = 20)


prophet_plot_components(m,forecast)
performance_metrics(m)

#model performance 
pred <- forecast$yhat[1:567]
actual <- m$history$y
plot(actual, pred)
abline(lm(pred~actual), col='blue')
summary(lm(pred~actual))

df.cv <- cross_validation(m, initial=350, period = 52, horizon = 12, units = 'weeks')
head(df.cv)
df.p <- performance_metrics(df.cv)
head(df.p)
plot_cross_validation_metric(df.cv, metric = 'mape')


##
## Unemployment Rate
## 
unemployment_rate <- read.csv("/Users/satishkumarpola/Documents/DS/project_data/DS785-Project/data_clean/unemployment_rate.csv", header=T)
unemployment_rate$DATE <- ymd(unemployment_rate$DATE)
str(unemployment_rate)
ds <- ymd(unemployment_rate$DATE)
y <- unemployment_rate$UNRATE


unemployment_data_rate <- data.frame(ds,y)
summary(unemployment_data_rate)
unemployment_data_rate
m <- prophet(unemployment_data_rate)
summary(m)
future <- make_future_dataframe(m, periods = 12, freq = "week")
forecast <- predict(m, future)
summary(forecast)


plot(m,forecast)
dyplot.prophet(m,forecast) %>% dyOptions(maxNumberWidth = 20)

prophet_plot_components(m,forecast)
performance_metrics(m)


#model performance 
pred <- forecast$yhat[1:121]
actual <- m$history$y
plot(actual, pred)
abline(lm(pred~actual), col='blue')
summary(lm(pred~actual))

df.cv <- cross_validation(m, initial=80, period = 12, horizon = 12, units = 'weeks')
head(df.cv)
df.p <- performance_metrics(df.cv)
head(df.p)
plot_cross_validation_metric(df.cv, metric = 'mape')

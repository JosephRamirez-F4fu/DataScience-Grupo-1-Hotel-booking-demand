#--instalando librerias

install.packages("DescTools",dependencies = TRUE)
install.packages("ggplot2",dependencies = TRUE)
install.packages("agricolae",dependencies = TRUE)
install.packages("mlr",dependencies = TRUE)

library(mlr)
library(agricolae)
library(ggplot2)
library(DescTools)

#--cargando datos

setwd("C:/Users/USUARIO/Desktop/DataScience-Grupo-1-Hotel-booking-demand")
df<-read.table('hotel_bookings.csv',header=TRUE,sep=",",dec='.')
head(df)


#--tipificando los datos
df$hotel=as.factor(df$hotel)
df$is_canceled=as.logical(df$is_canceled)
df$lead_time=as.numeric(df$lead_time)
df$arrival_date_week_number=as.integer(df$arrival_date_week_number)
df$arrival_date_year=as.numeric(df$arrival_date_year)
df$arrival_date_month=as.factor(df$arrival_date_month)
df$arrival_date_day_of_month=as.numeric(df$arrival_date_day_of_month)
df$stays_in_weekend_nights=as.integer(df$adults)
df$stays_in_week_nights=as.integer(df$stays_in_week_nights)
df$adults=as.integer(df$adults)
df$children=as.integer(df$children)
df$babies=as.integer(df$babies)
df$meal=as.factor(df$meal)
df$country=as.factor(df$country)
df$market_segment=as.factor(df$market_segment)
df$distribution_channel=as.factor(df$distribution_channel)
df$previous_cancellations=as.integer(df$previous_cancellations)
df$previous_bookings_not_canceled=as.integer(df$previous_bookings_not_canceled)
df$reserved_room_type=as.factor(df$reserved_room_type)
df$assigned_room_type=as.factor(df$assigned_room_type)
df$booking_changes=as.integer(df$booking_changes)
df$deposit_type=as.factor(df$deposit_type)
df$agent=as.factor(df$agent)
df$company=as.factor(df$company)
df$days_in_waiting_list=as.integer(df$days_in_waiting_list)
df$customer_type=as.factor(df$customer_type)
df$adr=is.numeric(df$adr)
df$required_car_parking_spaces=as.numeric(df$required_car_parking_spaces)
df$total_of_special_requests=as.numeric(df$total_of_special_requests)
df$reservation_status=as.factor(df$reservation_status)
df$reservation_status_date=as.Date(df$reservation_status_date)


summary(df)

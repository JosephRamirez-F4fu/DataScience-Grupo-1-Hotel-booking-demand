#--instalando librerias

install.packages("DescTools",dependencies = TRUE)
install.packages("ggplot2",dependencies = TRUE)
install.packages("agricolae",dependencies = TRUE)
install.packages("mlr",dependencies = TRUE)

library(mlr)
library(agricolae)
library(ggplot2)
library(DescTools)
library(lubridate)
#--cargando datos

setwd("C:/Users/USUARIO/Desktop/DataScience-Grupo-1-Hotel-booking-demand")
hbd<-read.csv('hotel_bookings.csv',header=TRUE,sep=",")
View(df)

head(df)


#--tipificando los datos
df$hotel=as.factor(df$hotel)
df$is_canceled=as.logical(df$is_canceled)
df$lead_time=as.numeric(df$lead_time)
df$arrival_date_week_number=as.integer(df$arrival_date_week_number)
df$arrival_date_year=as.factor(df$arrival_date_year)
df$arrival_date_month=as.factor(df$arrival_date_month)
df$arrival_date_day_of_month=as.numeric(df$arrival_date_day_of_month)
df$stays_in_weekend_nights=as.factor(df$adults)
df$stays_in_week_nights=as.factor(df$stays_in_week_nights)
df$adults=as.factor(df$adults)
df$children=as.factor(df$children)
df$babies=as.factor(df$babies)
df$meal=as.factor(df$meal)
df$country=as.factor(df$country)
df$market_segment=as.factor(df$market_segment)
df$distribution_channel=as.factor(df$distribution_channel)
df$is_repeated_guest=as.factor(df$is_repeated_guest)
df$previous_cancellations=as.factor(df$previous_cancellations)
df$previous_bookings_not_canceled=as.factor(df$previous_bookings_not_canceled)
df$reserved_room_type=as.factor(df$reserved_room_type)
df$assigned_room_type=as.factor(df$assigned_room_type)
df$booking_changes=as.factor(df$booking_changes)
df$deposit_type=as.factor(df$deposit_type)
df$agent=as.factor(df$agent)
df$company=as.factor(df$company)
df$days_in_waiting_list=as.integer(df$days_in_waiting_list)
df$customer_type=as.factor(df$customer_type)
df$adr=is.numeric(df$adr)
df$required_car_parking_spaces=as.factor(df$required_car_parking_spaces)
df$total_of_special_requests=as.factor(df$total_of_special_requests)
df$reservation_status_date=as.Date(df$reservation_status_date)

View(df)
s<-table(df$market_segment)
s<-table(df$company)
s
summary(df)

names(df)
str(df)

#Eliminando columnas redundantes

df$arrival_date_year<-NULL
df$arrival_date_month<-NULL
df$arrival_date_day_of_month<-NULL

df_original<-df

summary(df)
s<-table(df$country)
View(df$country)

df_resort<-df[df$hotel=="Resort Hotel",]
df_resort$hotel<-NULL
View(df_resort)
summary(df_resort)

df_city<-df[df$hotel=="City Hotel",]
df_city$hotel<-NULL
View(df_city)
summary(df_city)


frecuenciasR<-table(df_resort$is_canceled)
frecuenciasC<-table(df_city$is_canceled)


barplot(frecuencias,main="Cancelacion en el Hotel Resort",names=c("No cancelado","Cancelado"))


porcentajes<-round(frecuencias/sum(frecuencias)*100,1)


barplot(frecuenciasC,main="Cancelacion en el City Hotel",names=c("No cancelado","Cancelado"),col=c("lightblue","mistyrose"))
frecuenciasC
porcentajes<-round(frecuenciasC/sum(frecuenciasC)*100,1)
porcentajes


#Meses de mayor afluencia por hotel en grafico de lineas
df<-df[df$is_canceled==FALSE,]
count<-table(df$hotel,month(df&reservation_status_date))
count

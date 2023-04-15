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


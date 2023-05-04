#===============================================================================

#Limpieza del entorno 
rm(list=ls(all=TRUE));
graphics.off();

#Librerias
library(mlr);
#library(agricolae);
library(ggplot2);
library(DescTools);
library(dplyr);
library(countrycode)

cat("\014");

#===============================================================================

#Carga de datos
setwd("C:/Users/cesar");
hbd <- read.table('hotel_bookings.csv', header=TRUE, sep=',',dec='.');

#Tipo Original para datos
hbd$hotel                           <-as.factor(hbd$hotel);
hbd$is_canceled                     <-as.logical(hbd$is_canceled);
hbd$lead_time                       <-as.integer(hbd$lead_time);
hbd$arrival_date_week_number        <-as.integer(hbd$arrival_date_week_number);
hbd$stays_in_weekend_nights         <-as.integer(hbd$stays_in_weekend_nights);
hbd$stays_in_week_nights            <-as.integer(hbd$stays_in_week_nights);
hbd$adults                          <-as.integer(hbd$adults);
hbd$children                        <-as.integer(hbd$children);
hbd$babies                          <-as.integer(hbd$babies);
hbd$meal                            <-as.factor(hbd$meal);
hbd$country                         <-as.factor(hbd$country);
hbd$market_segment                  <-as.factor(hbd$market_segment);
hbd$distribution_channel            <-as.factor(hbd$distribution_channel);
hbd$is_repeated_guest               <-as.factor(hbd$is_repeated_guest);
hbd$previous_cancellations          <-as.integer(hbd$previous_cancellations);
hbd$previous_bookings_not_canceled  <-as.integer(hbd$previous_bookings_not_canceled);
hbd$reserved_room_type              <-as.factor(hbd$reserved_room_type);
hbd$assigned_room_type              <-as.factor(hbd$assigned_room_type);
hbd$booking_changes                 <-as.integer(hbd$booking_changes);
hbd$deposit_type                    <-as.factor(hbd$deposit_type);
hbd$days_in_waiting_list            <-as.integer(hbd$days_in_waiting_list);
hbd$customer_type                   <-as.factor(hbd$customer_type);
hbd$adr                             <-as.numeric(hbd$adr);
hbd$required_car_parking_spaces     <-as.integer(hbd$required_car_parking_spaces);
hbd$total_of_special_requests       <-as.integer(hbd$total_of_special_requests);
hbd$reservation_status              <-as.factor(hbd$reservation_status);
hbd$reservation_status_date         <-as.Date(hbd$reservation_status_date);

##arrival_date
Sys.setlocale("LC_TIME", "English");
hbd$reserved_arrival_date <- as.Date(with(hbd, paste(formatC(arrival_date_day_of_month, flag=0,width=2), arrival_date_month, arrival_date_year, sep="-")), "%d-%B-%Y");


##arrival_cicle
date.as.trimestre <- function(x) {
    month = as.integer(format(x, "%m"));
    value <- ifelse(month > 9, 4,
                    ifelse(month > 6, 3,
                           ifelse(month > 3, 2,
                                  ifelse(month > 0, 1, 0))));
    return (value);
};
hbd$arrival_cicle <- as.factor(with(hbd, paste(format(reserved_arrival_date, "%Y"), date.as.trimestre(reserved_arrival_date), sep="-")));

#Eliminacion de variables
hbd.rescols <- c("arrival_date_year",
                 "arrival_date_month",
                 "arrival_date_day_of_month",
                 "arrival_date_week_number",
                 "is_canceled",
                 "booking_changes",
                 "company",
                 "agent",
                 "lead time");

hbd <- hbd[,!names(hbd) %in% hbd.rescols];

zero_guest.nrow <- which(hbd$adults + hbd$children + hbd$babies == 0);

hbd[zero_guest.nrow, ]$adults <- NA;
hbd[zero_guest.nrow, ]$children <- NA;
hbd[zero_guest.nrow, ]$babies <- NA;

hbd.zero_guests <- hbd[zero_guest.nrow, ];

for(i in names(table(hbd.zero_guests[zero_guest.nrow, ]$arrival_cicle))) {
    hbd.zero_guests[hbd.zero_guests$arrival_cicle == i, ]$adults   <- as.integer(round(mean(hbd[hbd$arrival_cicle == i, ]$adults, na.rm = TRUE)), 0);
    hbd.zero_guests[hbd.zero_guests$arrival_cicle == i, ]$children <- as.integer(round(mean(hbd[hbd$arrival_cicle == i, ]$children, na.rm = TRUE)), 0);
    hbd.zero_guests[hbd.zero_guests$arrival_cicle == i, ]$babies   <- as.integer(round(mean(hbd[hbd$arrival_cicle == i, ]$babies, na.rm = TRUE)), 0);
}
#===============================================================================
#plot

pie <- ggplot(hbd, aes(x = reservation_status, fill = hotel)) +
    geom_bar(width = 0.8) + 
    coord_polar(theta = "y") +
    facet_wrap(~arrival_cicle) + 
    theme_bw() +
    ggtitle("Estado de reservas por trimestre por hotel") +
    ylab("Trimestre") +
    xlab("Estado de la Reserva") +
    labs(fill = "Hotel");
pie;

hbd_filt<-hbd
hbd_filt<-filter(hbd_filt,reservation_status!='Canceled')
box_df<-bind_cols(hbd_filt$hotel,hbd_filt$arrival_cicle,hbd_filt$adr)
names(box_df)[1]<-"hotel"
names(box_df)[2]<-"arrival_cicle"
names(box_df)[3]<-"adr"

table(hbd$customer_type)
box_plot_df <- ggplot(box_df,aes(x=arrival_cicle,y=adr,fill=hotel)) +
    geom_boxplot() +
    theme_bw() +
    labs(x="Ciclo",y="Consumo",title="");
box_plot_df;

df_gauss<-bind_cols(hbd$hotel,hbd$adults,hbd$children,hbd$babies,hbd$reservation_status,hbd$arrival_cicle)

names(df_gauss)[1]<-"hotel"
names(df_gauss)[2]<-"adults"
names(df_gauss)[3]<-"children"
names(df_gauss)[4]<-"babies"
names(df_gauss)[5]<-"reservation_status"
names(df_gauss)[6]<-"arrival_cicle"

df_gauss<-filter(df_gauss,reservation_status!='Canceled')
df_gauss$people<-df_gauss$adults+df_gauss$children+df_gauss$babies
df_gauss<-filter(df_gauss,people!=0)
#View(df_gauss)

plot_gauss<-ggplot(df_gauss,
                   aes(
                       x=people,
                       fill=hotel))+
    geom_histogram(breaks=seq(1,14,1),
                   alpha=0.7,
                   color="black",
                   linewidth=1,
                   position = "dodge",
                   stat = "count")+
    scale_x_continuous(breaks=seq(1,14,1))+
    scale_fill_manual(values = c("#172DE2", "#ff8000"))+
    theme_bw()+
    theme(text = element_text(size = 16),
          axis.line = element_line(linewidth   = 1),
          panel.grid.major = element_line(size = 1),
          plot.title = element_text(hjust = 0.5,face="bold"),
          plot.title.position = "plot")+
    xlab("")+
    ylab("")+
    ggtitle("Numero de Clientes por Reservacion por Hotel")+facet_wrap(~arrival_cicle)
plot_gauss


hbd_filt<-hbd
hbd_filt<-filter(hbd_filt,reservation_status!='Canceled')
box_df<-bind_cols(hbd_filt$hotel,hbd_filt$arrival_cicle,hbd_filt$adr)
names(box_df)[1]<-"hotel"
names(box_df)[2]<-"arrival_cicle"
names(box_df)[3]<-"adr"

box_plot_df<-ggplot(box_df,aes(x=arrival_cicle,y=adr,fill=hotel))+
    geom_boxplot()+ theme_bw()+labs(x="Trimestre",y="Consumo por día",title="Diagrama de Consumo por dia por Trimestre por Hotel")
box_plot_df


hbd_filt_country<-as.data.frame(table(hbd_filt$country,hbd_filt$hotel))
names(hbd_filt_country)[1]<-"country"
names(hbd_filt_country)[2]<-"hotel"
hbd_filt_country<-filter(hbd_filt_country,Freq!=0)
hbd_filt_country<-arrange(hbd_filt_country,desc(Freq))
hbd_top_15<-slice(hbd_filt_country,1:15)

hbd_top_15<-hbd_top_15 %>%
    mutate(country_name = countrycode(country,origin="iso3c",destination="country.name"))%>%
    select(-country,country_name,Freq)

#View(hbd_filt_country)
#View(hbd_top_15)
ggplot(hbd_top_15,aes(country_name,Freq,fill=hotel))+
    geom_dotplot(binaxis="y",stackdir = "center")+ theme_bw()+
    labs(x="Paises",y="Frecuencia",title="Diagrama del top 15 de las frecuencias de Paises por hotel")




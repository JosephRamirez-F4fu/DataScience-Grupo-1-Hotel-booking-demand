#Eliminacion de variables
hbd.rescols <- c("arrival_date_year",
                 "arrival_date_month",
                 "arrival_date_day_of_month",
                 "arrival_date_week_number",
                 "is_canceled",
                 "booking_changes","company","agent");


hbd <- hbd[,!names(hbd) %in% hbd.rescols];

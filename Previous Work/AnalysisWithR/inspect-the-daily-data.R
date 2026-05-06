# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
# example of selecting rows
grepl("01/01/2024", UPF_per_hora_Ciudadella$Fecha.y.hora.de.la.medida)
# the selection becomes a new frame
selected_rows_grepl <- UPF_per_hora_Ciudadella[grepl("01/01/2024", UPF_per_hora_Ciudadella$Fecha.y.hora.de.la.medida), ]


#####
# As a function
#####
select_measurements_by_date <- function (a_date_string, a_data_frame) {
     return <- a_data_frame[grepl(a_date_string, a_data_frame$Fecha.y.hora.de.la.medida), ]
}

message("checking the function")
select_measurements_by_date("01/01/2024",UPF_per_hora_Ciudadella)

####
# Define the start and end dates of the year (in particular American format)
start_date <- as.Date("2024-01-01")
end_date <- as.Date("2024-12-31")

# Create a sequence of dates, by "day"
all_dates_in_year <- seq(start_date, end_date, by = "day")

as.Date(all_dates_in_year[1])
day <- format(as.Date(all_dates_in_year[1]), "%d")
month <- format(as.Date(all_dates_in_year[1]), "%m")
year <- format(as.Date(all_dates_in_year[1]), "%Y")

process_date <- function(date) {
  return(paste(format(as.Date(date), "%d"), format(as.Date(date), "%m"),format(as.Date(date), "%Y"), sep = "/"))
}
result_list <- lapply(all_dates_in_year, process_date)

#for (item in result_list) {
#  message(item)
#}

#estimate of rows per month
month=30
months_of_the_year = c("gener", "febrer", "març", "abril", "maig", "juny", "juliol", "agost", "setembre", "octubre", "novembre", "desembre")

 
#
#############
# Constructing the data frame of daily medians from hourly data
#############
# el 6 de gener de 2024 es el primer disapte

daily_medians <- function(data_frame, list_dates_in_year ) {
   daily_df <- data.frame(
      index = numeric(),
      la_data= character(),
      la_magnitud_activa_entrante = numeric(),
      es_dissabte = logical(),
      es_diumenge = logical(),
      es_classe = logical(),
      es_festiu = logical(),
      es_no_lectiu = logical(),
      es_vacances = logical(),
      es_avaluacio = logical(),
      es_benvinguda = logical()
    ) 
   row_id <- 1
   for (item in list_dates_in_year) {
        selected_rows_grepl <- select_measurements_by_date(item,data_frame)
	new_row <- c(row_id,item, 
			median(selected_rows_grepl$Medida.de.la.magnitud.Activa.Entrante..neta),
			((row_id-6)%%7)==0,
			(row_id%%7)==0,
			calendari_corregit$tipus_dia[row_id]=="Classe",
			calendari_corregit$tipus_dia[row_id]=="Festiu",
			calendari_corregit$tipus_dia[row_id]=="No lectiu",
			calendari_corregit$tipus_dia[row_id]=="Vacances",
			calendari_corregit$tipus_dia[row_id]=="Avaluacio", 
			calendari_corregit$tipus_dia[row_id]=="La Benvinguda" 
		    )
	daily_df[row_id,] <- new_row
	row_id <- row_id+1
   } # for all dates
  return(transform(daily_df,la_magnitud_activa_entrante=as.numeric(la_magnitud_activa_entrante) ))
}



year_plot_function <- function(data_frame_labels, main_title, draw_cluster_boundary)
  { plot(1:nrow(data_frame_labels), data_frame_labels$la_magnitud_activa_entrante,
     pch = 21, # Filled circle with border
     main = main_title,
     xaxt="n",
     xlab = "per dia",
     col = ifelse( data_frame_labels$es_dissabte, 'blue', 
           	ifelse( data_frame_labels$es_diumenge,'red',
           	ifelse( data_frame_labels$es_classe,'grey',
           	ifelse( data_frame_labels$es_festiu,"#B22222",
           	ifelse( data_frame_labels$es_no_lectiu,"orange",
           	ifelse( data_frame_labels$es_vacances,"#F0E68C",
           	ifelse( data_frame_labels$es_avaluacio,"#B0C4DE",
           	ifelse( data_frame_labels$es_benvinguda,"pink",
	    'black')))))))), 
     bg = ifelse( data_frame_labels$es_dissabte, "blue", 
		 ifelse( data_frame_labels$es_diumenge,'red',
		 ifelse( data_frame_labels$es_classe,'grey',
           	ifelse( data_frame_labels$es_festiu,"#B22222",
           	ifelse( data_frame_labels$es_no_lectiu,"orange",
           	ifelse( data_frame_labels$es_vacances,"#F0E68C",
           	ifelse( data_frame_labels$es_avaluacio,"#B0C4DE",
           	ifelse( data_frame_labels$es_benvinguda,"pink",
		'white')))))))), 
     ylab = "Mesura de la magnitud Activa Entrant (net)",
)

axis(1, at = seq(month/2, nrow(magnitud_activa_per_UPF_per_hora_Ciudadella), by = month), 
	labels = months_of_the_year )
	legend("topright", 
	legend = c("dissabte", "diumenge","classe","festiu","no lectiu","vacances","avaluacio","benvingida"),
	 col = c("blue", "red","grey","#B22222","orange","#F0E68C","#B0C4DE","pink"), lty = 1)
	if(draw_cluster_boundary) {
     			lines( 1:nrow(data_frame_labels) , data_frame_labels$clusters_boundary, type = "o", col = "black", lty="dashed")
		}
}

preparar_datos_energia <- function(df_original) {


  timestamp_real <- as.POSIXct(df_original$Fecha.y.hora.de.la.medida, 
                               format = "%d/%m/%Y %H:%M")
  
  df_original$fecha <- as.Date(timestamp_real)
  df_original$hora  <- as.numeric(format(timestamp_real, "%H"))
  
  return(df_original)
}

UPF_per_hora_Ciudadella <- preparar_datos_energia(UPF_per_hora_Ciudadella)
UPF_per_hora_Poblenou   <- preparar_datos_energia(UPF_per_hora_Poblenou)

calendar_df <- data.frame(
  fecha = as.Date(calendari_corregit$la_data, format = "%d/%m/%Y"),
  tipus_dia = calendari_corregit$tipus_dia
)


#Daily Profile
daily_profile_by_day_type <- function(data_frame, calendar_df) {
  
  data_with_day_type <- merge(
    data_frame,
    calendar_df,
    by  = "fecha"
  )
  
  profile_df <- aggregate(
    Medida.de.la.magnitud.Activa.Entrante..neta. ~ tipus_dia + hora,
    data = data_with_day_type,
    FUN = median,
    na.rm = TRUE
  )
  
  colnames(profile_df)[3] <- "consumo_mediano"
  
  return(profile_df)
}

plot_daily_profiles <- function(profile_df, main_title) {
  
  max_y <- max(profile_df$consumo_mediano, na.rm = TRUE)
  
  plot(1, type = "n", 
       xlim = c(0, 23),             # De 0 a 23 horas
       ylim = c(0, max_y * 1.1),    
       main = main_title,
       xaxt = "n",                  
       xlab = "Hora del dia",
       ylab = "Mesura de la magnitud Activa Entrant (net)" 
  )
  
  axis(1, at = 0:23, labels = 0:23)
  grid()
  
  tipus_disponibles <- unique(profile_df$tipus_dia)
  
  for (tipo in tipus_disponibles) {
    
    datos_subset <- profile_df[profile_df$tipus_dia == tipo, ]
    datos_subset <- datos_subset[order(datos_subset$hora), ]
    
    color_linea <- ifelse(tipo == "Dissabte", 'blue', 
                   ifelse(tipo == "Diumenge", 'red',
                   ifelse(tipo == "Classe", 'grey',
                   ifelse(tipo == "Festiu", "#B22222",
                   ifelse(tipo == "No lectiu", "orange",
                   ifelse(tipo == "Vacances", "#F0E68C",
                   ifelse(tipo == "Avaluacio", "#B0C4DE",
                   ifelse(tipo == "La Benvinguda", "pink",
                   'white')))))))) 
    
    lines(datos_subset$hora, 
          datos_subset$consumo_mediano, 
          col = color_linea, 
          lwd = 2) 
  }
  
  legend("topleft", 
         legend = c("dissabte", "diumenge","classe","festiu","no lectiu","vacances","avaluacio","benvingida"),
         col = c("blue", "red","grey","#B22222","orange","#F0E68C","#B0C4DE","pink"), 
         lty = 1, # Tipo de línea continua
         lwd = 3, # Grosor en la leyenda
         cex = 0.8) 
}


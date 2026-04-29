# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
print("Data headers:")
colnames(UPF_per_hora_Ciudadella)
######### Validate data
if (any(is.na(UPF_per_hora_Ciudadella$Fecha.y.hora.de.la.medida)) ) {
	print("Valors incomplets a UPF_per_hora_Ciudadella$Fecha.y.hora.de.la.medida")
} else {
	print("Columna UPF_per_hora_Ciudadella$Fecha.y.hora.de.la.medida està complet")
}
if (any(is.na(UPF_per_hora_Ciudadella$Medida.de.la.magnitud.Activa.Entrante..neta.))) {
        print("Valors incomplets a UPF_per_hora_Ciudadella$Medida.de.la.magnitud.Activa.Entrante..neta.")
} else {
        print("Columna UPF_per_hora_Ciudadella$Medida.de.la.magnitud.Activa.Entrante..neta. està complet")
}
grepl("01/01/2024", UPF_per_hora_Ciudadella$Fecha.y.hora.de.la.medida)
selected_rows_grepl <- UPF_per_hora_Ciudadella[grepl("01/01/2024", UPF_per_hora_Ciudadella$Fecha.y.hora.de.la.medida), ]
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

for (item in result_list) {
  print(item)
}

 
daily_df <- data.frame(
      index = numeric(),
      la_data= character(),
      la_magnitud_activa_entrante = numeric(),
      es_dissabte = logical(),
      es_diumenge = logical()
    )

# el 6 de gener de 2024 es el primer disapte

row_id <- 1
for (item in result_list) {
	selected_rows_grepl <- UPF_per_hora_Ciudadella[grepl(item, UPF_per_hora_Ciudadella$Fecha.y.hora.de.la.medida), ]
	new_row <- c(row_id,item, median(selected_rows_grepl$Medida.de.la.magnitud.Activa.Entrante..neta),((row_id-6)%%7)==0,(row_id%%7)==0 )
	daily_df[row_id,] <- new_row
	row_id <- row_id+1
}

#estimate of rows per month
month=30
months_of_the_year = c("gener", "febrer", "març", "abril", "maig", "juny", "juliol", "agost", "setembre", "octubre", "novembre", "desembre")
plot(1:nrow(daily_df), daily_df$la_magnitud_activa_entrante,
     pch = 21, # Filled circle with border
     main = "Campus Ciudadella : Vista Total de l'any 2024 (mediana per dia)",
     xaxt="n",
     xlab = "per dia",
     col = ifelse( daily_df$es_dissabte, 'red',  ifelse( daily_df$es_diumenge,'blue','black')), 
     bg = ifelse( daily_df$es_dissabte, "red",  ifelse( daily_df$es_diumenge,'blue','white')), 
     ylab = "Mesura de la magnitud Activa Entrant (net)")

axis(1, at = seq(month/2, nrow(daily_df), by = month), labels = months_of_the_year )
legend("topright", legend = c("dissabte", "diumenge"), col = c("red", "blue"), lty = 1)

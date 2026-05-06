library(data.table)

data <- fread("C:/Users/jordi/TFG/AnalysisWithR/other_data/2024hourlymeteo.csv")

temp_data <- data[, .(
  time = as.POSIXct(
    sprintf("%04d-%02d-%02d %02d:00:00", year, month, day, hour),
    format = "%Y-%m-%d %H:%M:%S",
    tz = "Europe/Madrid"
  ),
  temp
)]

temp_data <- temp_data[!is.na(temp)]
library(data.table)

perfil_diario <- function(temp_data) {
  
  # Asegurar formato data.table
  temp_data <- as.data.table(temp_data)
  
  # Extraer la hora
  temp_data[, hour := as.integer(format(time, "%H"))]
  
  # Calcular promedio por hora
  perfil <- temp_data[, .(
    temp_media = mean(temp, na.rm = TRUE)
  ), by = hour]
  
  # Ordenar por hora
  setorder(perfil, hour)
  
  return(perfil)
}
perfil <- perfil_diario(temp_data)

plot(perfil$hour, perfil$temp_media,
     type = "l",
     xlab = "Hora del día",
     ylab = "Temperatura media (°C)",
     main = "Perfil diario de temperatura")


perfil_diario_estacional <- function(temp_data) {
  
  temp_data <- as.data.table(temp_data)
  
  # Extraer hora y mes
  temp_data[, hour := as.integer(format(time, "%H"))]
  temp_data[, month := as.integer(format(time, "%m"))]
  
  # Crear variable estación
  temp_data[, season := fifelse(month %in% c(12,1,2), "Winter",
                                fifelse(month %in% c(3,4,5), "Spring",
                                        fifelse(month %in% c(6,7,8), "Summer", "Autumn")))]
  
  # Calcular perfil diario por estación
  perfil <- temp_data[, .(
    temp_media = mean(temp, na.rm = TRUE)
  ), by = .(season, hour)]
  
  # Ordenar
  setorder(perfil, season, hour)
  
  return(perfil)
}
perfil_estacional <- perfil_diario_estacional(temp_data)

print(perfil_estacional)
library(ggplot2)

ggplot(perfil_estacional, aes(x=hour, y=temp_media, color=season)) +
  geom_line(size=1) +
  labs(title="Perfil diario estacional",
       x="Hora del día",
       y="Temperatura media (°C)") +
  theme_minimal()
library(data.table)

library(data.table)

setDT(temp_data)
setDT(magnitud_activa_per_UPF_per_hora_Ciudadella)

data_total <- merge(
  temp_data,
  magnitud_activa_per_UPF_per_hora_Ciudadella,
  by = "time"
)

magnitud_activa_per_UPF_per_hora_Ciudadella[, tipo_dia :=
       fifelse(es_dissabte, "dissabte",
               fifelse(es_diumenge, "diumenge",
                       fifelse(es_classe, "classe",
                               fifelse(es_festiu, "festiu",
                                       fifelse(es_no_lectiu, "no_lectiu",
                                               fifelse(es_vacances, "vacances",
                                                       fifelse(es_avaluacio, "avaluacio",
                                                               fifelse(es_benvinguda, "benvinguda", NA_character_))))))))]

data[, magnitud_activa_per_UPF_per_hora_Ciudadella := factor(magnitud_activa_per_UPF_per_hora_Ciudadella)]

data[, rango_temp := cut(temp,
                         breaks = seq(floor(min(temp)),
                                      ceiling(max(temp)),
                                      by = 5),
                         include.lowest = TRUE)]

table(data$tipo_dia)
correlaciones_rango <- data[, .(
  correlacion = cor(temp, consumo, use="complete.obs"),
  n = .N
), by = .(rango_temp, tipo_dia)]
perfil_rango <- data[, .(
  consumo_medio = mean(consumo, na.rm=TRUE),
  temp_media = mean(temp, na.rm=TRUE),
  n = .N
), by = .(rango_temp, tipo_dia)]
data[, HDD := pmax(0, 18 - temp)]
data[, CDD := pmax(0, temp - 22)]
data[, rango_frio := cut(HDD, breaks=quantile(HDD, probs=seq(0,1,0.2)), include.lowest=TRUE)]

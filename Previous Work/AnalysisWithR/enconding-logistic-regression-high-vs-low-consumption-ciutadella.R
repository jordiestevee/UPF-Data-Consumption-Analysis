# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu

#structure of frame for applying logistic regression
encoded_consumption_ciutadella <- data.frame(
	 is_high_consumption = numeric(), 
	 es_dissabte = numeric(), 
	 es_diumenge = numeric(), 
	 es_classe = numeric(), 
	 es_festiu = numeric(), 
	 es_no_lectiu = numeric(), 
	 es_vacances = numeric(),
	 es_avaluacio = numeric(),
	 es_benvinguda = numeric()
)


for (i in 1:nrow(magnitud_activa_per_UPF_per_hora_Ciudadella)) {
  current_row <- magnitud_activa_per_UPF_per_hora_Ciudadella[i, ] # Access the current row
  new_row_data <- c(
	 ifelse(current_row$la_magnitud_activa_entrante > current_row$clusters_boundary, 1.0, 0.0),
	ifelse(current_row$es_dissabte, 1.0, 0.0), #es_dissabte
	ifelse(current_row$es_diumenge, 1.0, 0.0), #es_diumenge
	ifelse(current_row$es_classe, 1.0, 0.0), #es_classe
	ifelse(current_row$es_festiu, 1.0, 0.0), #es_festiu
	ifelse(current_row$es_no_lectiu, 1.0, 0.0), #es_no_lectiu
	ifelse(current_row$es_vacances, 1.0, 0.0), #es_vacances
	ifelse(current_row$es_avaluacio, 1.0, 0.0), #es_avaluacio
	ifelse(current_row$es_benvinguda, 1.0, 0.0) #es_benvinguda
		)
  encoded_consumption_ciutadella[i,] <- new_row_data
}

model <- lm(is_high_consumption~es_classe+es_dissabte+es_diumenge+es_festiu+es_no_lectiu+es_vacances+es_avaluacio+es_benvinguda, data = encoded_consumption_ciutadella)

summary(model)

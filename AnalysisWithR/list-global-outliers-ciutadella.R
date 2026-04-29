# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu


# Loop through rows by index
print("Dissabtes amb consum elevant")
for (i in 1:nrow(magnitud_activa_per_UPF_per_hora_Ciudadella)) {
  current_row <- magnitud_activa_per_UPF_per_hora_Ciudadella[i, ] # Access the current row
  if (  current_row$es_dissabte  
    ) {
	if (current_row$la_magnitud_activa_entrante > current_row$clusters_boundary)
           { print(current_row$la_data) }
      }
}

print("Vacances amb consum elevant")
for (i in 1:nrow(magnitud_activa_per_UPF_per_hora_Ciudadella)) {
  current_row <- magnitud_activa_per_UPF_per_hora_Ciudadella[i, ] # Access the current row
  if (  current_row$es_vacances  
    ) {
	if (current_row$la_magnitud_activa_entrante > current_row$clusters_boundary )
       		{ print(current_row$la_data)}
      }
}

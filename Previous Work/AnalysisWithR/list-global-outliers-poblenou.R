# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu



print("Vacances amb consum elevant")
for (i in 1:nrow(magnitud_activa_per_UPF_per_hora_Poblenou)) {
  current_row <- magnitud_activa_per_UPF_per_hora_Poblenou[i, ] # Access the current row
  if (  current_row$es_vacances  
    ) {
	if (current_row$la_magnitud_activa_entrante > current_row$clusters_boundary )
       		{ print(current_row$la_data)}
      }
}

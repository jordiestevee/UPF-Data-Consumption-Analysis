# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu


altres_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[
		magnitud_activa_per_UPF_per_hora_Ciudadella$es_dissabte==FALSE
		&
		magnitud_activa_per_UPF_per_hora_Ciudadella$es_diumenge==FALSE
		&
		magnitud_activa_per_UPF_per_hora_Ciudadella$es_classe==FALSE
		&
		magnitud_activa_per_UPF_per_hora_Ciudadella$es_festiu==FALSE
		&
		magnitud_activa_per_UPF_per_hora_Ciudadella$es_no_lectiu==FALSE
		&
		magnitud_activa_per_UPF_per_hora_Ciudadella$es_vacances==FALSE
		&
		magnitud_activa_per_UPF_per_hora_Ciudadella$es_avaluacio==FALSE
		&
		magnitud_activa_per_UPF_per_hora_Ciudadella$es_benvinguda==FALSE

,]

altres_ciutadella_lower_outliers <- get_lower_outliers(altres_ciutadella_df)

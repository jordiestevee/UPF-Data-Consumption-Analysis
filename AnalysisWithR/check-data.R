# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
######### Validate data

check_input_for_missing_values <- function(parameter_data_frame) {
	######### Validate data
	if (any(is.na(parameter_data_frame$Fecha.y.hora.de.la.medida)) ) {
		print(paste("Valors incomplets ",deparse(substitute(parameter_data_frame)),"$Fecha.y.hora.de.la.medida"))
	} else {
		print(paste("Columna ",deparse(substitute(parameter_data_frame)) ,"$Fecha.y.hora.de.la.medida està complet"))
	}
	if (any(is.na(parameter_data_frame$Medida.de.la.magnitud.Activa.Entrante..neta.))) {
        print(paste("Valors incomplets a ",deparse(substitute(parameter_data_frame)) ,"$Medida.de.la.magnitud.Activa.Entrante..neta."))
	} else {
        	print(paste("Columna ", deparse(substitute(parameter_data_frame)), "$Medida.de.la.magnitud.Activa.Entrante..neta. està complet"))
	}
}
message("calling function")
check_input_for_missing_values(UPF_per_hora_Ciudadella)
check_input_for_missing_values(UPF_per_hora_Poblenou)
check_input_for_missing_values(UPF_per_quart_Ciudadella)
check_input_for_missing_values(UPF_per_quart_Poblenou)

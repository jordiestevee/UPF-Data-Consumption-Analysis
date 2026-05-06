# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu


get_outliers <- function (a_frame){
    Q1 <- quantile(a_frame$la_magnitud_activa_entrante, .25,na.rm = TRUE )
    Q3 <- quantile(a_frame$la_magnitud_activa_entrante, .75, na.rm = TRUE)
    IQR <- Q3 - Q1

    lower_bound <- Q1 - 1.5 * IQR
    upper_bound <- Q3 + 1.5 * IQR

    return( subset(a_frame,a_frame$la_magnitud_activa_entrante < lower_bound | a_frame$la_magnitud_activa_entrante > upper_bound))

}

altres_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[
                magnitud_activa_per_UPF_per_hora_Poblenou$es_dissabte==FALSE
                &
                magnitud_activa_per_UPF_per_hora_Poblenou$es_diumenge==FALSE
                &
                magnitud_activa_per_UPF_per_hora_Poblenou$es_classe==FALSE
                &
                magnitud_activa_per_UPF_per_hora_Poblenou$es_festiu==FALSE
                &
                magnitud_activa_per_UPF_per_hora_Poblenou$es_no_lectiu==FALSE
                &
                magnitud_activa_per_UPF_per_hora_Poblenou$es_vacances==FALSE
                &
                magnitud_activa_per_UPF_per_hora_Poblenou$es_avaluacio==FALSE
                &
                magnitud_activa_per_UPF_per_hora_Poblenou$es_benvinguda==FALSE

,]
avaluacio_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[magnitud_activa_per_UPF_per_hora_Poblenou$es_avaluacio==TRUE,]
classe_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[magnitud_activa_per_UPF_per_hora_Poblenou$es_classe==TRUE,]
saturday_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[magnitud_activa_per_UPF_per_hora_Poblenou$es_dissabte==TRUE,]
sunday_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[magnitud_activa_per_UPF_per_hora_Poblenou$es_diumenge==TRUE,]
festiu_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[magnitud_activa_per_UPF_per_hora_Poblenou$es_festiu==TRUE,]
benvinguda_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[magnitud_activa_per_UPF_per_hora_Poblenou$es_benvinguda==TRUE,]
no_lectiu_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[magnitud_activa_per_UPF_per_hora_Poblenou$es_no_lectiu==TRUE,]
vacances_poblenou_df <- magnitud_activa_per_UPF_per_hora_Poblenou[magnitud_activa_per_UPF_per_hora_Poblenou$es_vacances==TRUE,]

message(paste("Altres ",nrow(altres_poblenou_df)))
message(paste("Avaluacio ",nrow(avaluacio_poblenou_df)))
message(paste("Classe ",nrow(classe_poblenou_df)))
message(paste("Dissabta ",nrow(saturday_poblenou_df)))
message(paste("Diumenge ",nrow(sunday_poblenou_df)))
message(paste("Festiu ",nrow(festiu_poblenou_df)))
message(paste("La benvinguda ",nrow(benvinguda_poblenou_df)))
message(paste("No lectiu ",nrow(no_lectiu_poblenou_df)))
message(paste("Vacances ",nrow(vacances_poblenou_df)))

message(paste("Total ",nrow(vacances_poblenou_df)
		+nrow(avaluacio_poblenou_df)
		+nrow(altres_poblenou_df)
		+nrow(classe_poblenou_df)
		+nrow(saturday_poblenou_df)
		+nrow(sunday_poblenou_df)
		+nrow(festiu_poblenou_df)
		+nrow(benvinguda_poblenou_df)
		+nrow(no_lectiu_poblenou_df)))


classe_poblenou_outliers <- get_outliers(classe_poblenou_df)

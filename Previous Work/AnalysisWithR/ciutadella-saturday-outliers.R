# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu

# day types classes for ciutadella
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
avaluacio_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[magnitud_activa_per_UPF_per_hora_Ciudadella$es_avaluacio==TRUE,]
classe_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[magnitud_activa_per_UPF_per_hora_Ciudadella$es_classe==TRUE,]
saturday_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[magnitud_activa_per_UPF_per_hora_Ciudadella$es_dissabte==TRUE,]
sunday_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[magnitud_activa_per_UPF_per_hora_Ciudadella$es_diumenge==TRUE,]
festiu_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[magnitud_activa_per_UPF_per_hora_Ciudadella$es_festiu==TRUE,]
benvinguda_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[magnitud_activa_per_UPF_per_hora_Ciudadella$es_benvinguda==TRUE,]
no_lectiu_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[magnitud_activa_per_UPF_per_hora_Ciudadella$es_no_lectiu==TRUE,]
vacances_ciutadella_df <- magnitud_activa_per_UPF_per_hora_Ciudadella[magnitud_activa_per_UPF_per_hora_Ciudadella$es_vacances==TRUE,]

message(paste("Altres ",nrow(altres_ciutadella_df)))
message(paste("Avaluacio ",nrow(avaluacio_ciutadella_df)))
message(paste("Classe ",nrow(classe_ciutadella_df)))
message(paste("Dissabta ",nrow(saturday_ciutadella_df)))
message(paste("Diumenge ",nrow(sunday_ciutadella_df)))
message(paste("Festiu ",nrow(festiu_ciutadella_df)))
message(paste("La benvinguda ",nrow(benvinguda_ciutadella_df)))
message(paste("No lectiu ",nrow(no_lectiu_ciutadella_df)))
message(paste("Vacances ",nrow(vacances_ciutadella_df)))

message(paste("Total ",nrow(vacances_ciutadella_df)
                +nrow(avaluacio_ciutadella_df)
                +nrow(altres_ciutadella_df)
                +nrow(classe_ciutadella_df)
                +nrow(saturday_ciutadella_df)
                +nrow(sunday_ciutadella_df)
                +nrow(festiu_ciutadella_df)
                +nrow(benvinguda_ciutadella_df)
                +nrow(no_lectiu_ciutadella_df)))

saturday_ciutadella_outliers <- get_outliers(saturday_ciutadella_df)

get_lower_outliers <- function (a_frame){
    Q1 <- quantile(a_frame$la_magnitud_activa_entrante, .25,na.rm = TRUE )
    Q3 <- quantile(a_frame$la_magnitud_activa_entrante, .75, na.rm = TRUE)
    IQR <- Q3 - Q1

    lower_bound <- Q1 - 1.5 * IQR

    return( subset(a_frame,a_frame$la_magnitud_activa_entrante < lower_bound ))

}

get_higher_outliers <- function (a_frame){
    Q3 <- quantile(a_frame$la_magnitud_activa_entrante, .75, na.rm = TRUE)
    Q1 <- quantile(a_frame$la_magnitud_activa_entrante, .25,na.rm = TRUE )
    IQR <- Q3 - Q1

    upper_bound <- Q3 + 1.5 * IQR

    return( subset(a_frame, a_frame$la_magnitud_activa_entrante > upper_bound))
}

saturday_ciutadella_lower_outliers <- get_lower_outliers(saturday_ciutadella_df)
saturday_ciutadella_higher_outliers <- get_higher_outliers(saturday_ciutadella_df)

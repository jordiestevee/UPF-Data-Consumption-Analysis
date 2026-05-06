# read_calendar.R
message("(c) Vladimir Estivill-Castro")
# Calendari_UPF_2024
Calendari_UPF_2024<- read.table("../../AnalysisWithR/other_data/Calendari2024/Calendari-UPF-2024.csv", header = FALSE, sep = ",")
dias_al_Calendari_UPF_2024 <- nrow(Calendari_UPF_2024)
print(paste("Calendari UPF 2024, ","numero de files llegides:", dias_al_Calendari_UPF_2024 ))
total_disabte <- 0
total_diumenge <- 0
total_vacances <- 0
total_no_lectiu <- 0
total_festiu <- 0
total_classe <- 0
total_avaluacio <- 0
total_recuperacio <- 0
total_sense_etiqueta <- 0
total_recuperacio_disabte <- 0
total_avaluacio_disabte <- 0
total_la_benvinguda <- 0
total_vacances_cap_de_setmana  <- 0
total_classe_cap_de_setmana  <- 0
total_festiu_cap_de_setmana  <- 0
total_weekdays  <- 0

anomalies <- data.frame(
	 index = numeric(),
      la_data= character()
    )
calendari_corregit <- data.frame(
	 index = numeric(),
      la_data= character(),
      tipus_dia= character()
    )

tipus_dia_vector <- c("Altre", "La Benvinguda","Vacances","Classe","Recuperacio","Festiu","No lectiu","Avaluacio","Dissabte","Diumenge")

row_id <- 1
anomaly_id <- 1
for (i in 1:nrow(Calendari_UPF_2024)) {
  # Access the current row
  current_row <- Calendari_UPF_2024[i, ]
  if (((row_id-6)%%7)==0) { total_disabte<-total_disabte+1
				calendari_corregit[row_id,] <- c(row_id,current_row$V1,"Dissabte")
				if (startsWith(current_row$V2,"Recu")) { total_recuperacio_disabte<-total_recuperacio_disabte+1}
			        if (startsWith(current_row$V2,"Avaluaci")) { total_avaluacio_disabte<-total_avaluacio_disabte+1}
				if (current_row$V2=="Vacances") { total_vacances_cap_de_setmana<-total_vacances_cap_de_setmana+1}
				if (current_row$V2=="Festiu") { total_festiu_cap_de_setmana<-total_festiu_cap_de_setmana+1}
			        if (current_row$V2=="Classe") { total_classe_cap_de_setmana<-total_classe_cap_de_setmana+1
						message(current_row$V1)
						anomalies[anomaly_id,] <- c(anomaly_id,current_row$V1)
						anomaly_id <- anomaly_id+1
						}
                           }
  if ((row_id%%7)==0) { total_diumenge<-total_diumenge+1
			calendari_corregit[row_id,] <- c(row_id,current_row$V1,"Diumenge")
			if (current_row$V2=="Vacances") { total_vacances_cap_de_setmana<-total_vacances_cap_de_setmana+1}
				if (current_row$V2=="Festiu") { total_festiu_cap_de_setmana<-total_festiu_cap_de_setmana+1}
			if (current_row$V2=="Classe") { total_classe_cap_de_setmana<-total_classe_cap_de_setmana+1
						message(current_row$V1)
						anomalies[anomaly_id,] <- c(anomaly_id,current_row$V1)
						anomaly_id <- anomaly_id+1
						}
			}
  if (  ((row_id%%7)!=0) && (((row_id-6)%%7)!=0)   ) { 
	total_weekdays <- total_weekdays +1
	if (current_row$V2=="Vacances") { total_vacances<-total_vacances+1
					  calendari_corregit[row_id,] <- c(row_id,current_row$V1,"Vacances")
                                        }
	else {
		if (current_row$V2=="No lectiu") { total_no_lectiu<-total_no_lectiu+1
					           calendari_corregit[row_id,] <- c(row_id,current_row$V1,"No lectiu")
				}
		else  { 
			if (current_row$V2=="Festiu") { total_festiu<-total_festiu+1
					                calendari_corregit[row_id,] <- c(row_id,current_row$V1,"Festiu")
				}
			else if (current_row$V2=="Classe") { total_classe<-total_classe+1
					                     calendari_corregit[row_id,] <- c(row_id,current_row$V1,"Classe")
					}
			else if (current_row$V2=="La Benvinguda") { total_la_benvinguda<-total_la_benvinguda+1	
					                           calendari_corregit[row_id,] <- c(row_id,current_row$V1,"La Benvinguda")
								}
			else if (startsWith(current_row$V2,"Avaluaci")) { total_avaluacio<-total_avaluacio+1
					                           calendari_corregit[row_id,] <- c(row_id,current_row$V1,"Avaluacio")
								}
			else if (startsWith(current_row$V2,"Recu")) { total_recuperacio<-total_recuperacio+1
					                           calendari_corregit[row_id,] <- c(row_id,current_row$V1,"Recuperacio")
									}
			else { total_sense_etiqueta<-total_sense_etiqueta+1
					 calendari_corregit[row_id,] <- c(row_id,current_row$V1,"Altre")
				}
	     } # no lectiu
   	} # vacances
  } # no es disabte ni diumenge
  row_id <- row_id+1
}
message(paste("total_disabte",total_disabte))
message(paste("total_diumenge",total_diumenge))
message(paste("total_vacances",total_vacances))
message(paste("total_no_lectiu",total_no_lectiu))
message(paste("total_festiu",total_festiu))
message(paste("total_classe",total_classe))
message(paste("total_avaluacio",total_avaluacio))
message(paste("total_recuperacio",total_recuperacio))
message(paste("total_la_benvinguda",total_la_benvinguda))
message(paste("total_sense_etiqueta",total_sense_etiqueta))
total_dies_classificats <- total_disabte + total_diumenge + total_vacances + total_no_lectiu + total_festiu + total_classe +total_avaluacio + total_la_benvinguda + total_recuperacio + total_sense_etiqueta
message(paste("total_dies_classificats",total_dies_classificats))
message(paste("total_recuperacio_disabte",total_recuperacio_disabte))
message(paste("total_avaluacio_disabte",total_avaluacio_disabte))
message(paste("total_vacances_cap_de_setmana",total_vacances_cap_de_setmana))
message(paste("total_classe_cap_de_setmana",total_classe_cap_de_setmana))
message(paste("total_festiu_cap_de_setmana",total_festiu_cap_de_setmana))
message(paste("total_weekdays",total_weekdays))
message(paste("total_weekdays+weekends",total_weekdays+total_disabte+total_diumenge))


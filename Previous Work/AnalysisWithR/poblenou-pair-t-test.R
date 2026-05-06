## (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
#
## Shapiro-Wilk normality test
##Avalaucio
#test_de_normalitat_poblenou_dia_tipus_avaluacio <-with(magnitud_activa_per_UPF_per_hora_Poblenou, shapiro.test(la_magnitud_activa_entrante[es_avaluacio==TRUE]))
#print(test_de_normalitat_poblenou_dia_tipus_avaluacio)
#print("El valor p hauria de ser superiors al nivell de significació 0,05")
#print(" per que la distribució de les dades no sigui significativament diferent de la distribució normal")
#
## Classe
#test_de_normalitat_poblenou_dia_tipus_classe <-with(magnitud_activa_per_UPF_per_hora_Poblenou, shapiro.test(la_magnitud_activa_entrante[es_classe==TRUE]))
#print(test_de_normalitat_poblenou_dia_tipus_classe)
#print("El valor p hauria de ser superiors al nivell de significació 0,05")
#print(" per que la distribució de les dades no sigui significativament diferent de la distribució normal")
#
## Dissabte
#test_de_normalitat_poblenou_dia_tipus_dissabte <-with(magnitud_activa_per_UPF_per_hora_Poblenou, shapiro.test(la_magnitud_activa_entrante[es_dissabte==TRUE]))
#print(test_de_normalitat_poblenou_dia_tipus_dissabte)
#print("El valor p hauria de ser superiors al nivell de significació 0,05")
#print(" per que la distribució de les dades no sigui significativament diferent de la distribució normal")
#
## Diumenge
#test_de_normalitat_poblenou_dia_tipus_diumenge <-with(magnitud_activa_per_UPF_per_hora_Poblenou, shapiro.test(la_magnitud_activa_entrante[es_diumenge==TRUE]))
#print(test_de_normalitat_poblenou_dia_tipus_diumenge)
#print("El valor p hauria de ser superiors al nivell de significació 0,05")
#print(" per que la distribució de les dades no sigui significativament diferent de la distribució normal")
#
## Festiu
#test_de_normalitat_poblenou_dia_tipus_festiu <-with(magnitud_activa_per_UPF_per_hora_Poblenou, shapiro.test(la_magnitud_activa_entrante[es_festiu==TRUE]))
#print(test_de_normalitat_poblenou_dia_tipus_festiu)
#print("El valor p hauria de ser superiors al nivell de significació 0,05")
#print(" per que la distribució de les dades no sigui significativament diferent de la distribució normal")
#
## La Benvinguda
test_de_normalitat_poblenou_dia_tipus_benvinguda <-with(magnitud_activa_per_UPF_per_hora_Poblenou, shapiro.test(la_magnitud_activa_entrante[es_benvinguda==TRUE]))
print(test_de_normalitat_poblenou_dia_tipus_benvinguda)
print("El valor p hauria de ser superiors al nivell de significació 0,05")
print(" per que la distribució de les dades no sigui significativament diferent de la distribució normal")
#
#
## Vacances
#test_de_normalitat_poblenou_dia_tipus_vacances <-with(magnitud_activa_per_UPF_per_hora_Poblenou, shapiro.test(la_magnitud_activa_entrante[es_vacances==TRUE]))
#print(test_de_normalitat_poblenou_dia_tipus_vacances)
#print("El valor p hauria de ser superiors al nivell de significació 0,05")
#print(" per que la distribució de les dades no sigui significativament diferent de la distribució normal")
#
## Altres
#test_de_normalitat_poblenou_dia_tipus_altres <- shapiro.test(altres_poblenou_df$la_magnitud_activa_entrante)
#print(test_de_normalitat_poblenou_dia_tipus_altres)
#print("El valor p hauria de ser superiors al nivell de significació 0,05")
#print(" per que la distribució de les dades no sigui significativament diferent de la distribució normal")
#
#

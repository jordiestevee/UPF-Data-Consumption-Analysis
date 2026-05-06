## (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
#
## Wilcoxon test

wilcoxon_test_and_report <- function(first_vector, second_vector,First_Name,Second_name)
{
origin_id <- c(rep(First_Name, length(first_vector)),
               rep(Second_name, length(second_vector)))
data_for_wilcoxon_first_vs_second <- data.frame( 
                day_type = origin_id,
                magnitut = c(first_vector,  second_vector)
                )
   res <- wilcox.test(magnitut ~ day_type, data = data_for_wilcoxon_first_vs_second,
                   exact = FALSE)
  if(res$p.value <0.05) {
    print(paste(First_Name," i ",Second_name, " són significativament diferents amb un 95% de confiança" ))
    print(paste("El valor p (a la prova Wilcoxon de R) és " , res$p.value))
  }
}
wil_poblenou_avaluacio <- avaluacio_poblenou_df$la_magnitud_activa_entrante
wil_poblenou_classe <- classe_poblenou_df$la_magnitud_activa_entrante
origin_id <- c(rep("Avaluacio", length(wil_poblenou_avaluacio)),
               rep("Classe", length(wil_poblenou_classe)))
data_for_wilcoxon_avaluacio_vs_classe <- data.frame( 
                day_type = origin_id,
                magnitut = c(wil_poblenou_avaluacio,  wil_poblenou_classe)
                )

# group_by(data_for_wilcoxon_avaluacio_vs_classe, day_type) %>%
#  summarise(
#    count = n(),
#    median = median(magnitut, na.rm = TRUE),
#    IQR = IQR(magnitut, na.rm = TRUE)
#  ) %>%
#  message()

res <- wilcox.test(magnitut ~ day_type, data = data_for_wilcoxon_avaluacio_vs_classe,
                   exact = FALSE)

#print("Per al dia del tipus 'Avaluació', hem trobat una diferència significativa amb els següents tipus:")
#wilcoxon_test_and_report(avaluacio_poblenou_df$la_magnitud_activa_entrante,classe_poblenou_df$la_magnitud_activa_entrante,"Avaluació","Classe")
#wilcoxon_test_and_report(avaluacio_poblenou_df$la_magnitud_activa_entrante,altres_poblenou_df$la_magnitud_activa_entrante,"Avaluació","Altre")
#wilcoxon_test_and_report(avaluacio_poblenou_df$la_magnitud_activa_entrante,saturday_poblenou_df$la_magnitud_activa_entrante,"Avaluació","Dissabte")
#wilcoxon_test_and_report(avaluacio_poblenou_df$la_magnitud_activa_entrante,sunday_poblenou_df$la_magnitud_activa_entrante,"Avaluació","Diumenge")
#wilcoxon_test_and_report(avaluacio_poblenou_df$la_magnitud_activa_entrante,festiu_poblenou_df$la_magnitud_activa_entrante,"Avaluació","Festiu")
#wilcoxon_test_and_report(avaluacio_poblenou_df$la_magnitud_activa_entrante,benvinguda_poblenou_df$la_magnitud_activa_entrante,"Avaluació","La benvinguda")
#wilcoxon_test_and_report(avaluacio_poblenou_df$la_magnitud_activa_entrante,no_lectiu_poblenou_df$la_magnitud_activa_entrante,"Avaluació","No lectiu")
#wilcoxon_test_and_report(avaluacio_poblenou_df$la_magnitud_activa_entrante,vacances_poblenou_df$la_magnitud_activa_entrante,"Avaluació","Vacances")

#print("Per al dia del tipus 'Classe', hem trobat una diferència significativa amb els següents tipus:")
#wilcoxon_test_and_report(classe_poblenou_df$la_magnitud_activa_entrante,altres_poblenou_df$la_magnitud_activa_entrante,"Classe","Altre")
#wilcoxon_test_and_report(classe_poblenou_df$la_magnitud_activa_entrante,saturday_poblenou_df$la_magnitud_activa_entrante,"Classe","Dissabte")
#wilcoxon_test_and_report(classe_poblenou_df$la_magnitud_activa_entrante,sunday_poblenou_df$la_magnitud_activa_entrante,"Classe","Diumenge")
#wilcoxon_test_and_report(classe_poblenou_df$la_magnitud_activa_entrante,festiu_poblenou_df$la_magnitud_activa_entrante,"Classe","Festiu")
#wilcoxon_test_and_report(classe_poblenou_df$la_magnitud_activa_entrante,benvinguda_poblenou_df$la_magnitud_activa_entrante,"Classe","La benvinguda")
#wilcoxon_test_and_report(classe_poblenou_df$la_magnitud_activa_entrante,no_lectiu_poblenou_df$la_magnitud_activa_entrante,"Classe","No lectiu")
#wilcoxon_test_and_report(classe_poblenou_df$la_magnitud_activa_entrante,vacances_poblenou_df$la_magnitud_activa_entrante,"Classe","Vacances")

#print("Per al dia del tipus 'Altre', hem trobat una diferència significativa amb els següents tipus:")
#wilcoxon_test_and_report(altres_poblenou_df$la_magnitud_activa_entrante,saturday_poblenou_df$la_magnitud_activa_entrante,"Altre","Dissabte")
#wilcoxon_test_and_report(altres_poblenou_df$la_magnitud_activa_entrante,sunday_poblenou_df$la_magnitud_activa_entrante,"Altre","Diumenge")
#wilcoxon_test_and_report(altres_poblenou_df$la_magnitud_activa_entrante,festiu_poblenou_df$la_magnitud_activa_entrante,"Altre","Festiu")
#wilcoxon_test_and_report(altres_poblenou_df$la_magnitud_activa_entrante,benvinguda_poblenou_df$la_magnitud_activa_entrante,"Altre","La benvinguda")
#wilcoxon_test_and_report(altres_poblenou_df$la_magnitud_activa_entrante,no_lectiu_poblenou_df$la_magnitud_activa_entrante,"Altre","No lectiu")
#wilcoxon_test_and_report(altres_poblenou_df$la_magnitud_activa_entrante,vacances_poblenou_df$la_magnitud_activa_entrante,"Altre","Vacances")

#print("Per al dia del tipus 'Dissabte', hem trobat una diferència significativa amb els següents tipus:")
#wilcoxon_test_and_report(saturday_poblenou_df$la_magnitud_activa_entrante,sunday_poblenou_df$la_magnitud_activa_entrante,"Dissabte","Diumenge")
#wilcoxon_test_and_report(saturday_poblenou_df$la_magnitud_activa_entrante,festiu_poblenou_df$la_magnitud_activa_entrante,"Dissabte","Festiu")
#wilcoxon_test_and_report(saturday_poblenou_df$la_magnitud_activa_entrante,benvinguda_poblenou_df$la_magnitud_activa_entrante,"Dissabte","La benvinguda")
#wilcoxon_test_and_report(saturday_poblenou_df$la_magnitud_activa_entrante,no_lectiu_poblenou_df$la_magnitud_activa_entrante,"Dissabte","No lectiu")
#wilcoxon_test_and_report(saturday_poblenou_df$la_magnitud_activa_entrante,vacances_poblenou_df$la_magnitud_activa_entrante,"Dissabte","Vacances")

#print("Per al dia del tipus 'Diumenge', hem trobat una diferència significativa amb els següents tipus:")
#wilcoxon_test_and_report(sunday_poblenou_df$la_magnitud_activa_entrante,festiu_poblenou_df$la_magnitud_activa_entrante,"Diumenge","Festiu")
#wilcoxon_test_and_report(sunday_poblenou_df$la_magnitud_activa_entrante,benvinguda_poblenou_df$la_magnitud_activa_entrante,"Diumenge","La benvinguda")
#wilcoxon_test_and_report(sunday_poblenou_df$la_magnitud_activa_entrante,no_lectiu_poblenou_df$la_magnitud_activa_entrante,"Diumenge","No lectiu")
#wilcoxon_test_and_report(sunday_poblenou_df$la_magnitud_activa_entrante,vacances_poblenou_df$la_magnitud_activa_entrante,"Diumenge","Vacances")

#print("Per al dia del tipus 'Festiu', hem trobat una diferència significativa amb els següents tipus:")
#wilcoxon_test_and_report(festiu_poblenou_df$la_magnitud_activa_entrante,benvinguda_poblenou_df$la_magnitud_activa_entrante,"Festiu","La benvinguda")
#wilcoxon_test_and_report(festiu_poblenou_df$la_magnitud_activa_entrante,no_lectiu_poblenou_df$la_magnitud_activa_entrante,"Festiu","No lectiu")
#wilcoxon_test_and_report(festiu_poblenou_df$la_magnitud_activa_entrante,vacances_poblenou_df$la_magnitud_activa_entrante,"Festiu","Vacances")

print("Per al dia del tipus 'La benvinguda', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(benvinguda_poblenou_df$la_magnitud_activa_entrante,no_lectiu_poblenou_df$la_magnitud_activa_entrante,"La benvinguda","No lectiu")
wilcoxon_test_and_report(benvinguda_poblenou_df$la_magnitud_activa_entrante,vacances_poblenou_df$la_magnitud_activa_entrante,"La benvinguda","Vacances")





























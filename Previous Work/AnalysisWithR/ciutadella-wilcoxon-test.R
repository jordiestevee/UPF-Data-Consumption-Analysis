## (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
#
## Wilcoxon test

print("Per al dia del tipus 'Avaluació', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(avaluacio_ciutadella_df$la_magnitud_activa_entrante,classe_ciutadella_df$la_magnitud_activa_entrante,"Avaluació","Classe")
wilcoxon_test_and_report(avaluacio_ciutadella_df$la_magnitud_activa_entrante,altres_ciutadella_df$la_magnitud_activa_entrante,"Avaluació","Altre")
wilcoxon_test_and_report(avaluacio_ciutadella_df$la_magnitud_activa_entrante,saturday_ciutadella_df$la_magnitud_activa_entrante,"Avaluació","Dissabte")
wilcoxon_test_and_report(avaluacio_ciutadella_df$la_magnitud_activa_entrante,sunday_ciutadella_df$la_magnitud_activa_entrante,"Avaluació","Diumenge")
wilcoxon_test_and_report(avaluacio_ciutadella_df$la_magnitud_activa_entrante,festiu_ciutadella_df$la_magnitud_activa_entrante,"Avaluació","Festiu")
wilcoxon_test_and_report(avaluacio_ciutadella_df$la_magnitud_activa_entrante,benvinguda_ciutadella_df$la_magnitud_activa_entrante,"Avaluació","La benvinguda")
wilcoxon_test_and_report(avaluacio_ciutadella_df$la_magnitud_activa_entrante,no_lectiu_ciutadella_df$la_magnitud_activa_entrante,"Avaluació","No lectiu")
wilcoxon_test_and_report(avaluacio_ciutadella_df$la_magnitud_activa_entrante,vacances_ciutadella_df$la_magnitud_activa_entrante,"Avaluació","Vacances")

print("Per al dia del tipus 'Classe', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(classe_ciutadella_df$la_magnitud_activa_entrante,altres_ciutadella_df$la_magnitud_activa_entrante,"Classe","Altre")
wilcoxon_test_and_report(classe_ciutadella_df$la_magnitud_activa_entrante,saturday_ciutadella_df$la_magnitud_activa_entrante,"Classe","Dissabte")
wilcoxon_test_and_report(classe_ciutadella_df$la_magnitud_activa_entrante,sunday_ciutadella_df$la_magnitud_activa_entrante,"Classe","Diumenge")
wilcoxon_test_and_report(classe_ciutadella_df$la_magnitud_activa_entrante,festiu_ciutadella_df$la_magnitud_activa_entrante,"Classe","Festiu")
wilcoxon_test_and_report(classe_ciutadella_df$la_magnitud_activa_entrante,benvinguda_ciutadella_df$la_magnitud_activa_entrante,"Classe","La benvinguda")
wilcoxon_test_and_report(classe_ciutadella_df$la_magnitud_activa_entrante,no_lectiu_ciutadella_df$la_magnitud_activa_entrante,"Classe","No lectiu")
wilcoxon_test_and_report(classe_ciutadella_df$la_magnitud_activa_entrante,vacances_ciutadella_df$la_magnitud_activa_entrante,"Classe","Vacances")

print("Per al dia del tipus 'Altre', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(altres_ciutadella_df$la_magnitud_activa_entrante,saturday_ciutadella_df$la_magnitud_activa_entrante,"Altre","Dissabte")
wilcoxon_test_and_report(altres_ciutadella_df$la_magnitud_activa_entrante,sunday_ciutadella_df$la_magnitud_activa_entrante,"Altre","Diumenge")
wilcoxon_test_and_report(altres_ciutadella_df$la_magnitud_activa_entrante,festiu_ciutadella_df$la_magnitud_activa_entrante,"Altre","Festiu")
wilcoxon_test_and_report(altres_ciutadella_df$la_magnitud_activa_entrante,benvinguda_ciutadella_df$la_magnitud_activa_entrante,"Altre","La benvinguda")
wilcoxon_test_and_report(altres_ciutadella_df$la_magnitud_activa_entrante,no_lectiu_ciutadella_df$la_magnitud_activa_entrante,"Altre","No lectiu")
wilcoxon_test_and_report(altres_ciutadella_df$la_magnitud_activa_entrante,vacances_ciutadella_df$la_magnitud_activa_entrante,"Altre","Vacances")

print("Per al dia del tipus 'Dissabte', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(saturday_ciutadella_df$la_magnitud_activa_entrante,sunday_ciutadella_df$la_magnitud_activa_entrante,"Dissabte","Diumenge")
wilcoxon_test_and_report(saturday_ciutadella_df$la_magnitud_activa_entrante,festiu_ciutadella_df$la_magnitud_activa_entrante,"Dissabte","Festiu")
wilcoxon_test_and_report(saturday_ciutadella_df$la_magnitud_activa_entrante,benvinguda_ciutadella_df$la_magnitud_activa_entrante,"Dissabte","La benvinguda")
wilcoxon_test_and_report(saturday_ciutadella_df$la_magnitud_activa_entrante,no_lectiu_ciutadella_df$la_magnitud_activa_entrante,"Dissabte","No lectiu")
wilcoxon_test_and_report(saturday_ciutadella_df$la_magnitud_activa_entrante,vacances_ciutadella_df$la_magnitud_activa_entrante,"Dissabte","Vacances")

print("Per al dia del tipus 'Diumenge', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(sunday_ciutadella_df$la_magnitud_activa_entrante,festiu_ciutadella_df$la_magnitud_activa_entrante,"Diumenge","Festiu")
wilcoxon_test_and_report(sunday_ciutadella_df$la_magnitud_activa_entrante,benvinguda_ciutadella_df$la_magnitud_activa_entrante,"Diumenge","La benvinguda")
wilcoxon_test_and_report(sunday_ciutadella_df$la_magnitud_activa_entrante,no_lectiu_ciutadella_df$la_magnitud_activa_entrante,"Diumenge","No lectiu")
wilcoxon_test_and_report(sunday_ciutadella_df$la_magnitud_activa_entrante,vacances_ciutadella_df$la_magnitud_activa_entrante,"Diumenge","Vacances")

print("Per al dia del tipus 'Festiu', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(festiu_ciutadella_df$la_magnitud_activa_entrante,benvinguda_ciutadella_df$la_magnitud_activa_entrante,"Festiu","La benvinguda")
wilcoxon_test_and_report(festiu_ciutadella_df$la_magnitud_activa_entrante,no_lectiu_ciutadella_df$la_magnitud_activa_entrante,"Festiu","No lectiu")
wilcoxon_test_and_report(festiu_ciutadella_df$la_magnitud_activa_entrante,vacances_ciutadella_df$la_magnitud_activa_entrante,"Festiu","Vacances")

print("Per al dia del tipus 'La benvinguda', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(benvinguda_ciutadella_df$la_magnitud_activa_entrante,no_lectiu_ciutadella_df$la_magnitud_activa_entrante,"La benvinguda","No lectiu")
wilcoxon_test_and_report(benvinguda_ciutadella_df$la_magnitud_activa_entrante,vacances_ciutadella_df$la_magnitud_activa_entrante,"La benvinguda","Vacances")

print("Per al dia del tipus 'No lectiu', hem trobat una diferència significativa amb els següents tipus:")
wilcoxon_test_and_report(no_lectiu_ciutadella_df$la_magnitud_activa_entrante,vacances_ciutadella_df$la_magnitud_activa_entrante,"Mo lectiu","Vacances")




























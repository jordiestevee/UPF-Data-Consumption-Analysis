# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
## I know the siluette coefficient gave 2 clusters, so I define 2 constant functions
constant_vector_c_1 = rep(clusters$centers[1], times = 10)
constant_vector_c_2 = rep(clusters$centers[2], times = 10)
median_ciutadella_altres = rep(mean(altres_ciutadella_df$la_magnitud_activa_entrante), times = 10)
median_ciutadella_avaluacio = rep(mean(avaluacio_ciutadella_df$la_magnitud_activa_entrante), times = 10)
median_ciutadella_classe = rep(mean(classe_ciutadella_df$la_magnitud_activa_entrante), times = 10)
median_ciutadella_dissabte = rep(mean(saturday_ciutadella_df$la_magnitud_activa_entrante), times = 10)
median_ciutadella_diumenge = rep(mean(sunday_ciutadella_df$la_magnitud_activa_entrante), times = 10)
median_ciutadella_festiu = rep(mean(festiu_ciutadella_df$la_magnitud_activa_entrante), times = 10)
median_ciutadella_benvinguda = rep(mean(benvinguda_ciutadella_df$la_magnitud_activa_entrante), times = 10)
median_ciutadella_no_lectiu = rep(mean(no_lectiu_ciutadella_df$la_magnitud_activa_entrante), times = 10)
median_ciutadella_vacances = rep(mean(vacances_ciutadella_df$la_magnitud_activa_entrante), times = 10)

for_plot_ciutadella_cluster_medians<- data.frame(
	index = 1:10,
	cluster_1 = constant_vector_c_1,
	cluster_2 = constant_vector_c_2,
	altres= median_ciutadella_altres,
	avaluacio= median_ciutadella_avaluacio,
	classe= median_ciutadella_classe,
	dissabte= median_ciutadella_dissabte,
	diumenge= median_ciutadella_diumenge,
	festiu= median_ciutadella_festiu,
	benvinguda= median_ciutadella_benvinguda,
	no_lectiu= median_ciutadella_no_lectiu,
	vacances= median_ciutadella_vacances
)

plot(for_plot_ciutadella_cluster_medians$index,
	 for_plot_ciutadella_cluster_medians$cluster_1, type = "o", col = "black", lty="dashed", ylim = c(395, 970) ,
	xlab="", ylab="consum mitja per tipus de dia vs cluster proposat") 
        lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$cluster_2, type = "o", col = "black", lty="dashed")
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$altres, type = "b", pch = 4, col = "black", lty="solid")
	text(x = 1, y = for_plot_ciutadella_cluster_medians$altres[1], labels = "Altres", col = "black", pos = 4) # pos=4 for right alignment
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$avaluacio, type = "b", pch = 4, col = "#B0C4DE", lty="solid")
	text(x = 2, y = for_plot_ciutadella_cluster_medians$avaluacio[2], labels = "Avaluacio", col = "#B0C4DE", pos = 4) # pos=4 for right alignment
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$classe, type = "b", pch = 4, col = "gray", lty="solid")
	text(x = 4, y = for_plot_ciutadella_cluster_medians$classe[3], labels = "Classe", col = "gray", pos = 4) # pos=4 for right alignment
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$dissabte, type = "b", pch = 4, col = "black", lty="solid")
	text(x = 3, y = for_plot_ciutadella_cluster_medians$dissabte[4], labels = "Dissabte", col = "black", pos = 4) # pos=4 for right alignment
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$diumenge, type = "b", pch = 4, col = "#B22222", lty="solid")
	text(x = 5, y = for_plot_ciutadella_cluster_medians$diumenge[5], labels = "Diumenge", col = "#B22222", pos = 4) # pos=4 for right alignment
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$festiu, type = "b", pch = 4, col = "#B22222", lty="solid")
	text(x = 9, y = for_plot_ciutadella_cluster_medians$festiu[6], labels = "Festiu", col = "#B22222", pos = 4) # pos=4 for right alignment
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$benvinguda, type = "b", pch = 4, col = "pink", lty="solid")
	text(x = 7, y = for_plot_ciutadella_cluster_medians$benvinguda[7], labels = "La benvinguda", col = "pink", pos = 4) # pos=4 for right alignment
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$no_lectiu, type = "b", pch = 4, col = "orange", lty="solid")
	text(x = 8, y = for_plot_ciutadella_cluster_medians$no_lectiu[8], labels = "No lectiu", col = "orange", pos = 4) # pos=4 for right alignment
         lines(for_plot_ciutadella_cluster_medians$index, for_plot_ciutadella_cluster_medians$vacances, type = "b", pch = 4, col = "#F0E68C", lty="solid")
	text(x = 9, y = for_plot_ciutadella_cluster_medians$vacances[9], labels = "Vacances", col = "#F0E68C", pos = 4) # pos=4 for right alignment



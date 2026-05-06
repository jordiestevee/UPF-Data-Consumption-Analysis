# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
## I know the siluette coefficient gave 2 clusters, so I define 2 constant functions
constant_vector_c_1 = rep(clusters$centers[1], times = 10)
constant_vector_c_2 = rep(clusters$centers[2], times = 10)
median_poblenou_altres = rep(mean(altres_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_avaluacio = rep(mean(avaluacio_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_classe = rep(mean(classe_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_dissabte = rep(mean(saturday_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_diumenge = rep(mean(sunday_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_festiu = rep(mean(festiu_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_benvinguda = rep(mean(benvinguda_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_no_lectiu = rep(mean(no_lectiu_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_vacances = rep(mean(vacances_poblenou_df$la_magnitud_activa_entrante), times = 10)

for_plot_poblenou_cluster_medians<- data.frame(
	index = 1:10,
	cluster_1 = constant_vector_c_1,
	cluster_2 = constant_vector_c_2,
	altres= median_poblenou_altres,
	avaluacio= median_poblenou_avaluacio,
	classe= median_poblenou_classe,
	dissabte= median_poblenou_dissabte,
	diumenge= median_poblenou_diumenge,
	festiu= median_poblenou_festiu,
	benvinguda= median_poblenou_benvinguda,
	no_lectiu= median_poblenou_no_lectiu,
	vacances= median_poblenou_vacances
)

plot(for_plot_poblenou_cluster_medians$index,
	main="Poblenou: Emparellament dels dos clústers trobats (amb valors atípics)", 
	 for_plot_poblenou_cluster_medians$cluster_1, type = "o", col = "black", lty="dashed", ylim = c(95, 270) ,
	xlab="", ylab="consum mitja per tipus de dia vs cluster proposat") 
        lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$cluster_2, type = "o", col = "black", lty="dashed")
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$altres, type = "b", pch = 4, col = "black", lty="solid")
	text(x = 1, y = for_plot_poblenou_cluster_medians$altres[1], labels = "Altres", col = "black", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$avaluacio, type = "b", pch = 4, col = "#B0C4DE", lty="solid")
	text(x = 2, y = for_plot_poblenou_cluster_medians$avaluacio[2], labels = "Avaluacio", col = "#B0C4DE", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$classe, type = "b", pch = 4, col = "gray", lty="solid")
	text(x = 4, y = for_plot_poblenou_cluster_medians$classe[3], labels = "Classe", col = "gray", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$dissabte, type = "b", pch = 4, col = "black", lty="solid")
	text(x = 3, y = for_plot_poblenou_cluster_medians$dissabte[4], labels = "Dissabte", col = "black", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$diumenge, type = "b", pch = 4, col = "#B22222", lty="solid")
	text(x = 5, y = for_plot_poblenou_cluster_medians$diumenge[5], labels = "Diumenge", col = "#B22222", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$festiu, type = "b", pch = 4, col = "#B22222", lty="solid")
	text(x = 9, y = for_plot_poblenou_cluster_medians$festiu[6], labels = "Festiu", col = "#B22222", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$benvinguda, type = "b", pch = 4, col = "pink", lty="solid")
	text(x = 7, y = for_plot_poblenou_cluster_medians$benvinguda[7], labels = "La benvinguda", col = "pink", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$no_lectiu, type = "b", pch = 4, col = "orange", lty="solid")
	text(x = 8, y = for_plot_poblenou_cluster_medians$no_lectiu[8], labels = "No lectiu", col = "orange", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$vacances, type = "b", pch = 4, col = "#F0E68C", lty="solid")
	text(x = 9, y = for_plot_poblenou_cluster_medians$vacances[9], labels = "Vacances", col = "#F0E68C", pos = 4) # pos=4 for right alignment



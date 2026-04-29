# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu

get_without_outliers <- function (a_frame){
    Q1 <- quantile(a_frame$la_magnitud_activa_entrante, .25,na.rm = TRUE )
    Q3 <- quantile(a_frame$la_magnitud_activa_entrante, .75, na.rm = TRUE)
    IQR <- Q3 - Q1

    lower_bound <- Q1 - 1.5 * IQR
    upper_bound <- Q3 + 1.5 * IQR

    return( subset(a_frame,a_frame$la_magnitud_activa_entrante >= lower_bound & a_frame$la_magnitud_activa_entrante <= upper_bound))

}

classe_poblenou_without_outliers <- get_without_outliers(classe_poblenou_df)
saturday_poblenou_without_outliers <- get_without_outliers(saturday_poblenou_df)
sunday_poblenou_without_outliers <- get_without_outliers(sunday_poblenou_df)
festiu_poblenou_without_outliers <- get_without_outliers(festiu_poblenou_df)
day_types_without_outliers <- magnitud_activa_per_UPF_per_hora_Poblenou[
	magnitud_activa_per_UPF_per_hora_Poblenou$es_classe==FALSE
	& magnitud_activa_per_UPF_per_hora_Poblenou$es_dissabte==FALSE
	& magnitud_activa_per_UPF_per_hora_Poblenou$es_diumenge==FALSE
	& magnitud_activa_per_UPF_per_hora_Poblenou$es_festiu==FALSE
	,]

magnitud_activa_per_UPF_per_hora_Poblenou_without_outliers <- rbind(
	classe_poblenou_without_outliers,
	saturday_poblenou_without_outliers,
	sunday_poblenou_without_outliers,
	festiu_poblenou_without_outliers,
	day_types_without_outliers)

############ we cluster again, but the outliers have been filtered out
dist_matrix <- dist(magnitud_activa_per_UPF_per_hora_Poblenou_without_outliers$la_magnitud_activa_entrante)
sils <- rep(0,8)
for (k in 2:9) {
  clus <- kmeans(magnitud_activa_per_UPF_per_hora_Poblenou_without_outliers$la_magnitud_activa_entrante, k, nstart = 20)
  sil <- silhouette(clus$cluster,dist_matrix)
  sils[k-1] <- summary(sil)$avg.width
}

plot_dat <- data.frame(
  k = 2:9,
  silhouette_criterion = sils
)
#
plot(plot_dat$k, plot_dat$silhouette_criterion, xlab="Nombre de clústers (sense atipics)", ylab="coeficient de silueta")

max_silhouette <- plot_dat[which.max(plot_dat$silhouette_criterion), ]
print(max_silhouette)

clusters_without_outliers <- kmeans(magnitud_activa_per_UPF_per_hora_Poblenou_without_outliers$la_magnitud_activa_entrante, max_silhouette$k, nstart = 20)

### I know it game me 7 clusters, so I define 7 constant functions
constant_vector_c_1 = rep(clusters_without_outliers$centers[1], times = 10)
constant_vector_c_2 = rep(clusters_without_outliers$centers[2], times = 10)
# we do not replicate are the original data if it has no outliers, we do not replicate
#median_poblenou_altres = rep(mean(altres_poblenou_df$la_magnitud_activa_entrante), times = 10)
#median_poblenou_avaluacio = rep(mean(avaluacio_poblenou_df$la_magnitud_activa_entrante), times = 10)
median_poblenou_classe = rep(mean(classe_poblenou_without_outliers$la_magnitud_activa_entrante), times = 10)
median_poblenou_dissabte = rep(mean(saturday_poblenou_without_outliers$la_magnitud_activa_entrante), times = 10)
median_poblenou_diumenge = rep(mean(sunday_poblenou_without_outliers$la_magnitud_activa_entrante), times = 10)
median_poblenou_festiu = rep(mean(festiu_poblenou_without_outliers$la_magnitud_activa_entrante), times = 10)
#median_poblenou_benvinguda = rep(mean(benvinguda_poblenou_df$la_magnitud_activa_entrante), times = 10)
#median_poblenou_no_lectiu = rep(mean(no_lectiu_poblenou_df$la_magnitud_activa_entrante), times = 10)
#median_poblenou_vacances = rep(mean(vacances_poblenou_df$la_magnitud_activa_entrante), times = 10)
#
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
	main="Poblenou: Emparellament dels dos clústers trobats (sense valors atípics)",
	 for_plot_poblenou_cluster_medians$cluster_1, type = "o", col = "black", lty="dashed", ylim = c(95, 270) ,
	xlab="", ylab="consum mitja per tipus de dia vs cluster proposat") 
        lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$cluster_2, type = "o", col = "black", lty="dashed")
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$altres, type = "b", pch = 4, col = "black", lty="solid")
	text(x = 1, y = for_plot_poblenou_cluster_medians$altres[9], labels = "Altres", col = "black", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$avaluacio, type = "b", pch = 4, col = "#B0C4DE", lty="solid")
	text(x = 2, y = for_plot_poblenou_cluster_medians$avaluacio[9], labels = "Avaluacio", col = "#B0C4DE", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$classe, type = "b", pch = 4, col = "gray", lty="solid")
	text(x = 4, y = for_plot_poblenou_cluster_medians$classe[9], labels = "Classe", col = "gray", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$dissabte, type = "b", pch = 4, col = "black", lty="solid")
	text(x = 3, y = for_plot_poblenou_cluster_medians$dissabte[9], labels = "Dissabte", col = "black", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$diumenge, type = "b", pch = 4, col = "#B22222", lty="solid")
	text(x = 5, y = for_plot_poblenou_cluster_medians$diumenge[9], labels = "Diumenge", col = "#B22222", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$festiu, type = "b", pch = 4, col = "#B22222", lty="solid")
	text(x = 9, y = for_plot_poblenou_cluster_medians$festiu[9], labels = "Festiu", col = "#B22222", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$benvinguda, type = "b", pch = 4, col = "pink", lty="solid")
	text(x = 7, y = for_plot_poblenou_cluster_medians$benvinguda[9], labels = "La benvinguda", col = "pink", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$no_lectiu, type = "b", pch = 4, col = "orange", lty="solid")
	text(x = 8, y = for_plot_poblenou_cluster_medians$no_lectiu[9], labels = "No lectiu", col = "orange", pos = 4) # pos=4 for right alignment
         lines(for_plot_poblenou_cluster_medians$index, for_plot_poblenou_cluster_medians$vacances, type = "b", pch = 4, col = "#F0E68C", lty="solid")
	text(x = 9, y = for_plot_poblenou_cluster_medians$vacances[9], labels = "Vacances", col = "#F0E68C", pos = 4) # pos=4 for right alignment



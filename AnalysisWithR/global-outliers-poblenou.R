# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu


## build the clusters

clusters <- kmeans(magnitud_activa_per_UPF_per_hora_Poblenou$la_magnitud_activa_entrante, 2, nstart = 20)

magnitud_activa_per_UPF_per_hora_Poblenou$clusters_boundary <- (clusters$centers[1] + clusters$centers[2])/2


year_plot_function( magnitud_activa_per_UPF_per_hora_Poblenou, 
	"Campus Poblenou : Vista Total de l'any 2024 (mediana per dia)",TRUE)

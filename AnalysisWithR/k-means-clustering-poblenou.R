# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu

set.seed(123)
possible_clusters_2<- kmeans(magnitud_activa_per_UPF_per_hora_Poblenou$la_magnitud_activa_entrante,
	 2, iter.max = 10, nstart = 10)

#plot_func(magnitud_activa_per_UPF_per_hora_Poblenou$la_magnitud_activa_entrante, possible_clusters_2$cluster, title = "k-means clustering result")

possible_clusters_2$tot.withinss

possible_clusters_2<- kmeans(magnitud_activa_per_UPF_per_hora_Poblenou$la_magnitud_activa_entrante,
	 2, iter.max = 10, nstart = 20)

dist_matrix <- dist(magnitud_activa_per_UPF_per_hora_Poblenou$la_magnitud_activa_entrante)

sil <- silhouette(possible_clusters_2$cluster, dist_matrix)

sils <- rep(0,8)
for (k in 2:9) {
  clus <- kmeans(magnitud_activa_per_UPF_per_hora_Poblenou$la_magnitud_activa_entrante, k, nstart = 20)
  sil <- silhouette(clus$cluster,dist_matrix)
  sils[k-1] <- summary(sil)$avg.width
}

plot_dat <- data.frame(
  k = 2:9,
  silhouette_criterion = sils
)
#
plot(plot_dat$k, plot_dat$silhouette_criterion, xlab="Nombre de clústers", ylab="coeficient de silueta")

max_silhouette <- plot_dat[which.max(plot_dat$silhouette_criterion), ]
print(max_silhouette)

clusters <- kmeans(magnitud_activa_per_UPF_per_hora_Poblenou$la_magnitud_activa_entrante, max_silhouette$k, nstart = 20)

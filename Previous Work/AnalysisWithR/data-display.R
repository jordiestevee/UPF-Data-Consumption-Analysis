# (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
UPFbyHourCiutadella <- read.table("../data/2025_05_05/Medidas_b49c4/ES0031405997616001GX.csv", header = TRUE, sep = ";")
print(paste("Numero de files llegides:", nrow(UPFbyHourCiutadella)))
print("Data headers:")
colnames(UPFbyHourCiutadella)
######### Validate data
if (any(is.na(UPFbyHourCiutadella$Fecha.y.hora.de.la.medida)) ) {
	print("Valors incomplets a UPFbyHourCiutadella$Fecha.y.hora.de.la.medida")
} else {
	print("Columna UPFbyHourCiutadella$Fecha.y.hora.de.la.medida està complet")
}
if (any(is.na(UPFbyHourCiutadella$Medida.de.la.magnitud.Activa.Entrante..neta.))) {
        print("Valors incomplets a UPFbyHourCiutadella$Medida.de.la.magnitud.Activa.Entrante..neta.")
} else {
        print("Columna UPFbyHourCiutadella$Medida.de.la.magnitud.Activa.Entrante..neta. està complet")
}
# approximate position of the months
month = 24*30;
months_of_the_year = c("gener", "febrer", "març", "abril", "maig", "juny", "juliol", "agost", "setembre", "octubre", "novembre", "desembre")
# test plot
# plot fails, there seems to me missing values
plot(1:nrow(UPFbyHourCiutadella), UPFbyHourCiutadella$Medida.de.la.magnitud.Activa.Entrante..neta.,
     main = "Campus Ciudadella : Vista Total de l'any 2024 (dades per hora)",
     xaxt="n",
     xlab = "per dia",
     ylab = "Mesura de la magnitud Activa Entrant (net)")

axis(1, at = seq(month/2, nrow(UPFbyHourCiutadella), by = month), labels = months_of_the_year ) 

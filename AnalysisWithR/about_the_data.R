# about_the_data.R
message("(c) Vladimir Estivill-Castro")
# campus Ciudadella dades  hora
UPF_per_hora_Ciudadella <- read.table("../../data/2025_05_05/Medidas_b49c4/ES0031405997616001GX.csv", header = TRUE, sep = ";")
files_UPF_per_hora_Ciudadella <-nrow(UPF_per_hora_Ciudadella)
print(paste("UPF per hora Ciudadella, ","numero de files llegides:", files_UPF_per_hora_Ciudadella ))
# campus Poble Nou  dades per  hora
UPF_per_hora_Poblenou <- read.table("../../data/2025_05_05/Medidas_b49c4/ES0031408318021001RP.csv", header = TRUE, sep = ";")
print(paste("UPF per hora Poblenou, ","numero de files llegides:", nrow(UPF_per_hora_Poblenou)))
# campus Ciudadella dades  hora
UPF_per_quart_Ciudadella <- read.table("../../data/2025_05_05/Medidas_8f09e/ES0031405997616001GX.csv", header = TRUE, sep = ";")
print(paste("UPF per quart Ciudadella, ","numero de files llegides:", nrow(UPF_per_quart_Ciudadella)))
# campus Poble Nou  dades per  hora
UPF_per_quart_Poblenou <- read.table("../../data/2025_05_05/Medidas_8f09e/ES0031405997616001GX.csv", header = TRUE, sep = ";")
print(paste("UPF_per_quart_Poblenou, ","numero de files llegides:", nrow(UPF_per_quart_Poblenou)))

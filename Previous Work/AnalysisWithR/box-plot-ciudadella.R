## (c) 2025 Vladimir Estivill-castro vladimir.estivill@upf.edu
#
#
selected_daily_median= magnitud_activa_per_UPF_per_hora_Ciudadella$la_magnitud_activa_entrante
selected_day_type = calendari_corregit$tipus_dia
selected_date = magnitud_activa_per_UPF_per_hora_Poblenou$la_data
for_box_plot_UPF_per_hora_Ciudadella <- data.frame(
	the_date =selected_date,
	daily_median=as.numeric(selected_daily_median),
	day_type=selected_day_type
)
#
boxplot(daily_median~day_type,data=for_box_plot_UPF_per_hora_Ciudadella, main="Ciudadella, tipus de dia",
	col=calendar_colors,
	names= factor_names,
	width=c(1.0,1.0,1.2,1.0,1.5,1.0,2.0,1.2,1.5),las=2,
	 xlab="", ylab="Magnitut")
#
#


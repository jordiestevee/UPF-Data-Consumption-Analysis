# read_calendar.R
message("(c) Vladimir Estivill-Castro")

calendari_corregit$tipus_dia <- factor(calendari_corregit$tipus_dia)
calendar_colors <- c("white","#B0C4DE","gray","white","#B22222","#B22222","pink","orange","#F0E68C")

factor_table <- table(calendari_corregit$tipus_dia)
df_from_table <- as.data.frame(factor_table)
factor_names <- df_from_table$Var1

barplot(factor_table,
            xlab = "",      # Label for the x-axis
            ylab = "numero de dies",     # Label for the y-axis
            main = "Tipus de dia al calendari 2024",  # Title of the chart
	    col=calendar_colors,
	    names.arg = factor_names, cex.names = 0.7, 
	    width=c(10,10,12,10,15,10,20,12,15), 
		#las = 2,
           )



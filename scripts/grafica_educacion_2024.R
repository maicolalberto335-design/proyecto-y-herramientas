# Grupo 9: gráfica exploratoria de educación 2024, generada desde CSV
# Ejecutar desde la raíz del proyecto o dentro de un chunk Quarto.
ruta <- "datos/indicadores_ecv_2024.csv"
if (!file.exists(ruta)) stop("Falta archivo: ", ruta)
d <- read.csv(ruta, fileEncoding="UTF-8-BOM", check.names=FALSE, stringsAsFactors=FALSE)
req <- c("comuna","indicador","porcentaje_ponderado")
if (!all(req %in% names(d))) stop("Columnas requeridas ausentes")
a <- d[d$comuna=="San Javier (13)",req[2:3]]
b <- d[d$comuna=="El Poblado (14)",req[2:3]]
if (nrow(a)!=3L || nrow(b)!=3L || anyDuplicated(a$indicador) || anyDuplicated(b$indicador)) stop("Se requieren tres indicadores únicos por comuna")
x <- merge(a,b,by="indicador",suffixes=c("_sj","_ep"))
if (anyNA(x$porcentaje_ponderado_sj) || anyNA(x$porcentaje_ponderado_ep)) stop("Porcentajes ausentes")
if (nrow(x)!=3) stop("Se esperaban tres indicadores emparejados")
x$brecha_pp <- x$porcentaje_ponderado_ep-x$porcentaje_ponderado_sj
x <- x[order(x$brecha_pp),]
dir.create("figuras",showWarnings=FALSE)
png("figuras/brechas_educacion_2024.png",width=1500,height=950,res=160)
par(mar=c(5,22,4,2))
barplot(x$brecha_pp,names.arg=x$indicador,horiz=TRUE,las=1,
        xlab="Brecha (puntos porcentuales): El Poblado - San Javier",
        main="Indicadores educativos, ECV 2024",col="gray40",
        xlim=c(0,max(x$brecha_pp)*1.2))
mtext("Fuente: ECV 2024, DAP Medellín; cálculos exploratorios del Grupo 9 con FEP. No son puntajes del IMCV.",side=1,line=3.5,cex=.62)
dev.off()
print(x[,c("indicador","brecha_pp")])

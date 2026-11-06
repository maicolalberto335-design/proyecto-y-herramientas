# Grupo 9: validación y visualización de brechas dimensionales
# Ejecutar desde la raíz del repositorio: Rscript scripts/analisis_imcv.R
ruta <- "datos/dimensiones_2023_2024.csv"
if (!file.exists(ruta)) stop("No se encontró ", ruta)
d <- read.csv(ruta, stringsAsFactors=FALSE, fileEncoding="UTF-8")
columnas <- c("anio","dimension","san_javier","el_poblado")
if (!all(columnas %in% names(d))) stop("Columnas faltantes: ",paste(setdiff(columnas,names(d)),collapse=", "))
if (nrow(d)==0L) {
  message("PENDIENTE: faltan los puntajes dimensionales oficiales homologables de 2023 y 2024. No se produce una gráfica ficticia.")
} else {
  d$anio <- suppressWarnings(as.integer(d$anio))
  d$san_javier <- suppressWarnings(as.numeric(d$san_javier))
  d$el_poblado <- suppressWarnings(as.numeric(d$el_poblado))
  if (anyNA(d[,columnas]) || any(!nzchar(trimws(d$dimension)))) stop("Datos vacíos o no numéricos")
  if (nrow(d)!=20L || !setequal(d$anio,c(2023L,2024L))) stop("Se esperan exactamente 10 dimensiones por cada año")
  if (anyDuplicated(d[,c("anio","dimension")])) stop("Dimensión repetida")
  if (!setequal(d$dimension[d$anio==2023],d$dimension[d$anio==2024])) stop("Las dimensiones difieren entre años")
  if (!requireNamespace("ggplot2",quietly=TRUE)) stop("Instale ggplot2 con install.packages('ggplot2')")
  d$brecha <- d$el_poblado-d$san_javier
  dir.create("figuras",showWarnings=FALSE)
  write.csv(d,"datos/brechas_calculadas.csv",row.names=FALSE,fileEncoding="UTF-8")
  p <- ggplot2::ggplot(d,ggplot2::aes(x=dimension,y=brecha,fill=factor(anio)))+
    ggplot2::geom_col(position="dodge")+ggplot2::coord_flip()+
    ggplot2::labs(title="Brecha por dimensión del IMCV",subtitle="El Poblado menos San Javier",x="Dimensión",y="Diferencia en puntos dimensionales",fill="Año",caption="Fuente: DAP Medellín, IMCV 2023–2024; elaboración Grupo 9 en R. Verificar comparabilidad.")+
    ggplot2::theme_minimal(base_size=11)
  ggplot2::ggsave("figuras/brechas_dimensiones.png",plot=p,width=10,height=7,dpi=160)
  print(p)
  for (a in c(2023,2024)) {
    z <- d[d$anio==a,]
    m <- z[which.max(z$brecha),]
    message(a,": mayor brecha positiva: ",m$dimension," = ",round(m$brecha,2))
  }
}

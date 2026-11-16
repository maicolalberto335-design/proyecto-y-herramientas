
ruta <- "datos/encuesta_2024.xlsx"
if (!file.exists(ruta)) ruta <- "encuesta_2024.xlsx"
d <- readxl::read_excel(ruta)
comuna <- as.numeric(d[["A.7"]]); edad <- as.numeric(d[["B.6"]])
peso <- as.numeric(d[["FEP"]]); e1 <- as.numeric(d[["E.1"]])
e2 <- as.numeric(d[["E.2"]]); e6 <- as.numeric(d[["E.6"]])
porcentaje <- function(c, universo, valido, si) {
  i <- which(comuna == c & universo & valido & is.finite(peso) & peso > 0)
  100 * sum(peso[i] * si[i]) / sum(peso[i])
}
calcular <- function(c) c(
  porcentaje(c, edad >= 15, e1 %in% 1:2, e1 == 1),
  porcentaje(c, edad >= 5 & edad <= 24, e2 %in% 1:2, e2 == 1),
  porcentaje(c, edad >= 25 & edad <= 64, e6 %in% 0:11, e6 %in% 6:10))
a <- calcular(13); b <- calcular(14)
brecha <- round(b, 2) - round(a, 2)
par(mar = c(5, 12, 2, 1))
barplot(brecha, names.arg = c("Alfabetismo (15+)", "Asistencia (5–24)",
  "Superior (25–64)"), horiz = TRUE, las = 1, col = "gray45",
  xlim = c(0, 75), xlab = "Brecha (puntos porcentuales)")

print(rbind(San_Javier=a, El_Poblado=b, Brecha=brecha))

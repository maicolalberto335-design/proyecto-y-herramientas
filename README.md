# Diferencias en las condiciones de vida entre las comunas 13 y 14 de Medellín

Grupo 9 — Maicol Ramírez, Samuel Hincapié y Mariana Martínez.

## Descargar y abrir

En este repositorio, seleccionar **Code > Download ZIP**, extraer el ZIP completo y abrir `estudio_comunas.qmd` en RStudio. Conservar las carpetas `datos/` y `scripts/` junto al QMD y a `bibliografia.bib`. No ejecutar el documento dentro del ZIP.

También puede descargarse con Git:

```bash
git clone https://github.com/maicolalberto335-design/proyecto-y-herramientas.git
cd proyecto-y-herramientas
```

## Requisitos

Instalar R, RStudio, Quarto y una distribución LaTeX con XeLaTeX. Instalar la fuente **Tinos**, requerida por el QMD; no sustituirla si se desea conservar la presentación del PDF. La distribución LaTeX debe disponer de `pdflscape` y `booktabs`.

En la consola de R:

```r
install.packages(c("readxl", "knitr", "rmarkdown"))
```

Si no se dispone de LaTeX, puede instalarse TinyTeX desde la terminal:

```bash
quarto install tinytex
```

## Generar el documento

En RStudio, abrir el QMD y seleccionar **Render PDF**. Como alternativa, ejecutar en la terminal desde la raíz del repositorio:

```bash
quarto render estudio_comunas.qmd --to pdf
```

El QMD lee `datos/encuesta_2024.xlsx` y `bibliografia.bib`; la gráfica se calcula dentro del propio documento. No necesita el HTML ni los CSV de versiones anteriores. La compilación puede generar archivos auxiliares y sobrescribe `estudio_comunas.pdf`; conservar una copia si se desea comparar con el PDF entregado.

## Comprobar resultados

Desde la raíz del repositorio, en R:

```r
source("scripts/brechas_educativas.R")
```

Para las comprobaciones independientes, instalar Python 3 y ejecutar:

```bash
python -m pip install openpyxl
python scripts/comprobar_2023.py
python scripts/comprobar_indicadores.py
```

En algunos sistemas el comando es `python3`. La comprobación de 2023 lee los dos libros IMCV; la de 2024 lee la encuesta y genera `datos/indicadores_calculados.csv` como salida auxiliar, que no se necesita para compilar el QMD.

## Archivos de la entrega

- `estudio_comunas.pdf`: PDF definitivo generado por el grupo desde Quarto en RStudio, de 11 páginas (8 de artículo, 1 de referencias y 2 de anexos).
- `estudio_comunas.qmd`: fuente del artículo y código de la gráfica.
- `bibliografia.bib`: referencias bibliográficas.
- `datos/imcv_dimensiones_2023.xlsx`: indicadores de las dimensiones de 2023.
- `datos/imcv_resultados_2023.xlsx`: resultados del IMCV de 2023.
- `datos/encuesta_2024.xlsx`: microdatos de la ECV 2024.
- `datos/diccionario_2024.xlsx`: diccionario de variables de la ECV 2024.
- `scripts/brechas_educativas.R`: cálculo y gráfica educativa.
- `scripts/comprobar_indicadores.py`: comprobación de los indicadores de 2024.
- `scripts/comprobar_2023.py`: comprobación de los resultados de 2023.

El PDF definitivo se conserva sin modificar. La compilación completa requiere el entorno R/Quarto/LaTeX descrito; no se ha ejecutado una nueva compilación durante la organización del repositorio.

Los certificados de Biblioteca y LaTeX se entregaron previamente durante el semestre y están mencionados en el cuadro de herramientas del artículo.

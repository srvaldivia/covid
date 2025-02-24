# 0. load packages --------------------------------------------------------
pacman::p_load(tidyverse, cli, httr, fs)
cli_alert_info("Paquetes cargados: {.pkg {rev(pacman::p_loaded())}}",
               wrap = TRUE)



# 1. Download datasets from min. ciencia ----------------------------------
# (https://observa.minciencia.gob.cl/datos-abiertos/datos-del-repositorio-covid-19)

## 1.1 Define URL ----
url_descarga <- "https://api.observa.minciencia.gob.cl/api/datosabiertos/download/?uuid=e26a2360-6447-47bc-8535-9b443fdff6e1&filename=datos-covid-19.zip"


## 1.2 Create temporal directory and download file ----
temp_dir <- tempdir()
temp_file <- file.path(temp_dir, "archivo.zip")
GET(url_descarga, write_disk(temp_file, overwrite = TRUE))


## 1.3 Unzip downloaded file ----
unzip(temp_file, exdir = temp_dir)
# z7path = shQuote('C:/Program Files/7-Zip/7z')
# cmd = paste(z7path, ' e ', temp_file, ' -ir!*.* -o', '"', temp_dir, '"', sep='')
# system(cmd)


## 1.4 Copy dataset to project directory ----
datos_covid <-
  list.files(
    temp_dir,
    pattern = "TotalesNacionales.csv",
    recursive = TRUE,
    full.names = TRUE
  )
file.copy(from = datos_covid, to = "TotalesNacionales.csv", overwrite = TRUE)
unlink(temp_dir, recursive = TRUE, force = TRUE)
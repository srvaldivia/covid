# 0. load packages --------------------------------------------------------
pacman::p_load(tidyverse, cli, httr, fs)
cli_alert_info("Paquetes cargados: {.pkg {rev(pacman::p_loaded())}}",
               wrap = TRUE)
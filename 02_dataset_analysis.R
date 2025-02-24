# 0. paquetes -------------------------------------------------------------
library(tidyverse)
library(ggformula)
library(classInt)


# 1. Carga de datos -------------------------------------------------------
covid_original <- read_csv("datos-covid-19/producto5/TotalesNacionales.csv")


# 2. Transformar datos (filtrar, pivotear y coercionar) -------------------
covid_procesados <- covid_original  |>  
  filter(Fecha == "Casos nuevos totales") |> 
  pivot_longer(cols = `2020-03-02`:last_col(),
               names_to = "fecha",
               values_to = "casos_nuevos_dia") |>
  rename(tipo = Fecha) |> 
  mutate(fecha = as_date(fecha))



# 3. Plots ----------------------------------------------------------------

## 3.1 Casos nuevos por día ----
ggplot(data = covid_procesados,
       mapping = aes(x = fecha,
                     y = casos_nuevos_dia)) +
  geom_point(colour = "#3A5FCD",
             alpha = 0.8) +
  geom_spline(size = 1.5,
              spar = 0,
              colour = "#CD2990") +
  labs(y = "Casos nuevos COVID + \n",
       x = NULL) +
  theme_minimal()


# ´modificar títulos a ejes
ggplot(data = datos_procesados,
       aes(x = fecha,
           y = casos_nuevos_d)) +
  geom_point(colour = "#3A5FCD",
             alpha = 0.8) +
  labs(y = "Casos nuevos COVID + \n",
       x = NULL)


# agregamos línea de tendencia
ggplot(data = datos_procesados,
       aes(x = fecha,
           y = casos_nuevos_d)) +
  geom_point(colour = "#3A5FCD",
             alpha = 0.8) +
  geom_spline(size = 1.5,
              spar = 0,
              colour = "#CD2990") +
  labs(y = "Casos nuevos COVID + \n",
       x = NULL)
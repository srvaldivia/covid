# 0. load packages --------------------------------------------------------
pacman::p_load(tidyverse, ggformula, classInt, cli)
cli_alert_info("Paquetes cargados: {.pkg {rev(pacman::p_loaded())}}",
               wrap = TRUE)


# 1. Carga de datos -------------------------------------------------------
covid_original <- read_csv("TotalesNacionales.csv")


# 2. Transformar datos (filtrar, pivotear y coercionar) -------------------
covid_procesados <- covid_original  |>  
  filter(Fecha == "Casos nuevos totales") |> 
  pivot_longer(cols = `2020-03-02`:last_col(),
               names_to = "fecha",
               values_to = "casos_nuevos_dia") |>
  # rename(tipo = Fecha) |> 
  mutate(fecha = as_date(fecha))



# 3. Plots ----------------------------------------------------------------

## 3.1 Casos nuevos por día ----
ggplot(data = covid_procesados,
       aes(x = fecha,
           y = casos_nuevos_dia)) +
  geom_point(colour = "#3A5FCD",
             alpha = 0.8) +
  labs(y = "Casos nuevos COVID\n",
       x = NULL) +
  theme_light() +
  theme(panel.grid.minor = element_blank())

ggsave(filename = "plots/casos_nuevos_diarios.png",
       scale = 1.3,
       bg = "white",
       dpi = 300,
       height = 5,
       width = 10)
  

## 3.2 Tendencia de casos nuevos por día ----
ggplot(data = covid_procesados,
       aes(x = fecha,
           y = casos_nuevos_dia)) +
  geom_point(colour = "grey",
             alpha = 0.8,
             size = 0.75) +
  geom_spline(lwd = 1.5,
              spar = 0,
              colour = "#CD2990") +
  labs(y = "Casos nuevos COVID\n",
       x = NULL) +
  theme_light() +
  theme(panel.grid.minor = element_blank())

ggsave(filename = "plots/tendencia_casos_diarios.png",
       scale = 1.3,
       bg = "white",
       dpi = 300,
       height = 5,
       width = 10)


## 3.3 COVID stripes ----

## Función para normalizar datos (variables)
## se utiliza para mejorar el ajuste de colores
## a los valores de una variable en particular
min_max <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# Se clasifican los valores de una variable ya normalizada
ni <- round(
  classIntervals(var = covid_procesados$casos_nuevos_dia,
                 n = 7,
                 style = "jenks")$brks,
  digits = 0
  )

ggplot(covid_procesados,
       aes(x = fecha, y = "y")) +
  geom_tile(aes(fill = casos_nuevos_dia)) +
  geom_vline(aes(xintercept = as_date(c("2021-01-01"))),
             colour = "white",
             size = 0.5) +
  geom_vline(aes(xintercept = as_date(c("2022-01-01"))),
             colour = "white",
             size = 0.5) +
  geom_vline(aes(xintercept = as_date(c("2023-01-01"))),
             colour = "white",
             size = 0.5) +
  geom_text(aes(x = as_date(c("2021-01-01")),
                y = 0.47),
            label = "2021") +
  geom_text(aes(x = as_date(c("2022-01-01")),
                y = 0.47),
            label = "2022") +
  geom_text(aes(x = as_date(c("2023-01-01")),
                y = 0.47),
            label = "2023") +
  geom_text(aes(x = min(fecha),
                y = 0.47),
            label = "2020") +
  scale_fill_gradientn(name = "Casos nuevos COVID + \n",
                       colours = viridis::inferno(n = 100),
                       # breaks = "",
                       values = min_max(ni),
                       labels = scales::label_number(big.mark = "."),
                       # limits = c(0, 5000),
                       # oob = scales::discard,
                       guide = guide_colourbar(
                         direction = "horizontal",
                         barheight = unit(2, units = "mm"),
                         barwidth = unit(65, units = "mm"),
                         title.position = 'top',
                         title.hjust = 0.5,
                         label.hjust = .5,
                         nrow = 1,
                         byrow = T,
                         reverse = F,
                         label.position = "bottom",
                         # raster = FALSE
                       )
  ) +
  scale_x_date(date_breaks = "1 month",
               date_labels = "%b",
               expand = c(0.02, 0.01)
  ) +
  scale_y_discrete(labels = NULL) +
  labs(x = NULL,
       y = NULL) +
  theme_minimal() +                                                        
  theme(legend.position = "bottom",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank())

ggsave(filename = "plots/covid_stripes.png",
       scale = 1.3,
       bg = "white",
       dpi = 300,
       height = 5,
       width = 10)

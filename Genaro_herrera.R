
##### Cargar las librerias #####

library(tidyverse)

library(dplyr)
library(readxl)
library(Hmisc)


##### cargar los datos #####

setwd("D:/documentos/CICLO V/R")

Datos_Loreto <- read_xlsx(
  "D:\\documentos\\CICLO V\\R\\data_grupal\\Loreto_GenaroHerrera.xlsx"
  )
file.choose()

View(Datos_Loreto)

##### Agregar columnas tipo fecha y una cuenta #####

# z <- ISOdate(Datos_Loreto$A�o, Datos_Loreto$Mes, Datos_Loreto$Dia)
# as.Date(z)
meses <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
A�os <- c(seq(1972, 2014, 1))

Datos_Loreto <- Datos_Loreto %>% 
  mutate(Fecha = as.Date(
    ISOdate(Datos_Loreto$A�o, Datos_Loreto$Mes, Datos_Loreto$Dia))
    ) %>% 
  filter(str_sub(Fecha, 6, 7) %in% meses & str_sub(Fecha, 1, 4) %in% A�os)

Datos_Loreto <- Datos_Loreto %>% 
  mutate(id = 1:n())

head(Datos_Loreto)
tail(Datos_Loreto)

##### Filtrar el data para precipitacion #####

# Eliminar datos -99.9 (que no hay datos xd) 
Pp_corregida <- Datos_Loreto %>% 
  filter(Precipitacion %nin% "-99.9")
View(Pp_corregida)

### Resultados de precipitacion a nivel de todo el data
summary(Pp_corregida$Precipitacion)

# Ver la minima precipitacion y las filas
min(Pp_corregida[, "Precipitacion"])
Pp_corregida %>%
  filter(Precipitacion == "0")

# Ver la maxima precipitacion
max(Pp_corregida[, "Precipitacion"])
Pp_corregida[with(Pp_corregida, order(-Pp_corregida$Precipitacion)), ]

# Ver la media precipitacion
Pp_corregida %>%
  summarise(media_pp = mean(Precipitacion))


### Precipitacion por a�o
pp_lor_gh <- Pp_corregida %>% 
  select(A�o, Precipitacion) %>%
  group_by(A�o) %>% 
  summarise(prom_pp = mean(Precipitacion))
View(pp_lor_gh)  

# Filtrar data de los meses de un a�o x

pp_lor_mes_a�o <- Pp_corregida %>%
  select(Fecha, A�o, Mes, Precipitacion) %>% 
  group_by(Fecha) %>% 
  filter(str_sub(Fecha, 6, 7) %in% meses &
           str_sub(Fecha, 1, 4) == "2001") 

pp_lor_mes_a�o_final <- pp_lor_mes_a�o %>%
  group_by(A�o, Mes) %>% 
  summarise(prom_pp = mean(Precipitacion))
 
View(pp_lor_mes_a�o_final)

##### Ploteo de Precipitacion #####

ggplot(Pp_corregida, aes(x = A�o, y = Precipitacion)) +
  geom_point(
    aes(color = Precipitacion), size = 2, alpha = 0.4
  ) + 
  geom_smooth(method = "lm") +
  labs(
    title = "Gr�fico de la precipitaci�n de la estaci�n metereol�gica Genaro Herrera\nde la provincia Requena, Loreto, Per�.\nPara el periodo 1972 - 2014",
    y = "Precipitaci�n",
    x = "A�os",
    color = "Rango de\nvalores de la\nprecipitaci�n (mm)"
  ) +
  scale_color_gradient(low = "blue", high = "yellow") +
  theme_bw() +
  theme(
    panel.background = element_rect(fill = "darkgray"),
    panel.grid.minor = element_line(linetype = "dotted")
  )

last_plot()
ggsave(
  "Precipitacion_por_a�o.png", width = 10, height = 5
) 


##### Filtrar el data para temperatura #####

### Temperatura minima por a�o ###

# Quitamos los valores donde no hay datos
Tmin_corregida <- Datos_Loreto %>% 
  filter(Temp_min %nin% "-99.9")
View(Tmin_corregida)

### Resultados de Temperatura min a nivel de todo el data
summary(Tmin_corregida$Temp_min)

# Ver la minima de Tmin
min(Tmin_corregida[, "Temp_min"])
Tmin_corregida %>%
  filter(Temp_min == "11.4")

# Ver la maxima de Tmin
max(Tmin_corregida[, "Temp_min"])
Tmin_corregida %>%
  filter(Temp_min == "25.2")

# Ver la media Tmin
Tmin_corregida %>%
  summarise(media_Tmin = mean(Temp_min))


### Filtramos por a�o
Tmin_lor_gh <- Tmin_corregida %>% 
  select(A�o, Temp_min) %>%
  group_by(A�o) %>% 
  summarise(prom_Tmin = mean(Temp_min))
View(Tmin_lor_gh)  

# Minimo, Maximo y media
summary(Tmin_lor_gh$prom_Tmin)


### Temperatura maxima por a�o ###

# Quitar valores donde no hay datos
Tmax_corregida <- Datos_Loreto %>% 
  filter(Temp_max %nin% "-99.9")
head(Tmax_corregida)

### Media, min y max de Temperatura minima a nivel de todo el data
summary(Tmax_corregida$Temp_max)

### Filtrar promedio de Tmax por a�o
Tmax_lor_gh <- Tmax_corregida %>% 
  select(A�o, Temp_max) %>%
  group_by(A�o) %>% 
  summarise(prom_Tmax = mean(Temp_max))
View(Tmax_lor_gh)  

# Minimo, Maximo y media
summary(Tmax_lor_gh$prom_Tmax)


### Filtrar data de los meses de un a�o x

# Temperatura minima
Tmin_lor_mes_a�o <- Tmin_corregida %>%
  select(Fecha, A�o, Mes, Temp_min) %>% 
  group_by(Fecha) %>% 
  filter(str_sub(Fecha, 6, 7) %in% meses &
           str_sub(Fecha, 1, 4) == "2001") 

Tmin_lor_mes_a�o_final <- Tmin_lor_mes_a�o %>%
  group_by(A�o, Mes) %>% 
  summarise(prom_Tmin = mean(Temp_min))

Tmin_lor_mes_a�o_final

# Temperatura maxima
Tmax_lor_mes_a�o <- Tmax_corregida %>%
  select(Fecha, A�o, Mes, Temp_max) %>% 
  group_by(Fecha) %>% 
  filter(str_sub(Fecha, 6, 7) %in% meses &
           str_sub(Fecha, 1, 4) == "2001") 

Tmax_lor_mes_a�o_final <- Tmax_lor_mes_a�o %>%
  group_by(A�o, Mes) %>% 
  summarise(prom_Tmax = mean(Temp_max))

Tmax_lor_mes_a�o_final

##### Ploteo de Temperatura #####

### Temperatura minima

ggplot(Tmin_corregida, aes(x = A�o, y = Temp_min)) +
  geom_point(
    aes(color = Temp_min), size = 3, alpha = 0.5
  ) + 
  geom_smooth(method = "lm") +
  labs(
    title = "Gr�fico de la temperatura m�nima de la estaci�n metereol�gica Genaro Herrera\nde la provincia Requena, Loreto, Per�.\nPara el periodo 1972 - 2014",
    y = "Temperatura m�nima",
    x = "A�os",
    color = "Rango de\nvalores de la\ntemperatura\nm�nima (�C)"
  ) +
  scale_color_gradient(low = "blue", high = "brown") +
  theme_bw() +
  theme(
    panel.background = element_rect(fill = "darkgray"),
    panel.grid.minor = element_line(linetype = "dotted")
  )

ggsave(
  "Temperatura_minima_por_a�o.png", width = 10, height = 5
)


### Temperatura maxima

ggplot(Tmax_corregida, aes(x = A�o, y = Temp_max)) +
  geom_point(
    aes(color = Temp_max), size = 3, alpha = 0.6
  ) + 
  geom_smooth(method = "lm") +
  labs(
    title = "Gr�fico de la temperatura m�xima de la estaci�n metereol�gica Genaro Herrera\nde la provincia Requena, Loreto, Per�.\nPara el periodo 1972 - 2014",
    y = "Temperatura m�xima",
    x = "A�os",
    color = "Rango de\nvalores de la\ntemperatura\nm�xima (�C)"
  ) +
  scale_color_gradient(low = "red", high = "yellow") +
  theme_bw() +
  theme(
    panel.background = element_rect(fill = "darkgray"),
    panel.grid.minor = element_line(linetype = "dotted")
  )

ggsave(
  "Temperatura_maxima_por_a�o.png", width = 10, height = 5
)

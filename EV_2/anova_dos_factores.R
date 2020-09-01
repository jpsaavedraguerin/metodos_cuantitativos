library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)

## Cargar datos
crop.data<-read.csv("crop.data.csv",TRUE, ",",colClasses = c("factor","factor","factor","numeric"))

## Resumen de datos
summary(crop.data)

## Histograma de "desempeño"
hist<-hist(crop.data$yield, main="Histograma de desempeño", ylab = "Frecuencia", xlab = "Desempeño")

## Test de normalidad para "desempeño"
## H0: Datos distribuyen normal
shapiro.test(crop.data$yield)
qqnorm<- qqnorm(crop.data$yield)
qqline<- qqline(crop.data$yield)

## Varianza en los grupos

## Test Anova
a.dosfact <- aov(yield ~ fertilizer + density, data = crop.data)
summary(a.dosfact)





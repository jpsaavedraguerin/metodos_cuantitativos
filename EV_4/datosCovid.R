##Directorio
setwd("/home/saaveg/Documents/JPSG/metodos/")
#Librerías
library(tidyverse)
library(tseries)
##Fuente https://ourworldindata.org/coronavirus-source-data
chilecovid<-read.csv('EV_4/CovidChile.csv',header = TRUE,sep = ",")
covidNacionalOurWorld<-subset(chilecovid,select = c('date', 'total_cases','new_cases',
                                    'total_deaths','new_deaths','new_tests',
                                    'total_tests'))

########################################################
## Fuente https://github.com/MinCiencia/Datos-COVID19 ##
########################################################

#Totales diarios
totalesdiarios<-read.csv('EV_4/TotalesDiarios.csv',header = TRUE,sep = ",")
totalesdiarios<-subset(totalesdiarios,select = c('Fecha','Casos.nuevos.totales','Casos.totales'))
             
#PCR nacional
pcrNac<-read.csv('EV_4/PCR_Nacional.csv',header = TRUE,sep = ",")
pcrnacional<-subset(pcrNac,select = c('Fecha','Total.informados.ultimo.dia'))
colnames(pcrnacional)[colnames(pcrnacional) == "Total.informados.ultimo.dia"] <- "PCR.Nac.Informado.Ultimo.Dia"

#Casos nuevos diarios por región incremental
casosDiariosTotalesRegion<-read.csv('EV_4/CasosNuevos_Region_Incremental.csv',header = TRUE,sep = ",")
#Casos incremental Valparaíso
totalesValpoInc<-subset(casosDiariosTotalesRegion,select = c('Fecha','Valparaiso'))
#Casos incremental Antofagasta
totalesAntofaInc<-subset(casosDiariosTotalesRegion,select = c('Fecha','Antofagasta'))

#PCR por región diario
pcrRegionDiario<-read.csv('EV_4/PCR_Region_2.csv', header = TRUE,sep = ",",
                          colClasses = c('factor','numeric','factor',
                                         'numeric','numeric','numeric'),
                          na.strings = c('-'))
pcrRegionDiario$Fecha<-gsub('/','-',pcrRegionDiario$Fecha)
#PCR diario Valparaíso
pcrValpo<-pcrRegionDiario[pcrRegionDiario$Region=='Valparaíso',]
pcrValpo<-subset(pcrValpo,select = c('Fecha','PCR.Realizados'))
colnames(pcrValpo)[colnames(pcrValpo) == "PCR.Realizados"] <- "PCR.Valpo"
#PCR diario Antofagasta
pcrAntofa<-pcrRegionDiario[pcrRegionDiario$Region=='Antofagasta',]
pcrAntofa<-subset(pcrAntofa,select = c('Fecha','PCR.Realizados'))
colnames(pcrAntofa)[colnames(pcrAntofa) == "PCR.Realizados"] <- "PCR.Antofa"

dataTotal<-merge(totalesdiarios,pcrnacional,by = "Fecha",all = TRUE)
dataTotal<-merge(dataTotal,totalesValpoInc,by="Fecha",all=TRUE)
dataTotal<-merge(dataTotal,pcrValpo,by="Fecha",all=TRUE)
dataTotal<-merge(dataTotal,totalesAntofaInc,by="Fecha",all=TRUE)
dataTotal<-merge(dataTotal,pcrAntofa,by="Fecha",all=TRUE)


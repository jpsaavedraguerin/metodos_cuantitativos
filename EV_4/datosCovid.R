##Directorio
setwd("/home/saaveg/Documents/JPSG/metodos/")
#Librerías
library(tidyverse)
library(lmtest)
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
colnames(pcrnacional)[colnames(pcrnacional) == "Total.informados.ultimo.dia"] <- "PCR.Nac"

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

########################################
## Análisis de regresión lineal       ##
########################################

#datanac: Se conocen datos de infectados diarios y PCR desde 25-03-2020 para nacional
#Se conocen datos de infectados diarios y PCR desde 90-042020 para Valparaiso
#Se conocen datos de infectados diarios y PCR desde 90-042020 para Antofagasta

#Nivel nacional
datanac<-subset(dataTotal[39:211,], select=c("Fecha","Casos.nuevos.totales",
                                              "PCR.Nac"))
datavalpo<-subset(dataTotal[39:211,], select=c("Fecha","Valparaiso",
                                             "PCR.Valpo"))
dataantofa<-subset(dataTotal[39:211,], select=c("Fecha","Antofagasta",
                                            "PCR.Antofa"))
#Plots
par(mfrow=c(1,3)) #dev.off() para resetear el par
plot(datanac$PCR.Nac,datanac$Casos.nuevos.totales, xlab="PCR Nacional", ylab="Casos Nacional")
plot(datavalpo$Valparaiso,datavalpo$PCR.Valpo, xlab="PCR Valparaíso", ylab="Casos Valparaíso")
plot(dataantofa$Antofagasta,dataantofa$PCR.Antofa, xlab="PCR Antofagasta", ylab="Casos Antofagasta")


#Definición variables
pcr<-datanac$PCR.Nac
pcrlog<-log(datanac$PCR.Nac)
casos<-datanac$Casos.nuevos.totales
casoslog<-log(datanac$Casos.nuevos.totales)

pcrvalpo<-datavalpo$PCR.Valpo
pcrvalpolog<-log(datavalpo$PCR.Valpo)
casosvalpo<-datavalpo$Valparaiso
casosvalpolog<-log(datavalpo$Valparaiso)

pcrantofa<-dataantofa$PCR.Antofa
pcrantofalog<-log(dataantofa$PCR.Antofa)
casosantofa<-dataantofa$Antofagasta
casosantofalog<-log(dataantofa$Antofagasta)

#Boxplot
par(mfrow=c(3,4))
boxplot(pcr, main = "PCR nacional")
boxplot(casos, main = "Casos nuevos nacional")
boxplot(pcrlog, main = "log(PCR) nacional")
boxplot(casoslog, main = "log(Casos) nuevos nacional")

boxplot(pcrvalpo, main = "PCR Valparaíso")
boxplot(casosvalpo, main = "Casos nuevos valparaíso")
boxplot(pcrvalpolog, main = "log(PCR) Valparaíso")
boxplot(casosvalpolog, main = "log(Casos) nuevos Valparaíso")

boxplot(pcrantofa, main = "PCR Antofagasta")
boxplot(casosantofa, main = "Casos nuevos Antofagasta")
boxplot(pcrantofalog, main = "log(PCR) Antofagasta")
boxplot(casosantofalog, main = "log(Casos) nuevos Antofagasta")

#Correlación
cornac1<-cor(pcr,casos)
cornac2<-cor(pcrlog,casos)
cornac3<-cor(pcr,casoslog)
cornac4<-cor(pcrlog,casoslog)

corvalpo1<-cor(pcrvalpo,casosvalpo)
corvalpo2<-cor(pcrvalpolog,casosvalpo)
corvalpo3<-cor(pcrvalpo,casosvalpolog)
corvalpo4<-cor(pcrvalpolog,casosvalpolog)

corantofa1<-cor(pcrantofa,casosantofa)
corantofa2<-cor(pcrantofalog,casosantofa)
corantofa3<-cor(pcrantofa,casosantofalog)
corantofa4<-cor(pcrantofalog,casosantofalog)

cornac1;cornac2;cornac3;cornac4

corvalpo1;corvalpo2;corvalpo3;corvalpo4

corantofa1;corantofa2;corantofa3;corantofa4


cor.test(pcr,casos)
cor.test(pcrlog,casos)
cor.test(pcr,casoslog)
cor.test(pcrlog,casoslog)

cor.test(pcrvalpo,casosvalpo)
cor.test(pcrvalpolog,casosvalpo)
cor.test(pcrvalpo,casosvalpolog)
cor.test(pcrvalpolog,casosvalpolog)

cor.test(pcrantofa,casosantofa)
cor.test(pcrantofalog,casosantofa)
cor.test(pcrantofa,casosantofalog)
cor.test(pcrantofalog,casosantofalog)

#Scatter
par(mfrow=c(3,4))
scatter.smooth(pcr,casos, main="Nacional lineal-lineal",
               xlab="pcr",ylab="casos")
scatter.smooth(pcrlog,casos, main="Nacional lineal-log",
               xlab="log(pcr)",ylab="casos")
scatter.smooth(pcr,casoslog, main="Nacional log-lineal",
               xlab="pcr",ylab="log(casos)")
scatter.smooth(pcrlog,casoslog, main="Nacional log-log",
               xlab="log(pcr)", ylab="log(casos)")

scatter.smooth(pcrvalpo,casosvalpo, main="Valparaíso lineal-lineal",
               xlab="pcr",ylab="casos")
scatter.smooth(pcrvalpolog,casosvalpo, main="Valparaíso lineal-log",
               xlab="log(pcr)",ylab="casos")
scatter.smooth(pcrvalpo,casosvalpolog, main="Valparaíso log-lineal",
               xlab="pcr",ylab="log(casos)")
scatter.smooth(pcrvalpolog,casosvalpolog, main="Valparaíso log-log",
               xlab="log(pcr)", ylab="log(casos)")

scatter.smooth(pcr,casos, main="Antofagasta lineal-lineal",
               xlab="pcr",ylab="casos")
scatter.smooth(pcrlog,casos, main="Antofagasta lineal-log",
               xlab="log(pcr)",ylab="casos")
scatter.smooth(pcr,casoslog, main="Antofagasta log-lineal",
               xlab="pcr",ylab="log(casos)")
scatter.smooth(pcrlog,casoslog, main="Antofagasta log-log",
               xlab="log(pcr)", ylab="log(casos)")

#Boxplot analysis
par(mfrow=c(3,4))
bppcr<-boxplot(pcr, main="Nacional",
                  xlab="PCR")
bpcasos<-boxplot(casos, main="Nacional",
                    xlab="Casos")
bppcrlog<-boxplot(pcrlog, main="Nacional",
                  xlab="log(pcr)")
bpcasoslog<-boxplot(casoslog, main="Nacional",
                  xlab="log(casos)")
print(bppcr);print(bpcasos);print(bppcrlog);print(bpcasoslog)

bppcrvalpo<-boxplot(pcrvalpo, main="Valparaíso",
                       xlab="log(pcr) ")
bpcasosvalpo<-boxplot(casosvalpo, main="Valparaíso",
                       xlab="log(pcr) ")
bppcrvalpolog<-boxplot(pcrvalpolog, main="Valparaíso",
                       xlab="log(pcr) ")
bpcasosvalpolog<-boxplot(casosvalpolog, main="Valparaíso",
                         xlab="log(casos)")
print(bppcrvalpolog);print(bpcasosvalpo);print(bppcrvalpolog);print(bpcasosvalpolog)

bppcrantofa<-boxplot(pcrantofa, main="Antofagasta",
                        xlab="log(pcr)")
bpcasosantofa<-boxplot(casosantofa, main="Antofagasta",
                          xlab="log(casos)")
bppcrantofalog<-boxplot(pcrantofalog, main="Antofagasta",
                        xlab="log(pcr)")
bpcasosantofalog<-boxplot(casosantofalog, main="Antofagasta",
                          xlab="log(casos)")
print(bppcrantofa);print(bpcasosantofa);print(bppcrantofalog);print(bpcasosantofalog)

par(mfrow=c(3,4))
boxplot(pcr)
boxplot(casos)
boxplot(pcrlog)
boxplot(casoslog)

boxplot(pcrvalpo)
boxplot(casosvalpo)
boxplot(pcrvalpolog)
boxplot(casosvalpolog)

boxplot(pcrantofa)
boxplot(casosantofa)
boxplot(pcrantofalog)
boxplot(casosantofalog)

#Modelo lineal
fit11=lm(casos~pcr)
fit12=lm(casoslog~pcr)
fit13=lm(casos~pcrlog)
fit14=lm(casoslog~pcrlog)

fit21=lm(casosvalpo~pcrvalpo)
fit22=lm(casosvalpolog~pcrvalpo)
fit23=lm(casosvalpo~pcrvalpolog)
fit24=lm(casosvalpolog~pcrvalpolog)

fit31=lm(casosantofa~pcrantofa)
fit32=lm(casosantofalog~pcrantofa)
fit33=lm(casosantofa~pcrantofalog)
fit34=lm(casosantofalog~pcrantofalog)

summary(fit11)
summary(fit12)
summary(fit13)
summary(fit14)

summary(fit21)
summary(fit22)
summary(fit23)
summary(fit24)

summary(fit31)
summary(fit32)
summary(fit33)
summary(fit34)


par(mfrow=c(2,2))
plot(fit11)
plot(fit12)
plot(fit13)
plot(fit14)

plot(fit21)
plot(fit22)
plot(fit23)
plot(fit24)

plot(fit31)
plot(fit32)
plot(fit33)
plot(fit34)

#Residuos Estandarizados ej: rstandard(fit11)
e11<-residuals(fit11)
e12<-residuals(fit12)
e13<-residuals(fit13)
e14<-residuals(fit14)

e21<-residuals(fit21)
e22<-residuals(fit22)
e23<-residuals(fit23)
e24<-residuals(fit24)

e31<-residuals(fit31)
e32<-residuals(fit32)
e33<-residuals(fit33)
e34<-residuals(fit34)


par(mfrow=c(2,2))
plot(e11)
plot(e12)
plot(e13)
plot(e14)

plot(e21)
plot(e22)
plot(e23)
plot(e24)

plot(e31)
plot(e32)
plot(e33)
plot(e34)

par(mfrow=c(1,1))
boxplot(e11,e12,e13,e14,e21,e22,e23,e24,e31,e32,e33,e34)


#nuevo dataframe
data11<-data.frame(fitted.values(fit11),rstandard(fit11))
data12<-data.frame(fitted.values(fit12),rstandard(fit12))
data13<-data.frame(fitted.values(fit13),rstandard(fit13))
data14<-data.frame(fitted.values(fit14),rstandard(fit14))

data21<-data.frame(fitted.values(fit21),rstandard(fit21))
data22<-data.frame(fitted.values(fit22),rstandard(fit22))
data23<-data.frame(fitted.values(fit23),rstandard(fit23))
data24<-data.frame(fitted.values(fit24),rstandard(fit24))

data31<-data.frame(fitted.values(fit31),rstandard(fit31))
data32<-data.frame(fitted.values(fit32),rstandard(fit32))
data33<-data.frame(fitted.values(fit33),rstandard(fit33))
data34<-data.frame(fitted.values(fit34),rstandard(fit34))

par(mfrow=c(3,4))
plot(data11, main="Nacional lineal-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data12, main="Nacional log-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data13, main="Nacional lineal-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data14, main="Nacional log-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")

plot(data21, main="Valparaíso lineal-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data22, main="Valparaíso log-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data23, main="Valparaíso lineal-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data24, main="Valparaíso log-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")

plot(data31, main="Antofagasta lineal-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data32, main="Antofagasta log-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data33, main="Antofagasta lineal-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data34, main="Antofagasta log-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")


#Obtener resudios sobre 2 y bajo -2
data11b<-datanac[-c(which(data11$rstandard.fit11. %in% data11$rstandard.fit11.[data11$rstandard.fit11.>2]),
                            which(data11$rstandard.fit11. %in% data11$rstandard.fit11.[data11$rstandard.fit11.<(-2)])),]
data12b<-datanac[-c(which(data12$rstandard.fit12. %in% data12$rstandard.fit12.[data12$rstandard.fit12.>2]),
                            which(data12$rstandard.fit12. %in% data12$rstandard.fit12.[data12$rstandard.fit12.<(-2)])),]
data13b<-datanac[-c(which(data13$rstandard.fit13. %in% data13$rstandard.fit13.[data13$rstandard.fit13.>2]),
                            which(data13$rstandard.fit13. %in% data13$rstandard.fit13.[data13$rstandard.fit13.<(-2)])),]
data14b<-datanac[-c(which(data14$rstandard.fit14. %in% data14$rstandard.fit14.[data14$rstandard.fit14.>2]),
                            which(data14$rstandard.fit14. %in% data14$rstandard.fit14.[data14$rstandard.fit14.<(-2)])),]

data21b<-datavalpo[-c(which(data21$rstandard.fit21. %in% data21$rstandard.fit21.[data21$rstandard.fit21.>2]),
                              which(data21$rstandard.fit21. %in% data21$rstandard.fit21.[data21$rstandard.fit21.<(-2)])),]
data22b<-datavalpo[-c(which(data22$rstandard.fit22. %in% data22$rstandard.fit22.[data22$rstandard.fit22.>2]), 
                              which(data22$rstandard.fit22. %in% data22$rstandard.fit22.[data22$rstandard.fit22.<(-2)])),]
data23b<-datavalpo[-c(which(data23$rstandard.fit23. %in% data23$rstandard.fit23.[data23$rstandard.fit23.>2]), 
                              which(data23$rstandard.fit23. %in% data23$rstandard.fit23.[data23$rstandard.fit23.<(-2)])),]
data24b<-datavalpo[-c(which(data24$rstandard.fit24. %in% data24$rstandard.fit24.[data24$rstandard.fit24.>2]), 
                              which(data24$rstandard.fit24. %in% data24$rstandard.fit24.[data24$rstandard.fit24.<(-2)])),]

data31b<-dataantofa[-c(which(data31$rstandard.fit31. %in% data31$rstandard.fit31.[data31$rstandard.fit31.>2]), 
                              which(data31$rstandard.fit31. %in% data31$rstandard.fit31.[data31$rstandard.fit31.<(-2)])),]
data32b<-dataantofa[-c(which(data32$rstandard.fit32. %in% data32$rstandard.fit32.[data32$rstandard.fit32.>2]), 
                              which(data32$rstandard.fit32. %in% data32$rstandard.fit32.[data32$rstandard.fit32.<(-2)])),]
data33b<-dataantofa[-c(which(data33$rstandard.fit33. %in% data33$rstandard.fit33.[data33$rstandard.fit33.>2]), 
                              which(data33$rstandard.fit33.. %in% data33$rstandard.fit33.[data33$rstandard.fit33.<(-2)])),]
data34b<-dataantofa[-c(which(data34$rstandard.fit34. %in% data34$rstandard.fit34.[data34$rstandard.fit34.>2]), 
                              which(data34$rstandard.fit34. %in% data34$rstandard.fit34.[data34$rstandard.fit34.<(-2)])),]



#Correlaciones
cor11b<-cor(data11b$Casos.nuevos.totales,data11b$PCR.Nac)
cor12b<-cor(log(data12b$Casos.nuevos.totales),data12b$PCR.Nac)
cor13b<-cor(data13b$Casos.nuevos.totales,log(data13b$PCR.Nac))
cor14b<-cor(log(data14b$Casos.nuevos.totales),log(data14b$PCR.Nac))

cor21b<-cor(data21b$Valparaiso,data21b$PCR.Valpo)
cor22b<-cor(log(data22b$Valparaiso),data22b$PCR.Valpo)
cor23b<-cor(data23b$Valparaiso,log(data23b$PCR.Valpo))
cor24b<-cor(log(data24b$Valparaiso),log(data24b$PCR.Valpo))

cor31b<-cor(data31b$Antofagasta,data31b$PCR.Antofa)
cor32b<-cor(log(data32b$Antofagasta),data32b$PCR.Antofa)
cor33b<-cor(data33b$Antofagasta,log(data33b$PCR.Antofa))
cor34b<-cor(log(data34b$Antofagasta),log(data34b$PCR.Antofa))

cor11b;cor12b;cor13b;cor14b

cor21b;cor22b;cor23b;cor24b

cor31b;cor32b;cor33b;cor34b


cor.test(data11b$Casos.nuevos.totales,data11b$PCR.Nac)
cor.test(log(data12b$Casos.nuevos.totales),data12b$PCR.Nac)
cor.test(data13b$Casos.nuevos.totales,log(data13b$PCR.Nac))
cor.test(log(data14b$Casos.nuevos.totales),log(data14b$PCR.Nac))

cor.test(data21b$Valparaiso,data21b$PCR.Valpo)
cor.test(log(data22b$Valparaiso),data22b$PCR.Valpo)
cor.test(data23b$Valparaiso,log(data23b$PCR.Valpo))
cor.test(log(data24b$Valparaiso),log(data24b$PCR.Valpo))

cor.test(data31b$Antofagasta,data31b$PCR.Antofa)
cor.test(log(data32b$Antofagasta),data32b$PCR.Antofa)
cor.test(data33b$Antofagasta,log(data33b$PCR.Antofa))
cor.test(log(data34b$Antofagasta),log(data34b$PCR.Antofa))

#Nuevo modelo
fit11b=lm(data11b$Casos.nuevos.totales~data11b$PCR.Nac)
fit12b=lm(log(data12b$Casos.nuevos.totales)~data12b$PCR.Nac)
fit13b=lm(data13b$Casos.nuevos.totales~log(data13b$PCR.Nac))
fit14b=lm(log(data14b$Casos.nuevos.totales)~log(data14b$PCR.Nac))

fit21b=lm(data21b$Valparaiso~data21b$PCR.Valpo)
fit22b=lm(log(data22b$Valparaiso)~data22b$PCR.Valpo)
fit23b=lm(data23b$Valparaiso~log(data23b$PCR.Valpo))
fit24b=lm(log(data24b$Valparaiso)~log(data24b$PCR.Valpo))

fit31b=lm(data31b$Antofagasta~data31b$PCR.Antofa)
fit32b=lm(log(data32b$Antofagasta)~data32b$PCR.Antofa)
fit33b=lm(data33b$Antofagasta~log(data33b$PCR.Antofa))
fit34b=lm(log(data34b$Antofagasta)~log(data34b$PCR.Antofa))

summary(fit11b)
summary(fit12b)
summary(fit13b)
summary(fit14b)

summary(fit21b)
summary(fit22b)
summary(fit23b)
summary(fit24b)

summary(fit31b)
summary(fit32b)
summary(fit33b)
summary(fit34b)


##Dataframe de fitted values versus residuos para datos tratados
data11bb<-data.frame(fitted.values(fit11b),rstandard(fit11b))
data12bb<-data.frame(fitted.values(fit12b),rstandard(fit12b))
data13bb<-data.frame(fitted.values(fit13b),rstandard(fit13b))
data14bb<-data.frame(fitted.values(fit14b),rstandard(fit14b))

data21bb<-data.frame(fitted.values(fit21b),rstandard(fit21b))
data22bb<-data.frame(fitted.values(fit22b),rstandard(fit22b))
data23bb<-data.frame(fitted.values(fit23b),rstandard(fit23b))
data24bb<-data.frame(fitted.values(fit24b),rstandard(fit24b))

data31bb<-data.frame(fitted.values(fit31b),rstandard(fit31b))
data32bb<-data.frame(fitted.values(fit32b),rstandard(fit32b))
data33bb<-data.frame(fitted.values(fit33b),rstandard(fit33b))
data34bb<-data.frame(fitted.values(fit34b),rstandard(fit34b))


#Fitted.value v/s residuals estandarizados
#Luego de eliminar los residuos sobre 2 y bajo -2
par(mfrow=c(3,4))
plot(data11bb, main="Nacional lineal-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data12bb, main="Nacional log-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data13bb, main="Nacional lineal-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data14bb, main="Nacional log-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")

plot(data21bb, main="Valparaíso lineal-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data22bb, main="Valparaíso log-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data23bb, main="Valparaíso lineal-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data24bb, main="Valparaíso log-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")

plot(data31bb, main="Antofagasta lineal-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data32bb, main="Antofagasta log-lineal", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data33bb, main="Antofagasta lineal-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(data34bb, main="Antofagasta log-log", xlab="Valor ajustado", ylab="residuos estandarizados")
abline(h=c(2,-2), col="red")


#Normalidad de residuos
shapiro.test(fit11$residuals)
shapiro.test(fit12$residuals)
shapiro.test(fit13$residuals)
shapiro.test(fit14$residuals)

shapiro.test(fit21$residuals)
shapiro.test(fit22$residuals)
shapiro.test(fit23$residuals)
shapiro.test(fit24$residuals)

shapiro.test(fit31$residuals)
shapiro.test(fit32$residuals)
shapiro.test(fit33$residuals)
shapiro.test(fit34$residuals)

shapiro.test(fit11b$residuals)
shapiro.test(fit12b$residuals)
shapiro.test(fit13b$residuals)
shapiro.test(fit14b$residuals)

shapiro.test(fit21b$residuals)
shapiro.test(fit22b$residuals)
shapiro.test(fit23b$residuals)
shapiro.test(fit24b$residuals)

shapiro.test(fit31b$residuals)
shapiro.test(fit32b$residuals)
shapiro.test(fit33b$residuals)
shapiro.test(fit34b$residuals)

#Independencia de residuos Durbin-Watson
dwtest(fit11,alternative = c("two.sided"))
dwtest(fit12,alternative = c("two.sided"))
dwtest(fit13,alternative = c("two.sided"))
dwtest(fit14,alternative = c("two.sided"))

dwtest(fit21,alternative = c("two.sided"))
dwtest(fit22,alternative = c("two.sided"))
dwtest(fit23,alternative = c("two.sided"))
dwtest(fit24,alternative = c("two.sided"))

dwtest(fit31,alternative = c("two.sided"))
dwtest(fit32,alternative = c("two.sided"))
dwtest(fit33,alternative = c("two.sided"))
dwtest(fit34,alternative = c("two.sided"))

dwtest(fit11b,alternative = c("two.sided"))
dwtest(fit12b,alternative = c("two.sided"))
dwtest(fit13b,alternative = c("two.sided"))
dwtest(fit14b,alternative = c("two.sided"))

dwtest(fit21b,alternative = c("two.sided"))
dwtest(fit22b,alternative = c("two.sided"))
dwtest(fit23b,alternative = c("two.sided"))
dwtest(fit24b,alternative = c("two.sided"))

dwtest(fit31b,alternative = c("two.sided"))
dwtest(fit32b,alternative = c("two.sided"))
dwtest(fit33b,alternative = c("two.sided"))
dwtest(fit34b,alternative = c("two.sided"))

#Homocedasticidad golfeld y quandt
gqtest(fit11,alternative = c("two.sided"))
gqtest(fit12,alternative = c("two.sided"))
gqtest(fit13,alternative = c("two.sided"))
gqtest(fit14,alternative = c("two.sided"))

gqtest(fit21,alternative = c("two.sided"))
gqtest(fit22,alternative = c("two.sided"))
gqtest(fit23,alternative = c("two.sided"))
gqtest(fit24,alternative = c("two.sided"))

gqtest(fit31,alternative = c("two.sided"))
gqtest(fit32,alternative = c("two.sided"))
gqtest(fit33,alternative = c("two.sided"))
gqtest(fit34,alternative = c("two.sided"))

gqtest(fit11b,alternative = c("two.sided"))
gqtest(fit12b,alternative = c("two.sided"))
gqtest(fit13b,alternative = c("two.sided"))
gqtest(fit14b,alternative = c("two.sided"))

gqtest(fit21b,alternative = c("two.sided"))
gqtest(fit22b,alternative = c("two.sided"))
gqtest(fit23b,alternative = c("two.sided"))
gqtest(fit24b,alternative = c("two.sided"))

gqtest(fit31b,alternative = c("two.sided"))
gqtest(fit32b,alternative = c("two.sided"))
gqtest(fit33b,alternative = c("two.sided"))
gqtest(fit34b,alternative = c("two.sided"))

#### Análisis de varianza ####

#Varianza de errores antes
var(rstandard(fit11));var(rstandard(fit12));var(rstandard(fit13));var(rstandard(fit14))

var(rstandard(fit21));var(rstandard(fit22));var(rstandard(fit23));var(rstandard(fit24))

var(rstandard(fit31));var(rstandard(fit32));var(rstandard(fit33));var(rstandard(fit34))

#Varianza de errores después
var(rstandard(fit11b));var(rstandard(fit12b));var(rstandard(fit13b));var(rstandard(fit14b))

var(rstandard(fit21b));var(rstandard(fit22b));var(rstandard(fit23b));var(rstandard(fit24b))

var(rstandard(fit31b));var(rstandard(fit32b));var(rstandard(fit33b));var(rstandard(fit34b))


#Varianza de valores ajustados antes
var(fitted.values(fit11));var(fitted.values(fit12));var(fitted.values(fit13));var(fitted.values(fit14))

var(fitted.values(fit21));var(fitted.values(fit22));var(fitted.values(fit23));var(fitted.values(fit24))

var(fitted.values(fit31));var(fitted.values(fit32));var(fitted.values(fit33));var(fitted.values(fit34))



#Varianza de valores ajustados después
var(fitted.values(fit11b));var(fitted.values(fit12b));var(fitted.values(fit13b));var(fitted.values(fit14b))

var(fitted.values(fit21b));var(fitted.values(fit22b));var(fitted.values(fit23b));var(fitted.values(fit24b))

var(fitted.values(fit31b));var(fitted.values(fit32b));var(fitted.values(fit33b));var(fitted.values(fit34b))


#Rehacer analisis
plot(dso)
scatter.smooth(dso)
cor(dso$pcrlog,dso$casoslog) #La correlación es menor
cor.test(dso$pcrlog,dso$casoslog)





#Boxplots residuos antes y despues para cada caso
par(mfrow=c(3,4))
boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit12),rstandard(fit12b))
boxplot(rstandard(fit13),rstandard(fit13b))
boxplot(rstandard(fit14),rstandard(fit14b))

boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))

boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))

boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))
boxplot(rstandard(fit11),rstandard(fit11b))





###################################
##  Randomizando los datos
###################################

#Randomizar data

data.aux<-subset(dataTotal[39:211,],select=c(1:ncol(dataTotal)))
data.aleatoria <- data.aux[sample(1:nrow(data.aux)),]


nacional<-data.frame(PCR=data.aleatoria$PCR.Nac,casos=data.aleatoria$Casos.nuevos.totales)
valparaiso<-data.frame(PCR=data.aleatoria$PCR.Valpo, casos=data.aleatoria$Valparaiso)
antofagasta<-data.frame(PCR=data.aleatoria$PCR.Antofa, casos=data.aleatoria$Antofagasta)

#colnames(nacional)[c(1,2)]<-c("casos","PCR")
#colnames(valparaiso)[c(1,2)]<-c("casos","PCR")
#colnames(antofagasta)[c(1,2)]<-c("casos","PCR")

par(mfrow=c(1,3))
plot(nacional, main="Nacional")
plot(valparaiso, main="Valparaíso")
plot(antofagasta, main="Antofagasta")

#Transformación

nacional.log<-data.frame(log.PCR=log(nacional$PCR),log.casos=log(nacional$casos))
valparaiso.log<-data.frame(log.PCR=log(valparaiso$PCR),log.casos=log(valparaiso$casos))
antofagasta.log<-data.frame(log.PCR=log(antofagasta$PCR),log.casos=log(antofagasta$casos))

plot(nacional.log, main="Nacional", xlab="log(PCR)", ylab="log(casos)")
plot(valparaiso.log, main="Valparaíso", xlab="log(PCR)", ylab="log(casos)")
plot(antofagasta.log, main="Antofagasta", xlab="log(PCR)", ylab="log(casos)")

#Correlación
cor.test(nacional.log$log.PCR,nacional.log$log.casos)
cor.test(valparaiso.log$log.PCR,valparaiso.log$log.casos)
cor.test(antofagasta.log$log.PCR,antofagasta.log$log.casos)

#Modelo
fitnacional<-lm(nacional.log$log.casos~nacional.log$log.PCR)
fitvalparaiso<-lm(valparaiso.log$log.casos~valparaiso.log$log.PCR)
fitantofagasta<-lm(antofagasta.log$log.casos~antofagasta.log$log.PCR)

#Plot residuos
rnacional<-data.frame(valores.ajustados=fitted.values(fitnacional),residuos.estandarizados=rstandard(fitnacional))
rvalparaiso<-data.frame(valores.ajustados=fitted.values(fitvalparaiso),residuos.estandarizados=rstandard(fitvalparaiso))
rantofagasta<-data.frame(valores.ajustados=fitted.values(fitantofagasta),residuos.estandarizados=rstandard(fitantofagasta))

plot(rnacional,main="Nacional", xlab="Valores ajustados", ylab="Residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(rvalparaiso,main="Valparaíso", xlab="Valores ajustados", ylab="Residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(rantofagasta,main="Antofagasta", xlab="Valores ajustados", ylab="Residuos estandarizados")
abline(h=c(2,-2), col="red")


#Eliminar pares de datos con residuos fuera de (-2,2)
nacional.trat<-nacional.log[-c(which(rnacional$residuos.estandarizados %in% rnacional$residuos.estandarizados[rnacional$residuos.estandarizados>2]), 
                                which(rnacional$residuos.estandarizados %in% rnacional$residuos.estandarizados[rnacional$residuos.estandarizados<(-2)])),]
valparaiso.trat<-valparaiso.log[-c(which(rvalparaiso$residuos.estandarizados %in% rvalparaiso$residuos.estandarizados[rvalparaiso$residuos.estandarizados>2]), 
                           which(rvalparaiso$residuos.estandarizados %in% rvalparaiso$residuos.estandarizados[rvalparaiso$residuos.estandarizados<(-2)])),]
antofagasta.trat<-antofagasta.log[-c(which(rantofagasta$residuos.estandarizados %in% rantofagasta$residuos.estandarizados[rantofagasta$residuos.estandarizados>2]), 
                           which(rantofagasta$residuos.estandarizados %in% rantofagasta$residuos.estandarizados[rantofagasta$residuos.estandarizados<(-2)])),]




#Nuevo fit

fitnacional.trat<-lm(nacional.trat$log.casos~nacional.trat$log.PCR)
fitvalparaiso.trat<-lm(valparaiso.trat$log.casos~valparaiso.trat$log.PCR)
fitantofagasta.trat<-lm(antofagasta.trat$log.casos~antofagasta.trat$log.PCR)


##
rnacional.trat<-data.frame(valores.ajustados=fitted.values(fitnacional.trat),residuos.estandarizados=rstandard(fitnacional.trat))
rvalparaiso.trat<-data.frame(valores.ajustados=fitted.values(fitvalparaiso.trat),residuos.estandarizados=rstandard(fitvalparaiso.trat))
rantofagasta.trat<-data.frame(valores.ajustados=fitted.values(fitantofagasta.trat),residuos.estandarizados=rstandard(fitantofagasta.trat))


#Plotear residuos
plot(rnacional.trat,main="Nacional", xlab="Valores ajustados", ylab="Residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(rvalparaiso.trat,main="Valparaíso", xlab="Valores ajustados", ylab="Residuos estandarizados")
abline(h=c(2,-2), col="red")
plot(rantofagasta.trat,main="Antofagasta", xlab="Valores ajustados", ylab="Residuos estandarizados")
abline(h=c(2,-2), col="red")


#Plot de fit
par(mfrow=c(2,2))
plot(fitnacional.trat)
plot(fitvalparaiso.trat)
plot(fitantofagasta.trat)

#Supuesto Normalidad

shapiro.test(rstandard(fitnacional.trat))
shapiro.test(rstandard(fitvalparaiso.trat))
shapiro.test(rstandard(fitantofagasta.trat))

#Supuesto independencia

dwtest(fitnacional.trat,alternative = "two.sided")
dwtest(fitvalparaiso.trat,alternative = "two.sided")
dwtest(fitantofagasta.trat,alternative = "two.sided")

#Supuesto homocedasticidad

gqtest(fitnacional.trat,alternative = "two.sided")
gqtest(fitvalparaiso.trat,alternative = "two.sided")
gqtest(fitantofagasta.trat,alternative = "two.sided")



#Modelos propuestos
nac<-function(x,a,b){
  return (exp(a)*x^(b))
}


par(mfrow=c(3,1))
plot(nacional.trat, main="Nacional", xlab="log(PCR)", ylab="log(casos)")
abline(fitnacional.trat, col="green")
plot(nacional.trat, main="Valparaíso", xlab="log(PCR)", ylab="log(casos)")
abline(fitnacional.trat, col="green")
plot(nacional.trat, main="Antofagasta", xlab="log(PCR)", ylab="log(casos)")
abline(fitnacional.trat, col="green")

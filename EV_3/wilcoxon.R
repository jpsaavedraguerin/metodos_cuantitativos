library(tidyr)
library(tidyverse)
library(dplyr)
library(PairedData)


## Wilcoxon Test datos no pareados
marcaA<-c(2.1,4.0,6.3,5.4,4.8,3.7,6.1,3.3)
marcaB<-c(4.1,0.6,3.1,2.5,4.0,6.2,1.6,2.2,1.9,5.4)

marcas <- data.frame(marca = rep(c("marcaA","marcaB")), nicotina = c(marcaA,marcaB) )
marcas

boxplot(nicotina ~ marca, data = marcas)
wilcox.test(marcaA,marcaB,alternative = "two.sided",correct = FALSE)


##Wilcoxon Test Datos Pareados
dataDrug <- read.csv("EV_3/newdrug(excel2007).csv",header = TRUE,sep = ";",
                     colClasses =c(NA,NA,NA,NA,"numeric","numeric") )

antes<-dataDrug$Before_exp_BP
despues<-dataDrug$After_exp_BP
testdroga<-data.frame(med=c("antes","despues"),
                      rend=c(antes,despues))
boxplot(rend~med,data=testdroga)

testdroga

group_by(testdroga, med) %>%
  summarise(
    count = n(),
    median = median(rend, na.rm = TRUE),
    #IQR = IQR(rend, na.rm = TRUE)
  )

# Subset datos antes de tratamiento
antes <- subset(testdroga,  med == "antes", rend,
                drop = TRUE)
# Subset datos después de tratamiento
despues <- subset(testdroga,  med == "despues", rend,
                  drop = TRUE)
# Plot paired data
library(PairedData)
dp <- paired(antes, despues)
plot(dp, type = "profile") + theme_bw()

wilcox.test(antes,despues,paired = TRUE)



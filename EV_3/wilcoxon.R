library(tidyr)
library(tidyverse)
marcaA<-c(2.1,4.0,6.3,5.4,4.8,3.7,6.1,3.3)
marcaB<-c(4.1,0.6,3.1,2.5,4.0,6.2,1.6,2.2,1.9,5.4)

marcas <- data.frame(marca = rep(c("marcaA","marcaB")), nicotina = c(marcaA,marcaB) )
marcas

boxplot(nicotina ~ marca, data = marcas)
wilcox.test(marcaA,marcaB,alternative = "two.sided",correct = FALSE)

library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)

crop.data<-read.csv("crop.data.csv",TRUE, ",",colClasses = c("factor","factor","factor","numeric"))

summary(crop.data)

hist(crop.data$yield)
shapiro.test(crop.data$yield)

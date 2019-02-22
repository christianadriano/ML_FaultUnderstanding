#Analyze the distribution of Other profession

library(farff)
library(ggplot2)
library(dplyr)

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df <-  readARFF(file_path)

df <- select(df,"worker_id","experience")

head(df)

df <- unique(df)

length(df[grep("other",tolower(df$experience)),"experience"])

#retired
length(df[grep("retired",tolower(df$experience)),"experience"])
#6

#professor
length(df[grep("professor",tolower(df$experience)),"experience"])
#4

#manager
length(df[grep("manager",tolower(df$experience)),"experience"])
#2

#Analyze the distribution of Other profession

library(farff)
library(ggplot2)
library(dplyr)

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df <-  readARFF(file_path)

df <- select(df,"worker_id","experience")

head(df)

df <- unique(df)

df[grep("Other",df$experience),"experience"]

#count retired
#count professor
#count manager
#count IT
#count unemployed
#count other

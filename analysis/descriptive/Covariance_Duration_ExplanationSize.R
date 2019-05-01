"
Exploring the relationship between duration and explanation size
 "
#import ARFF files
library(ufs)
library(userfriendlyscience)
library(farff)

#includes dplyr, stringr,tidyr,ggplot2,tibble,purr,forcats
library(tidyverse) 


file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'file_name',
         'answer_index',
         'duration',
         'explanation')

df2['explanation_size'] <- nchar(df2$explanation)
plot(df2$explanation_size)

#remove outlier (above 1000 characters)
df2 <- df2[df2$explanation_size<1000,]

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

df1 <-
  select(df1,
         'file_name',
         'answer_index',
         'duration',
         'explanation')

df1['explanation_size'] <- nchar(df1$explanation)
plot(df1$explanation_size)

#remove outlier (above 1000 characters)
df1 <- df1[df1$explanation_size<1000,]


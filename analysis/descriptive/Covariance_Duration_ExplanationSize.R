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

#Outlier treament
upper_limit <- (5*60*1000) * 10 #50 min, which is 10 times the duration for which the task was designed for
lower_limit <- (5*60*1000) / 10 #30 seconds, which is the minimum expected read test case, questions, and the program statement (3 lines)
df2 <- df2[df2$duration<upper_limit & df2$duration>lower_limit,]


df2['explanation_size'] <- nchar(df2$explanation)
plot(df2$duration, df2$explanation_size)

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
df1 <- df1[df1$duration<upper_limit & df1$duration>lower_limit,]


cor.test(df1$duration,df1$explanation_size,method="kendall")
#z = 29.252, p-value < 2.2e-16, tau=0.3213421 (Medium correlation)
cor.test(df1$duration,df1$explanation_size,method="pearson")
#t = 21.793, df = 3713, p-value < 2.2e-16, 95 percent confidence interval: 0.3079331 0.3649627, pearson cor = 0.3367567 

cor.test(df2$duration,df2$explanation_size,method="kendall")
#z = 20.427, p-value < 2.2e-16, tau=0.2777974 (Medium correlation)
cor.test(df2$duration,df2$explanation_size,method="pearson")
#t = 16.133, df = 2414, p-value < 2.2e-16, 95 percent confidence interval: 0.2755117 0.3475179, Pearson cor =0.3119627 

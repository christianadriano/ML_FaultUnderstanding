#Are participant score and number of incompleted tasks independent?
# ANOVA Games-Howell Post-Hoc Test for E1 
# Wilcoxon with Bonferroni for E2 because of low frequencies (<5)
#
# https://rpubs.com/aaronsc32/games-howell-test

library(ufs)
library(userfriendlyscience)
library(farff)
library(ggplot2)
library(pwr)
library(dplyr)


file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df1 <- select(df1,'worker_id','session_id','microtask_id')
df_grouped <- group_by(list(df1['worker_id']),list(df1.['session_id']))

                       
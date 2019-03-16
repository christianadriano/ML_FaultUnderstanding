#Are YoE distinct across qualification score levels for any of the professions?
#Are YoE distinct across qualification score levels for any of the genders?

#This analysis is particular for E2 experiment

#------------------------------------------------------
# Distinction for professionals


library(ufs)
library(userfriendlyscience)
library(farff)
library(ggplot2)
library(pwr)
library(stringr)
library(tidyverse)

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'worker_id',
         'session_id',
         'microtask_id',
         'experience',
         'qualification_score',
         'years_programming')

#Replace Other * experience to simply other.
df2[grep("Other",df2$experience),"experience"] <-"Other"



profession_names <-  c("Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other")
#Run ANOVA for each profession
one.way.matrix <- matrix(list(), nrow=5, ncol=2)
rownames(one.way.matrix) <- profession_names
colnames(one.way.matrix) <- c("anova","power")


print(" ANOVA results, statistically significant?")
for(profession in profession_names){
  df_prof <- df2[str_detect(df2$experience, profession), ] #could have used grep too.
  one.way <- oneway(as.factor(df_prof$qualification_score), y =df_prof$years_programming , posthoc = 'games-howell')
  one.way.matrix[[profession,"anova"]] = one.way
  p.value = one.way$output$dat[1,5]
  if(p.value>0.05){
    print(str_c(profession," NO, p_value = ", p.value))
  }
  else{
    power <- pwr.anova.test(k = 3,
                   n = NULL,
                   f = one.way$output$etasq,
                   sig.level = 0.05,
                   power = 0.9)
    one.way.matrix[[profession,"power"]] = power
    print(str_c(profession," YES, p_value = ", p.value," power.test.n=",power$n))
  }
}

#Results statistically significant for all professions but Professional_Developer.
# [1] "Professional_Developer NO, p_value = 0.166908878668443"
# [1] "Hobbyist YES, p_value = 0.018276325662517 power.test.n=23387.5795319749"
# [1] "Graduate_Student YES, p_value = 0.000217026992290259 power.test.n=1183.84621266952"
# [1] "Undergraduate_Student YES, p_value = 0.000453740235808 power.test.n=5089.24554557751"
# [1] "Other YES, p_value = 3.57444563761555e-06 power.test.n=282.226118713718"


#Are YoE distinct across qualification score levels for any of the genders?
#Yes, according to one way ANOVA, for each gender, the different qualification score levels present distinct
#YoE in average. However, for the Males group, the power test shows that it would need 400 thousands
#participants to detect the differences in 90% of the time. Meanwhile, for the Female group, it would
# require 2 thousand participants, which is in the order of magnitude of both experiments.

#This analysis is particular for E2 experiment

#------------------------------------------------------
# Distinctions for each genders


library(ufs)
library(userfriendlyscience)
library(farff)
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
         'gender',
         'qualification_score',
         'years_programming')

gender_list <- c("Female","Male")

#Run ANOVA for each profession
one.way.matrix <- matrix(list(), nrow=2, ncol=2)
rownames(one.way.matrix) <- gender_list
colnames(one.way.matrix) <- c("anova","power")


print(" ANOVA results, statistically significant?")
for(gender in gender_list){
  df_gender <- df2[str_detect(df2$gender, gender), ] #could have used grep too.
  one.way <- oneway(as.factor(df_gender$qualification_score), y =df_gender$years_programming , posthoc = 'games-howell')
  one.way.matrix[[gender,"anova"]] = one.way
  p.value = one.way$output$dat[1,5]
  if(p.value>0.05){
    print(str_c(gender," NO, p_value = ", p.value))
  }
  else{
    power <- pwr.anova.test(k = 3,
                            n = NULL,
                            f = one.way$output$etasq,
                            sig.level = 0.05,
                            power = 0.9)
    one.way.matrix[[gender,"power"]] = power
    print(str_c(gender," YES, p_value = ", p.value," power.test.n=",power$n))
  }
}

# [1] "Female YES, p_value = 9.85898615827111e-07 power.test.n=2223.65892380225"
# [1] "Male YES, p_value = 0.0478093423862236 power.test.n=433743.372596025"
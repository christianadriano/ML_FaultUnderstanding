#---------------------------------------------------------------------
"
Were some professions faster than others? 
YES, power analysis tells that it would require 1270 participants
to detect effect (differences in task duration)

For this analysis I compared three groups of tasks, the first, second, and third
of each assignment. Since I performed multiple comparisons,I 

"

library(ufs)
library(userfriendlyscience)
library(farff)
library(pwr)
library(tidyverse)


file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'file_name',
         'experience',
         'answer_index',
         'duration')

#Replace Other * experience to simply other.
df2[grep("Other",df2$experience),"experience"] <-"Other"
df2["duration_minutes"] <- df2$duration / 60000

"------------------------------------------------------------"
#FIRST TASK
df2 <- df2[df2$answer_index=='1',]

#Run ANOVA for each profession
# one.way.matrix <- matrix(list(), nrow=5, ncol=2)
# rownames(one.way.matrix) <- profession_names
# colnames(one.way.matrix) <- c("anova","power")

print(" ANOVA results, statistically significant?")
one.way <- oneway(as.factor(df2$experience), y =df2$duration , posthoc = 'games-howell')
one.way
#one.way.matrix[[profession,"anova"]] = one.way
p.value = one.way$output$dat[1,5]
if(p.value>0.05){
  print(str_c(profession," NO, p_value = ", p.value))
}else{
  power <- pwr.anova.test(k = 3,
                          n = NULL,
                          f = one.way$output$etasq,
                          sig.level = 0.05,
                          power = 0.9)
#  one.way.matrix[[profession,"power"]] = power
  print(str_c(" YES, p_value = ", p.value," power.test.n=",power$n))
}

# ANOVA was significant, p_value = 3.2067647808294e-11

#The following professions have distinct task durations (1st tasks in the assignment):
# Hobbyist>Graduate_Student
# Other>Graduate_Student
# Professional_Developer<Hobbyist
# Undergraduate_Student<Hobbyist
# Professional_Developer<Other
# Undergraduate_Student<Other

# Power Analysis:
# To detect these effects in 90% of the time, it would be necessary 
#to have 1270 participants, which is in the order of magnitude of the study.

"------------------------------------------------------------"
#SECOND AND THIRD TASKS (together because we could not show that there
#durations are distinsct on average)

df2 <- df2[!df2$answer_index=='1',]

print("TASK 2 and 3, ANOVA results, statistically significant?")
one.way <- oneway(as.factor(df2$experience), y =df2$duration , posthoc = 'games-howell')
one.way
#one.way.matrix[[profession,"anova"]] = one.way
p.value = one.way$output$dat[1,5]
if(p.value>0.05){
  print(str_c(profession," NO, p_value = ", p.value))
}else{
  power <- pwr.anova.test(k = 3,
                          n = NULL,
                          f = one.way$output$etasq,
                          sig.level = 0.05,
                          power = 0.9)
  #  one.way.matrix[[profession,"power"]] = power
  print(str_c(" YES, p_value = ", p.value," power.test.n=",power$n))
}

# ANOVA show that the task duration average across categories are statistically significant distinct 
# p_value = 0.000563025702213102.
# 
# Post hoc test: games-howelladjustment shows that only 3 pairs are actually distinct
#                                                   diff      ci.lo     ci.hi    t     df     p
# Hobbyist-Graduate_Student                      61737.59  -23184.84 146660.03 1.99 306.91  .271
# Other-Graduate_Student                        124429.58    1846.75 247012.40 2.79 238.81  .045
# Professional_Developer-Graduate_Student        -3712.88  -81099.76  73674.00 0.13 222.70 1.000
# Undergraduate_Student-Graduate_Student         18227.44  -83213.72 119668.61 0.49 448.12  .988
# Other-Hobbyist                                 62691.98  -46560.18 171944.15 1.58 176.92  .511
# Professional_Developer-Hobbyist               -65450.47 -118364.71 -12536.24 3.38 673.17  .007
# Undergraduate_Student-Hobbyist                -43510.15 -128042.99  41022.70 1.41 571.89  .622
# Professional_Developer-Other                 -128142.46 -231713.73 -24571.19 3.42 143.30  .007
# Undergraduate_Student-Other                  -106202.13 -228600.55  16196.28 2.38 259.88  .123
# Undergraduate_Student-Professional_Developer   21940.32  -54963.43  98844.08 0.78 438.08  .936

#Nonetheless, the power test shows it would require 29658 participants to detect these effects.

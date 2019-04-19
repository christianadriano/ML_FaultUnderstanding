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

#--- Remove outliers
#Outlier limits in milliseconds
upper_limit <- (5*60*1000) * 10
lower_limit <- (5*60*1000) / 10
df2 <- df2[df2$duration<upper_limit & df2$duration>lower_limit,]

#New field
df2["duration_minutes"] <- df2$duration / 60000

"------------------------------------------------------------"
#FIRST TASK
df2_first <- df2[df2$answer_index=='1',]

print(" ANOVA results, statistically significant?")
one.way <- oneway(as.factor(df2_first$experience), y =df2_first$duration , posthoc = 'games-howell')
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

### Oneway Anova for y=duration and x=experience (groups: Graduate_Student, Hobbyist, Other, Professional_Developer, Undergraduate_Student)

# Omega squared: 95% CI = [.03; .09], point estimate = .05
# Eta Squared: 95% CI = [.03; .08], point estimate = .06
# 
# SS  Df               MS     F     p
# Between groups (error + effect) 73888552994799.5   4 18472138248699.9 14.16 <.001
# Within groups (error only)      1208158363614651 926 1304706656171.33               
# # 
# 
# ### Post hoc test: games-howell
# 
#                                                     diff      ci.lo     ci.hi    t     df     p
# Hobbyist-Graduate_Student                      405226.73    64871.18  745582.27 3.27 283.26  .011
# Other-Graduate_Student                        1003619.24   156811.47 1850427.01 3.31  82.78  .012
# Professional_Developer-Graduate_Student         93677.94  -182222.07  369577.96 0.94 177.02  .883
# Undergraduate_Student-Graduate_Student         -36768.76  -306166.89  232629.38 0.38 159.62  .996
# Other-Hobbyist                                 598392.51  -248724.84 1445509.87 1.97  83.15  .290
# Professional_Developer-Hobbyist               -311548.78  -587251.19  -35846.37 3.10 341.17  .018
# Undergraduate_Student-Hobbyist                -441995.48  -711116.46 -172874.51 4.51 306.92 <.001
# Professional_Developer-Other                  -909941.30 -1734403.11  -85479.48 3.09  73.98  .023
# Undergraduate_Student-Other                  -1040388.00 -1862763.33 -218012.67 3.54  73.15  .006
# Undergraduate_Student-Professional_Developer  -130446.70  -309328.98   48435.58 2.00 523.38  .269

# However, the only statistically significant differences are that 
# Others and Hobbyists are slower than the students and professionals.

#The following professions have distinct task durations (1st tasks in the assignment):
# Hobbyist>Graduate_Student
# Other>Graduate_Student
# Professional_Developer<Hobbyist
# Undergraduate_Student<Hobbyist
# Professional_Developer<Other
# Undergraduate_Student<Other

#(Hobbyist/Other) > (Graduate_Student/Undergrad/Professional)


# Power Analysis:
# To detect these effects in 90% of the time, it would be necessary 
#to have 1270 participants, which is in the order of magnitude of 
#the number of particpants in the study.

"------------------------------------------------------------"
#SECOND AND THIRD TASKS (together because we could not show that there
#durations are distinsct on average)

df2_notFirst <- df2[!df2$answer_index=='1',]

print("TASK 2 and 3, ANOVA results, statistically significant?")
one.way <- oneway(as.factor(df2_notFirst$experience), y =df2_notFirst$duration , posthoc = 'games-howell')
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
# p_value = 4.16289079952329e-06
# 
# Post hoc test: games-howelladjustment shows that only 3 pairs are actually distinct
#                                                   diff      ci.lo     ci.hi    t     df     p
# Hobbyist-Graduate_Student                      46934.09  -49297.49 143165.68 1.34 238.93 .666
# Other-Graduate_Student                         91807.30  -37857.36 221471.96 1.95 250.46 .296
# Professional_Developer-Graduate_Student       -31205.75 -118497.16  56085.67 0.99 166.04 .861
# Undergraduate_Student-Graduate_Student        -25735.79 -120932.53  69460.95 0.74 229.13 .946
# Other-Hobbyist                                 44873.21  -65375.93 155122.35 1.12 182.89 .795
# Professional_Developer-Hobbyist               -78139.84 -131222.72 -25056.96 4.03 537.28 .001
# Undergraduate_Student-Hobbyist                -72669.88 -138146.67  -7193.09 3.04 669.89 .021
# Professional_Developer-Other                 -123013.05 -225599.83 -20426.28 3.31 137.71 .010
# Undergraduate_Student-Other                  -117543.09 -226895.12  -8191.07 2.96 176.99 .028
# Undergraduate_Student-Professional_Developer    5469.96  -45686.85  56626.76 0.29 494.71 .998

#Nonetheless, the power test shows it would require 10938 participants to detect these effects.
#Hence, for the second and third tasks we cannot ascertain that professions have different speeds
#to complete tasks.

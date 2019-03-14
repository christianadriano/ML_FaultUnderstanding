#Are YoE distinct across qualification score levels? NO

#This analysis is particular for E2 experiment

library(ufs)
library(userfriendlyscience)
library(farff)
library(reshape2)
library(dplyr)
library(pwr)


file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'worker_id',
         'session_id',
         'microtask_id',
         'qualification_score',
         'years_programming')

one.way <- oneway(as.factor(df2$qualification_score), y =df2$years_programming , posthoc = 'tukey')
#Tukey and Games-Howell provided the same results.

one.way <- oneway(as.factor(df2$qualification_score), y =df2$years_programming , posthoc = 'games-howell')
one.way

#Power calculations
pwr.anova.test(k = 3,
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)


# ### Oneway Anova for y=years_programming and x=qualification_score (groups: 3, 4, 5)
# 
# Omega squared: 95% CI = [0; .01], point estimate = 0
# Eta Squared: 95% CI = [0; .01], point estimate = 0
# 
#                                       SS   Df     MS    F    p
# Between groups (error + effect)    615.13    2 307.57 4.48 .011
# Within groups (error only)      176962.93 2577  68.67          
# 
# 
# ### Post hoc test: games-howell
# 
#     diff ci.lo ci.hi    t      df    p
# 4-3 0.62 -0.41  1.65 1.41 1433.62 .334
# 5-3 1.19  0.25  2.14 2.96 1425.63 .009
# 5-4 0.58 -0.33  1.48 1.49 1646.84 .297

# Balanced one-way analysis of variance power calculation 
# 
# k = 3
# n = 351518.7
# f = 0.003464002
# sig.level = 0.05
# power = 0.9
# 
# NOTE: n is number in each group


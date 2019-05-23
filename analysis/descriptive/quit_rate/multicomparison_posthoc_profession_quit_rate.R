" 
Did certain professions quit the experiment earlier?

Analyses only for Experiment-2 (E2), because E1 did not have information about professions
"

library(reshape2)
library(ufs)
library(userfriendlyscience)
library(farff)
library(ggplot2)
library(pwr)
library(dplyr)
library(plyr)

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'worker_id',
         'session_id',
         'microtask_id',
         'experience')

df2[grep("Other",df2$experience),"experience"] <-"Other"
df2 <- df2[df2$experience!="Other",]

#counts the number of microtasks executed by each worker_id and session_id
df_group <-
  ddply(df2,
        worker_id ~ session_id ~ experience,
        summarise,
        tasks = length(unique(microtask_id)))

#df_group <- df_group[df_group$tasks<3,]
df_group['incomplete'] <- 3 - df_group$tasks

df_experiences = select(df_group,experience,incomplete)
df_pivot = dcast(df_experiences,incomplete~experience,length)

#print pivot tables with totals
dcast(df_experiences,incomplete~experience,length, margins=TRUE)

#Other ways of doing
#df_group_scores = ddply(df_scores,incomplete~experience,summarise,frequency=length(incomplete))
#df_pivot <- cast(df_group_scores, incomplete ~ experience)                        

to_drop <- c("incomplete")
df_pivot <- df_pivot[,!names(df_pivot) %IN% to_drop]
mat <- as.matrix(df_pivot)

fisher.test(mat,simulate.p.value = TRUE)
#p-value = 0.08096

#-------------------------------------------------------------------
#Distribution of incomplete tasks
df_p_pivot <- tibble("incomplete" = c(1:2))
df_p_pivot["p_Grad"] <- df_pivot$Graduate_Student/sum(df_pivot$Graduate_Student)
df_p_pivot["p_Hobb"] <- df_pivot$Hobbyist/sum(df_pivot$Hobbyist)
df_p_pivot["p_Prof"] <- df_pivot$Professional_Developer/sum(df_pivot$Professional_Developer)
df_p_pivot["p_Under"] <- df_pivot$Undergraduate_Student/sum(df_pivot$Undergraduate_Student)
# A tibble: 3 x 5
#       incomplete p_Grad p_Hobb p_Prof p_Under
#           <int>  <dbl>  <dbl>  <dbl>   <dbl>
#            0    0.692   0.844  0.861   0.795 
#            1    0.206   0.118  0.118   0.128 
#            2    0.103   0.0377 0.0202  0.0769

#------------------------------------------------------------------
#Run ANOVA with Games-Howell correction, just to confirm that any two categories are distinct
df_temp <- select(df_pivot,Professional_Developer,Hobbyist,Graduate_Student,Undergraduate_Student)
df_molten <- melt(df_temp)
one.way <- oneway(df_molten$variable, y =df_molten$value , posthoc = 'games-howell')
one.way
#No significant differences
# Omega squared: 95% CI = [NA; .19], point estimate = -.49
# Eta Squared: 95% CI = [0; .04], point estimate = .08
# 
# SS Df     MS    F    p
# Between groups (error + effect) 76.5  3   25.5 0.12 .942
# Within groups (error only)       833  4 208.25          
# 
# 
# ### Post hoc test: games-howell
# 
#                                                 diff ci.lo  ci.hi t   df    p
#   Hobbyist-Professional_Developer              -7.5   NaN   NaN 0.39 1.47 <NA>
#   Graduate_Student-Professional_Developer      -7.5   NaN   NaN 0.42 1.21 <NA>
#   Undergraduate_Student-Professional_Developer -4.0   NaN   NaN 0.23 1.17 <NA>
#   Graduate_Student-Hobbyist                     0.0   NaN   NaN 0.00 1.71    1
#   Undergraduate_Student-Hobbyist                3.5   NaN   NaN 0.35 1.62 <NA>
#   Undergraduate_Student-Graduate_Student        3.5   NaN   NaN 0.47 1.98 <NA>
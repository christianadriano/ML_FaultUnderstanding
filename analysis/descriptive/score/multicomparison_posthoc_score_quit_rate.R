#Are participant score and number of incompleted tasks independent?
# ANOVA Games-Howell Post-Hoc Test for E1 
# Wilcoxon with Bonferroni for E2 because of low frequencies (<5)
#
# https://rpubs.com/aaronsc32/games-howell-test

install.packages('reshape')
library(reshape)
library(ufs)
library(userfriendlyscience)
library(farff)
library(ggplot2)
library(pwr)
library(dplyr)
library(plyr)

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df1 <- select(df1,'worker_id','session_id','microtask_id','qualification_score')

#Other ways to grouping
#df1 %>% group_by(session_id) %>% summarise(microtask_id= length(unique(microtask_id)))
#df_group <- aggregate(df1$microtask_id, by=list(session=df1$session_id), FUN=length)

df_group <- ddply(df1,worker_id ~ session_id ~ qualification_score,summarise,tasks=length(unique(microtask_id)))

df_group <- df_group[df_group$tasks<10,]
df_group['incomplete'] <- 10 - df_group$tasks

kendall_tau_1 <- cor.test(df_group$qualification_score,df_group$incomplete,method=c("kendall"))
kendall_tau_1
#NO Signficant correlation z = -0.16639, p-value = 0.8679, tau = -0.008577271

#-----------------------------------------------------------
#Now I treated both scores and incomplete as categories and I wanted to see if they are independent.
#For that I did a fisher exact test (two sided with simulated p-value based on 2000 replicates). 
#I did not use the chi-square test because the contingency table had more than 20% of frequencies below 5.

df_fequencies <-  ddply(df_group,incomplete~qualification_score,summarise,frequency=length(incomplete))

mat <- as.matrix(cast(df_fequencies, incomplete ~ qualification_score))

fisher.test(mat,simulate.p.value = TRUE)

#The results of not statistically significant, p-value = 0.9595. This means that we could not
#reject that null hypothesis that score and incomplete tasks are independent.

#-----------------------------------------------------------
#Now I test the null-hypthesis that different score levels have the same average number of
#incomplete tasks

#Now I want to see if the average number of incomplete tasks is distinct across score levels
#For that I run an multicomparison test. I chose ANOVA with games-howell to correct for heteroscedacity.

df_group["scores_factor"] = as.factor(df_group$qualification_score)
df_group["incomplete_factor"] =  as.factor(df_group$incomplete)

df_scores = select(df_group,qualification_score,incomplete)
df_group_scores = ddply(df_scores,incomplete~qualification_score,summarise,frequency=length(incomplete))

df_pivot <- cast(df_group_scores, incomplete ~ qualification_score)                        
df_pivot["p_4"] <- df_pivot$'4'/sum(df_pivot$'4')
df_pivot["p_3"] <- df_pivot$'3'/sum(df_pivot$'3')
df_pivot["p_2"] <- df_pivot$'2'/sum(df_pivot$'2')
df_pivot["p_0"] <- 1/9

#75% or more
p_4_7 = sum(df_pivot$p_4[7:9])
p_3_7 = sum(df_pivot$p_3[7:9])
p_2_7 = sum(df_pivot$p_2[7:9])

one.way <- oneway(df_group$scores_factor, y =df_group$incomplete , posthoc = 'tukey')
one.way

one.way <- oneway(df_group$scores_factor, y =df_group$incomplete , posthoc = 'games-howell')
one.way



#https://stats.stackexchange.com/questions/8225/how-to-summarize-data-by-group-in-r
#https://stackoverflow.com/questions/1660124/how-to-sum-a-variable-by-group
#https://www.nature.com/articles/s41467-019-08806-w


"
Are participants' score and number of incompleted tasks independent?
Did participants with lower score quit earlier?
Did participants quit mostly at the begining or at the end of the experiment
"

install.packages('reshape')
library(reshape2)
library(ufs)
library(userfriendlyscience)
library(farff)
library(ggplot2)
library(pwr)
library(dplyr)
library(plyr)

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

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

-----------------------------------------------------------
#Now I look at the distributions of incomplete tasks by qualification score.
#I want to know if participants quit mostly at the begining or at the end of the experiment

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

#Participants with scores 2, 3, and 4 corresponded respectively to 50%, 51%, and 43% who left 9 tasks incomplete 
#(i.e., quit after the first tasks) and 74%, 81%, and 76% left 7 or more tasks incomplete.



#----------------------------------------------------------
#----------------------------------------------------------
#Compute Kendall-tau correlation for E2

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'worker_id',
         'session_id',
         'microtask_id',
         'qualification_score')

#Other ways to grouping
#df1 %>% group_by(session_id) %>% summarise(microtask_id= length(unique(microtask_id)))
#df_group <- aggregate(df1$microtask_id, by=list(session=df1$session_id), FUN=length)

df_group <-
  ddply(df2,
        worker_id ~ session_id ~ qualification_score,
        summarise,
        tasks = length(unique(microtask_id)))

df_group <- df_group[df_group$tasks<3,]
df_group['incomplete'] <- 3 - df_group$tasks

kendall_tau <-
  cor.test(df_group$qualification_score,
           df_group$incomplete,
           method = c("kendall"))
kendall_tau
#Statistically significant z = 0.99174, p-value = 0.04806, kendall-tau =-0.149538 
#However, the correlation of 0.15 is too weak 

#-----------------------------------------------------------
#Now I treated both scores and incomplete as categories and I wanted to see if they are independent.
#For that I did a fisher exact test (two sided with simulated p-value based on 2000 replicates). 
#I did not use the chi-square test because the contingency table had more than 20% of frequencies below 5.

df_fequencies <-  ddply(df_group,incomplete~qualification_score,summarise,frequency=length(incomplete))

mat <- as.matrix(cast(df_fequencies, incomplete ~ qualification_score))

fisher.test(mat,simulate.p.value = TRUE)

#The results of not statistically significant, p-value = 0.07646 
#This means that we could not reject the null hypothesis that score and incomplete tasks are independent.

#-----------------------------------------------------------
#Now I look at the distributions of incomplete tasks by qualification score.
#I want to know if participants quit mostly at the begining or at the end of the experiment

df_group <- ddply(df2,worker_id ~ session_id ~ qualification_score,summarise,tasks=length(unique(microtask_id)))

df_group <- df_group[df_group$tasks<3,]
df_group['incomplete'] <- 3 - df_group$tasks

df_scores = select(df_group,qualification_score,incomplete)
df_group_scores = ddply(df_scores,incomplete~qualification_score,summarise,frequency=length(incomplete))

df_pivot <- cast(df_group_scores, incomplete ~ qualification_score)                        
df_pivot["p_5"] <- df_pivot$'5'/sum(df_pivot$'5')
df_pivot["p_4"] <- df_pivot$'4'/sum(df_pivot$'4')
df_pivot["p_3"] <- df_pivot$'3'/sum(df_pivot$'3')
df_pivot["p_0"] <- 1/3

#Participants with scores 3, 4, and 5 corresponded respectively to 33%, 34%, and 19% who left 2 tasks incomplete
#(i.e., quit after the first tasks) and 67%, 67%, and 81% who left one task incomplete.

#https://stats.stackexchange.com/questions/8225/how-to-summarize-data-by-group-in-r
#https://stackoverflow.com/questions/1660124/how-to-sum-a-variable-by-group
#https://www.nature.com/articles/s41467-019-08806-w


> 

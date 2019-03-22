"
Were tasks in E2 faster than E1?

For E2, we selected only the first task in each assignment to compare with
E1 tasks. The reason is that  Therefore, we compared only tasks for which the
participant was seeing the source code for the rist time. This excludes the
second and third tasks of each assignment in E2.

The second and third tasks of each assignment are not comparable with tasks in E1,
because the second and third tasks in each assignment in E2 concern the same source code.
Therefore, participants did not have to spent time understanding the source or at least
can reuse the knowledge they acquired from executing the first task.

" 
library(ggplot2)
library(ufs)
library(userfriendlyscience)
library(farff)
library(pwr)
library(tidyverse) #includes dplyr, stringr,tidyr,ggplot2,tibble,purr,forcats


"1. Null-Hypothesis: Do the first, second, and third tasks in E2 
assignments have duration average?
"

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'file_name',
         'answer_index',
         'duration')

df2 <- df2[df2$answer_index=='1']

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

df1 <-
  select(df1,
         'file_name',
         'answer_index',
         'duration')


wilcoxon_results <- wilcox.test(df1$duration,df2$duration)
wilcoxon_results
wilcoxon_results$alternative
wilcoxon_results$statistic
wilcoxon_results$parameter
wilcoxon_results$null.value
mean(df1$duration)
mean(df2$duration)

# Wilcoxon rank sum test with continuity correction
# 
# data:  df1$duration and df2$duration
# W = 4473000, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0
# 
# > mean(df1$duration)
# [1] 201078.1
# > mean(df2$duration)
# [1] 396429.1

" ----------------------------------------------------------------"

"Are tasks in E1 also faster than in E2 across all qualification score levels?
i.e., for programmers at the lower, medium, and upper range of the scales?
"

" Testing for programmers at lower range"

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'file_name',
         'qualification_score',
         'answer_index',
         'duration')

df2 <- df2[df2$answer_index=='1']
df2["duration_minutes"] <- df2$duration / 60000


file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

df1 <-
  select(df1,
         'file_name',
         'qualification_score',
         'duration')
df1["duration_minutes"] <- df1$duration / 60000

score_levels_E1 <- c(2,3,4)
score_levels_E2 <- c(3,4,5)

results.matrix <- matrix(list(), nrow=3, ncol=3)
rownames(results.matrix) <- c("low score","medium score","high score")
colnames(results.matrix) <- c("p.value","average_E1","average_E2")

i=1
for(i in c(1:3)){
  df_group_1 <- df1[df1$qualification_score==score_levels_E1[i],]
  df_group_2 <-  df2[df2$qualification_score==score_levels_E2[i],]
  wilcoxon_results <- wilcox.test(df_group_1$duration,df_group_2$duration)
  results.matrix[[i,"p.value"]] <-  wilcoxon_results$p.value
  results.matrix[[i,"average_E1"]] <-  mean(df_group_1$duration)
  results.matrix[[i,"average_E2"]] <-  mean(df_group_2$duration)
}

#The E1 tasks are faster than E2 across all levels of qualification score
#              p.value      average_E1 average_E2
# low score    1.408635e-80 145900.1   325416.4  
# medium score 1.737562e-13 368379.8   372172.9  
# high score   1.390266e-08 268484.3   456611.7

bxplot <- ggplot(df1, aes(x=as.factor(qualification_score),y=duration_minutes)) + 
  geom_boxplot()  +
  stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
  labs(title=name,x="Task order", y = "Duration (min)")+
  theme_classic()

bxplot <- ggplot(df2, aes(x=as.factor(qualification_score),y=duration_minutes)) + 
                     geom_boxplot()  +
                     stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
                     labs(title=name,x="Task order", y = "Duration (min)")+
                     theme_classic()
                   

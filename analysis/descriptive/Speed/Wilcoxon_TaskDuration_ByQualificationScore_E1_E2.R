
" ----------------------------------------------------------------"
# COMPARE TASK DURATION ACROSS QUALIFICATION SCORE LEVELS

"Are tasks in E1 also faster than in E2 across all qualification score levels?
i.e., for programmers at the lower, medium, and upper range of the scales?
"

" Testing for programmers at lower range"


 
library(ggplot2)
library(gridExtra)
library(ufs)
library(userfriendlyscience)
library(farff)
library(pwr)
library(tidyverse) #includes dplyr, stringr,tidyr,ggplot2,tibble,purr,forcats


file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'file_name',
         'qualification_score',
         'answer_index',
         'duration')

df2 <- df2[df2$answer_index==1,]


file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

df1 <-
  select(df1,
         'file_name',
         'qualification_score',
         'duration')

#remove outliers
#Outlier limits in milliseconds
upper_limit <- (5*60*1000) * 10
lower_limit <- (5*60*1000) / 10

df1_O <- df1[df1$duration<upper_limit & df1$duration>lower_limit,]
df2_O <- df2[df2$duration<upper_limit & df2$duration>lower_limit,]

df1_O["duration_minutes"] <- df1_O$duration / 60000
df2_O["duration_minutes"] <- df2_O$duration / 60000

score_levels_E1 <- c(2,3,4)
score_levels_E2 <- c(3,4,5)

results.matrix <- matrix(list(), nrow=3, ncol=3)
rownames(results.matrix) <- c("low score","medium score","high score")
colnames(results.matrix) <- c("p.value","average_E1","average_E2")

i=1
for(i in c(1:3)){
  df_group_1 <- df1_O[df1_O$qualification_score==score_levels_E1[i],]
  df_group_2 <-  df2_O[df2_O$qualification_score==score_levels_E2[i],]
  wilcoxon_results <- wilcox.test(df_group_1$duration,df_group_2$duration)
  results.matrix[[i,"p.value"]] <-  wilcoxon_results$p.value
  results.matrix[[i,"average_E1"]] <-  mean(df_group_1$duration)
  results.matrix[[i,"average_E2"]] <-  mean(df_group_2$duration)
}

#The E1 tasks are faster than E2 across all levels of qualification score
#                p.value    average_E1 average_E2
# low score    1.037291e-35 197083.2   445984.5  
# medium score 5.071701e-23 280991.6   585753    
# high score   7.844771e-22 293149.1   574848.1  


bxplot_title = "task duration by qualification score"

bxplot_1 <- ggplot(df1_O, aes(x=as.factor(qualification_score),y=duration_minutes)) + 
  geom_boxplot()  +
  stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
  labs(title=str_c("Experiment-1, ",bxplot_title),x="Qualification Score", y = "Duration (min)")+
  theme_classic()

bxplot_2 <- ggplot(df2_O, aes(x=as.factor(qualification_score),y=duration_minutes)) + 
  geom_boxplot()  +
  stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
  labs(title=str_c("Experiment-2, ",bxplot_title),x="Qualification Score", y = "Duration (min)")+
  theme_classic()

grid.arrange(bxplot_1, bxplot_2, ncol=1)

#We can see that speed to execute tasks does not seem to be distinct across
#scores within the same experiment. Will do an ANOVA to check that.


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
library (gridExtra)
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

df2 <- df2[df2$answer_index==1,]

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

df1 <-
  select(df1,
         'file_name',
         'answer_index',
         'duration')


wilcoxon_results <- wilcox.test(df1$duration,df2$duration)
wilcoxon_results
mean(df2$duration) / mean(df1$duration)

# Wilcoxon rank sum test with continuity correction
# 
# data:  df1$duration and df2$duration
# W = 961500, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0
# 
# > mean(df1$duration)
# [1] 199848.6 milliseconds
# > mean(df2$duration)
# [1] 710940.6 milliseconds
#
# Average duration of the first E2 tasks is 3.5 times the duration of E1 tasks

#-----------------------------------------
#Comparing results without outliers 
#I considered as outliers the tasks that took 10 times the duration for
#which the task was designed for. Since tasks were designed to
#take 5 minutes, I considered 50 minutes tasks as outliers.
#I also considered outliers the task that took 10 times less, i.e.,
#less than 30 seconds

#Outlier limits in milliseconds
upper_limit <- (5*60*1000) * 10
lower_limit <- (5*60*1000) / 10

df1_O <- df1[df1$duration<upper_limit,]
df2_O <- df2[df2$duration<upper_limit,]
wilcox.test(df1_O$duration,df2_O$duration)
mean(df2_O$duration) / mean(df1_O$duration)


# Wilcoxon rank sum test with continuity correction
# data:  df1$duration and df2$duration
# W = 941370, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0
# >  mean(df1_O$duration)
# [1] 164413.7
#   >  mean(df2_O$duration)
# [1] 537197.7

# Average duration of the first E2 tasks is 3.3 times the duration of E1 tasks

"
After removing outliers, the results are similar same.
"

#----------------------------------------------
#Comparing first tasks only
#Do first task in E1 has shorter duration than first tasks in E2?
#Without outliers

df1_first <- df1[df1$answer_index==1,]

#Outlier limits in milliseconds
upper_limit <- (5*60*1000) * 10
lower_limit <- (5*60*1000) / 10

df1_O <- df1_first[df1_first$duration<upper_limit,]
df2_O <- df2[df2$duration<upper_limit,]
wilcox.test(df1_O$duration,df2_O$duration)
mean(df2_O$duration) / mean(df1_O$duration)

# Wilcoxon rank sum test with continuity correction
# 
# data:  df1_O$duration and df2_O$duration
# W = 220730, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0
# 
# > mean(df2_O$duration) / mean(df1_O$duration)
# [1] 1.837933

"
However, when we compare only the first task of each experiment, 
the difference drops to a half. Instead of 3.5 times longer,
E2 first taks as 1.8 longer than the first E1 tasks.

Interpretation.
Need to check if this drop is also present for the other tasks in E1.
If it is not, then being the first tasks has an effect on duration 
that is more than than the time to understand the failure description and the 
the source code. 

This duration cost might relate to getting acquainted with the task 
in terms of information available and usability.

I could show that by:
- comparing first task E2 against mid and last tasks in E1
- testing if subsequent tasks in E1 did not pay this cost.
-?
"
"----------------------------------------------------------"

for (index in c(2:10)) {

  df1_first <- df1[df1$answer_index==index,]
  
  #Remove outliers
  df1_O <- df1_first[df1_first$duration<upper_limit,]
  df2_O <- df2[df2$duration<upper_limit,]
  
  wilcoxon_results <-   wilcox.test(df1_O$duration,df2_O$duration)
  if(wilcoxon_results$p.value<0.05){
    print(str_c(index," YES, significant, p_value = ", wilcoxon_results$p.value))
    print(str_c("Difference between duration means= ",mean(df2_O$duration) / mean(df1_O$duration))) 
  }
  else{    
    print(str_c(index," not significant, p_value = ", wilcoxon_results$p.value))
  }
}

# [1] "2 YES, significant, p_value = 5.97595678910605e-77"
# [1] "Difference between duration means= 2.77051319059703"
# [1] "3 YES, significant, p_value = 4.62799299540337e-82"
# [1] "Difference between duration means= 2.96672086171822"
# [1] "4 YES, significant, p_value = 7.23414568102981e-97"
# [1] "Difference between duration means= 3.52992411453755"
# [1] "5 YES, significant, p_value = 1.55746058155229e-90"
# [1] "Difference between duration means= 3.32550045625148"
# [1] "6 YES, significant, p_value = 3.72604935177152e-101"
# [1] "Difference between duration means= 3.95588046521857"
# [1] "7 YES, significant, p_value = 1.01416175463892e-116"
# [1] "Difference between duration means= 4.44867572509694"
# [1] "8 YES, significant, p_value = 1.6322396411088e-110"
# [1] "Difference between duration means= 4.42124659012653"
# [1] "9 YES, significant, p_value = 1.81292990333869e-113"
# [1] "Difference between duration means= 4.76859370648151"
# [1] "10 YES, significant, p_value = 7.86680781246878e-125"
# [1] "Difference between duration means= 5.58939474342479"

"
First tasks E2 assignments are statistically significant larger than all tasks in E1.
The difference increases from the second to the tenth task.

This might support the idea that first task in E1 and E2 pay 
a cost of the programmer getting acquainted with the task.


"


" ----------------------------------------------------------------"
#BY QUALIFICATION SCORE

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

df2 <- df2[df2$answer_index==1,]
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

#Remove outlier duration in E1 and E2
df1 <- df1[df1$duration_minutes<120,]
df2 <- df2[df2$duration_minutes<120,]

bxplot_1 <- ggplot(df1, aes(x=as.factor(qualification_score),y=duration_minutes)) + 
  geom_boxplot()  +
  stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
  labs(title="Experiment-1",x="Qualification Score", y = "Duration (min)")+
  theme_classic()

bxplot_2 <- ggplot(df2, aes(x=as.factor(qualification_score),y=duration_minutes)) + 
                     geom_boxplot()  +
                     stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
                     labs(title="Experiment-2",x="Qualification Score", y = "Duration (min)")+
                     theme_classic()

grid.arrange(bxplot_1, bxplot_2, ncol=1)

#We can see that speed to execute tasks does not seem to be distinct across
#scores within the same experiment. Will do an ANOVA to check that.


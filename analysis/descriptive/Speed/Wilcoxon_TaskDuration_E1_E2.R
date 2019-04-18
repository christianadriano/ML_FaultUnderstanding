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
library(gridExtra)
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

df1_O <- df1[df1$duration<upper_limit & df1$duration>lower_limit,]
df2_O <- df2[df2$duration<upper_limit & df2$duration>lower_limit,]
wilcox.test(df1_O$duration,df2_O$duration,alternative = c("less"))
mean(df2_O$duration) / mean(df1_O$duration)


# Wilcoxon rank sum test with continuity correction
# data:  df1$duration and df2$duration
# W = 895370, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0
# >  mean(df1_O$duration)
# [1] 228943.2
#   >  mean(df2_O$duration)
# [1] 543566.2

# Average duration of the first E2 tasks is 2.4 times the duration of E1 tasks

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

df1_O <- df1_first[df1_first$duration<upper_limit & df1_first$duration>lower_limit,]
df2_O <- df2[df2$duration<upper_limit  & df2$duration>lower_limit,]
wilcox.test(df1_O$duration,df2_O$duration,alternative = c("less"))
mean(df2_O$duration) / mean(df1_O$duration)

# Wilcoxon rank sum test with continuity correction
# 
# data:  df1_O$duration and df2_O$duration
# W = 212800, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0
# 
# > mean(df2_O$duration) / mean(df1_O$duration)
# [1] 1.71567

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
- comparing first task E2 against mid and last tasks in E1 -  DONE below
- testing if subsequent tasks in E1 did not pay this cost - DONE IN THE ANOVA_taskDurationOrder
"


"---------------------------------------------------------------------"
"How do first tasks in E2 assigment compare with 2nd, 3rd, 4th, 5th, ...,10th tasks in E1 assignment?
I compared individually each task order below.
"

for (index in c(2:10)) {

  df1_first <- df1[df1$answer_index==index,]
  
  #Remove outliers
  df1_O <- df1_first[df1_first$duration<upper_limit & df1_first$duration>lower_limit,]
  df2_O <- df2[df2$duration<upper_limit & df2$duration>lower_limit,]
  
  wilcoxon_results <-   wilcox.test(df1_O$duration,df2_O$duration, alternative = c("less"))
  if(wilcoxon_results$p.value<0.05){
    print(str_c(index," YES, significant, p_value = ", wilcoxon_results$p.value))
    print(str_c("Difference between duration means= ",mean(df2_O$duration) / mean(df1_O$duration))) 
  }
  else{    
    print(str_c(index," not significant, p_value = ", wilcoxon_results$p.value))
  }
}

# [1] "2 YES, significant, p_value = 3.12819668927795e-45"
# [1] "Difference between duration means= 2.23944413562979"
# [1] "3 YES, significant, p_value = 4.60357406440822e-43"
# [1] "Difference between duration means= 2.26523147281561"
# [1] "4 YES, significant, p_value = 3.89573689373137e-50"
# [1] "Difference between duration means= 2.56439530953377"
# [1] "5 YES, significant, p_value = 3.67969503773751e-41"
# [1] "Difference between duration means= 2.33763282303752"
# [1] "6 YES, significant, p_value = 8.21303716450932e-49"
# [1] "Difference between duration means= 2.74068651817819"
# [1] "7 YES, significant, p_value = 1.24709806743117e-51"
# [1] "Difference between duration means= 2.81133977315507"
# [1] "8 YES, significant, p_value = 3.1890143897836e-48"
# [1] "Difference between duration means= 2.83095448691977"
# [1] "9 YES, significant, p_value = 2.82613664894699e-49"
# [1] "Difference between duration means= 3.00174865492852"
# [1] "10 YES, significant, p_value = 2.56304710402206e-59"
# [1] "Difference between duration means= 3.4997112170765"

"
First tasks E2 assignments are statistically significant larger than all tasks in E1.
The difference increases from the second to the tenth task.

This might support the idea that first task in E1 and E2 pay 
a cost of the programmer getting acquainted with the task.


"


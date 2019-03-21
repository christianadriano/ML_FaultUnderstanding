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

library (ggplot2)
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

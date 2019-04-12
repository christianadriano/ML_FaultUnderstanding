"-------------------------------------------------
Were the first tasks slower than the later task in each assignment in E1 and E2?

Since participants in E2 received three tasks about the same source code, 
in the second and third task participants could reuse the knowledge they
acquired in the first task. This implied that the duration of the
second and third task might not comparable with the first task and would
also not be comparable with tasks form E1.

Therefore, before we compare E1 and E2, we first confirmed if
we could only select the first task of each assignment in E2.
---------------------------------------------------
"
library (ggplot2)
library (gridExtra)
library(ufs)
library(userfriendlyscience)
library(farff)
library(pwr)
library(tidyverse) #includes dplyr, stringr,tidyr,ggplot2,tibble,purr,forcats

  
"1. Null-Hypothesis: Do the first, second, and third tasks in E2 
assignments have same duration average?
"

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'file_name',
         'answer_index',
         'duration')

#Outlier treament
upper_limit <- (5*60*1000) * 10 #50 min, which is 10 times the duration for which the task was designed for
lower_limit <- (5*60*1000) / 10 #30 seconds, which is the minimum expected to read test case, questions, and the program statement (3 lines)
df2 <- df2[df2$duration<upper_limit & df2$duration>lower_limit,]


#Run ANOVA for each profession
one_way_matrix <- matrix(list(), nrow=8, ncol=3)
rownames(one_way_matrix) <- file_names_list
colnames(one_way_matrix) <- c("anova","power","boxplot")

posthoc_matrix <- matrix(list(),nrow=8,ncol=3)
rownames(posthoc_matrix) <- file_names_list
colnames(posthoc_matrix) <- c("2-1","3-1","3-2")
posthoc_matrix[] <- c(-1)

print(" ANOVA results, statistically significant?")
for(name in file_names_list){
  df_file <- df2[str_detect(df2$file_name, name), ] #could have used grep too.
  one_way <- oneway(as.factor(df_file$answer_index), y =df_file$duration , posthoc = 'games-howell')
  one_way_matrix[[name,"anova"]] = one_way
  posthoc_matrix[name,] <- one_way$intermediate$posthoc$p
  p.value = one_way$output$dat[1,5]
  if(p.value>0.05){
    print(str_c(name," NO, p_value = ", p.value))
  }
  else{
    power <- pwr.anova.test(k = 3,
                            n = NULL,
                            f = one_way$output$etasq,
                            sig.level = 0.05,
                            power = 0.9)
    one_way_matrix[[name,"power"]] = power
    print(str_c(name," YES, p_value = ", p.value," power.test.n=",power$n))
  }
  
  df_file$answer_index <- as.factor(df_file$answer_index)
  df_file["duration_minutes"] <- df_file$duration / 60000
  
  bxplot <- ggplot(df_file, aes(x=answer_index,y=duration_minutes)) + 
    geom_boxplot()  +
    stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
    labs(title=name,x="Task order", y = "Duration (min)")+
    theme_classic()

  one_way_matrix[[name,"boxplot"]] <- bxplot
}

#Show plots in a grid
p1 <- one_way_matrix[[1,3]]
p2 <- one_way_matrix[[2,3]]
p3 <- one_way_matrix[[3,3]]
p4 <- one_way_matrix[[4,3]]
p5 <- one_way_matrix[[5,3]]
p6 <- one_way_matrix[[6,3]]
p7 <- one_way_matrix[[7,3]]
p8 <- one_way_matrix[[8,3]]
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, ncol=4)



#----------------------------------------------------------
one_way_matrix
# [1] "HIT02_24 YES, p_value = 0.00162582043889594 power.test.n=336.52287990056"
# [1] "HIT01_8 YES, p_value = 7.87121512261683e-05 power.test.n=448.239612674863"
# [1] "HIT03_6 YES, p_value = 0.000550297447160647 power.test.n=2046.71789800071"
# [1] "HIT04_7 YES, p_value = 9.04436167220364e-25 power.test.n=187.807395415615"
# [1] "HIT07_33 YES, p_value = 0.00629661331238729 power.test.n=1040.63901948381"
# [1] "HIT08_54 YES, p_value = 4.7268330054517e-19 power.test.n=148.767950961521"
# [1] "HIT05_35 YES, p_value = 1.87054263374765e-06 power.test.n=189.937402929766"
# [1] "HIT06_51 YES, p_value = 4.22079215924961e-14 power.test.n=144.908512010482"  
#---------------------------------
posthoc_matrix
#             2-1          3-1          3-2       
# HIT02_24 0.003327164  0.04392712   0.8220985 
# HIT01_8  3.158251e-05 0.06458597   0.6990589 
# HIT03_6  0.1390966    0.0001558041 0.04111067 NOT SIGNIFICANT
# HIT04_7  0            0            0.8450548 NOT SIGNIFICANT
# HIT07_33 0.02936537   0.01462503   0.9137894 
# HIT08_54 1.128018e-09 3.785861e-14 0.07407149
# HIT05_35 0.0002471296 5.343122e-05 0.9201399 
# HIT06_51 3.944789e-09 6.639014e-09 0.9497608 
----------------------------------------------------------
  
"
The One Way Anova with Games-Howell correction for post hoc tests showed that 
durations of first was on average longer than the durations of the second 
or third tasks (p-value<0.05). This was true for ALL java methods, but HIT03_6
and HIT04_7.

The posthoc test results could not reject the null-hypothesis that second 
and third task have same duration. Therefore, contrary to the first task effect on duration,
we could not show the order effect on duration effect between second and third task.
There was one exception. Java method HIT03_6 presented statistical significant (p-value=0.03873688)
differences between the duration of the second and third task.

Our interpretation (separate section) is that the difference detected for the first
task is mostly the reading the source code of the Java method and understanding the 
failure. After this cost has been paid in the first task, the cost does not appear
again in the execution of the second and third task. Other researchers could confirm 
this by creating an introductory task in which the programmer does not have to answer
any question, but only read the failure description and the corresponding source code.

The power analysis shows the number of participants needed to detect these 
differences between tasks order in 90% the time. For all bugs except (HIT07_33 and HIT03_6),
the number of participants is in the order or magnitude of the experiment (below 500).
"

"---------------------------------------------------------------------"

"2. Null-Hypothesis: Do the first, second, third, fourth,... tenth tasks in E1 
assignments have same average duration?
"

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_1.arff"
df1 <-  readARFF(file_path)

df1 <-
  select(df1,
         'file_name',
         'answer_index',
         'duration')

#file_names_list <- unique(df1$file_name)

#Run ANOVA for each profession
df1 <- df1[df1$duration<upper_limit & df1$duration>lower_limit,]

print(" ANOVA results, statistically significant?")
#for(name in file_names_list){
#  df_file <- df1[str_detect(df1$file_name, name), ] #could have used grep too.
  one_way <- oneway(as.factor(df1$answer_index), y =df1$duration , posthoc = 'games-howell')
  one_way
  
  p.value = one_way$output$dat[1,5]
  if(p.value>0.05){
    print(str_c(name," NO, p_value = ", p.value))
  }else{
    power <- pwr.anova.test(k = 3,
                            n = NULL,
                            f = one_way$output$etasq,
                            sig.level = 0.05,
                            power = 0.9)
    print(str_c(" YES, p_value = ", p.value," power.test.n=",power$n))
  }
  
  df1$answer_index <- as.factor(df1$answer_index)
  df1["duration_minutes"] <- df1$duration / 60000
  df1 <- df1[df1$duration_minutes<60,] #remove outliers
  
  bxplot <- ggplot(df1, aes(x=answer_index,y=duration_minutes)) + 
    geom_boxplot()  +
    stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
    labs(title="Experiment 1",x="Task order", y = "Duration (min)")+
    theme_classic()
  bxplot
  
  
  
  # Results without removing outliers (tasks that took more than 60 min)
  # The omnibus ANOVA test could not reject the null-hypothesis about task duration by task order in Experiment for most of tasks orders.
  # The only task that has statistically distinct duration is the first task.
  # However, the power test tells that it would require 11K data points
  
  
  #After removing outliers the results were the same. 
  #The ANOVA is statistically significatn (p-value<<0.00001)
  #The power test tells that the it would require 1656 data points.


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

file_names_list <- unique(df2$file_name)

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
# [1] "HIT02_24 YES, p_value = 0.00303130632776475 power.test.n=474.630026036824" 
# [1] "HIT01_8 YES, p_value = 0.00989493481568965 power.test.n=2013.64443545293"  *
# [1] "HIT03_6 YES, p_value = 4.67712942891409e-05 power.test.n=1278.80132666585" *
# [1] "HIT04_7 YES, p_value = 1.65521199301771e-20 power.test.n=313.013734015771"
# [1] "HIT07_33 YES, p_value = 0.00627436413870615 power.test.n=1078.73770890834" *
# [1] "HIT08_54 YES, p_value = 4.5900114447663e-12 power.test.n=393.345865989164"
# [1] "HIT05_35 YES, p_value = 7.52785272866472e-07 power.test.n=195.473929249197"
# [1] "HIT06_51 YES, p_value = 3.33700874443378e-09 power.test.n=394.149502064819"
  
#---------------------------------
posthoc_matrix
#             2-1          3-1          3-2       
# HIT02_24 0.02936214   0.04227035   0.8275387 
# HIT01_8  0.01033781   0.3153392    0.3555685 
# HIT03_6  0.01308726   0.0001438434 0.03873688
# HIT04_7  3.556155e-12 1.519118e-12 0.6734393 
# HIT07_33 0.03052541   0.01406451   0.9038669 
# HIT08_54 3.28382e-06  9.312902e-08 0.05284291
# HIT05_35 0.0005079674 0.0002070275 0.8395715 
# HIT06_51 6.663069e-05 1.624309e-07 0.451744
----------------------------------------------------------
  
"
The One Way Anova with Games-Howell correction for post hoc tests showed that 
durations of first was on average longer than the durations of the second 
or third tasks (p-value<0.05). This was true for ALL java methods.

The posthoc test results could not reject the null-hypothesis that second 
and third task have same duration. Therefore, contrary to the first task effect on duration,
we could not show the order effect on duration effect between second and third task.
There was only one exception. Java method HIT03_6 presented statistical significant (p-value=0.03873688)
differences between the duration of the second and third task.

Our interpretation (separate section) is that the difference detected for the first
task is mostly the reading the source code of the Java method and understanding the 
failure. After this cost has been paid in the first task, the cost does not appear
again in the execution of the second and third task. Other researchers could confirm 
this by creating an introductory task in which the programmer does not have to answer
any question, but only read the failure description and the corresponding source code.

However, to detect this effect in 90% the time, we would need a number 
of participants from 195 (HIT05_35) to 2013 (HIT01_8). This might not be realistic
when one is able to optimize the number of participants needed.

Hence, our conclusion is that even though for three methods there is a significant
difference in duration time between first tasks and the second and third tasks, 
this distinction would not be detected with the number of participants that would
inspect these source code files.
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
df1 <- df1[df1$duration<60000,] #remove outliers

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


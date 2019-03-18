"--------------------------------------------------
Were tasks in E1 executed faster than tasks in E2?
To answer this question I compare the average duration of tasks in E1 and E2.


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

file_names_list <- unique(df2$file_name)

#Run ANOVA for each profession
one.way.matrix <- matrix(list(), nrow=8, ncol=3)
rownames(one.way.matrix) <- file_names_list
colnames(one.way.matrix) <- c("anova","power","boxplot")

print(" ANOVA results, statistically significant?")
for(name in file_names_list){
  df_file <- df2[str_detect(df2$file_name, name), ] #could have used grep too.
  one.way <- oneway(as.factor(df_file$answer_index), y =df_file$duration , posthoc = 'games-howell')
  one.way.matrix[[name,"anova"]] = one.way
  p.value = one.way$output$dat[1,5]
  if(p.value>0.05){
    print(str_c(name," NO, p_value = ", p.value))
  }
  else{
    power <- pwr.anova.test(k = 3,
                            n = NULL,
                            f = one.way$output$etasq,
                            sig.level = 0.05,
                            power = 0.9)
    one.way.matrix[[name,"power"]] = power
    print(str_c(name," YES, p_value = ", p.value," power.test.n=",power$n))
  }
  
  df_file$answer_index <- as.factor(df_file$answer_index)
  df_file["duration_minutes"] <- df_file$duration / 60000
  
  bxplot <- ggplot(df_file, aes(x=answer_index,y=duration_minutes)) + 
    geom_boxplot()  +
    stat_summary(fun.y=mean, geom="point", shape=4, size=2, color="black") +
    labs(title=name,x="Task order", y = "Duration (min)")+
    theme_classic()

  one.way.matrix[[name,"boxplot"]] <- bxplot
}

#Show plots in a grid
p1 <- one.way.matrix[[1,3]]
p2 <- one.way.matrix[[2,3]]
p3 <- one.way.matrix[[3,3]]
p4 <- one.way.matrix[[4,3]]
p5 <- one.way.matrix[[5,3]]
p6 <- one.way.matrix[[6,3]]
p7 <- one.way.matrix[[7,3]]
p8 <- one.way.matrix[[8,3]]
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, ncol=4)



----------------------------------------------------------
# [1] "HIT01_8 YES, p_value = 1.13810014759374e-06 power.test.n=212.951609797782"
# [1] "HIT05_35 YES, p_value = 7.87009607481587e-06 power.test.n=801.95825186607"
# [1] "HIT03_6 YES, p_value = 1.36996333363752e-09 power.test.n=247.272466313301"
# [1] "HIT08_54 YES, p_value = 9.43985297771631e-09 power.test.n=492.112701774917"
# [1] "HIT06_51 YES, p_value = 4.1396396996935e-10 power.test.n=561.100858956688"
# [1] "HIT04_7 YES, p_value = 1.50438817791253e-23 power.test.n=227.885633895706"
# [1] "HIT02_24 YES, p_value = 0.0141069493107821 power.test.n=241.582733560835"
# [1] "HIT07_33 YES, p_value = 0.000514337295933223 power.test.n=402.204641612896"
----------------------------------------------------------
  
"
The One Way Anova with Games-Howell correction for post hoc tests showed that 
duration of first task was on aveage longer than the durations of the second 
and third tasks (p-value<0.05). This is true for all Java methods. The only 
exception was tasks 1 and 3 for Java method HIT07_33 (p-value=0.17)
"

#Boxplot?

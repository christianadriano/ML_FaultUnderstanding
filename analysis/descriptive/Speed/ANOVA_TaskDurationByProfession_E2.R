#---------------------------------------------------------------------
"
Were some professions faster than others?

For this analysis I compared three groups of tasks, the first, second, and third
of each assignment. Since I performed multiple comparisons,I 

"

library(ufs)
library(userfriendlyscience)
library(farff)
library(pwr)
library(tidyverse)


file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'file_name',
         'experience',
         'answer_index',
         'duration')

#Replace Other * experience to simply other.
df2[grep("Other",df2$experience),"experience"] <-"Other"

df2 <- df2[df2$answer_index=='1',]
df2["duration_minutes"] <- df2$duration / 60000

#Run ANOVA for each profession
# one.way.matrix <- matrix(list(), nrow=5, ncol=2)
# rownames(one.way.matrix) <- profession_names
# colnames(one.way.matrix) <- c("anova","power")

print(" ANOVA results, statistically significant?")
one.way <- oneway(as.factor(df2$experience), y =df2$duration , posthoc = 'games-howell')
one.way
#one.way.matrix[[profession,"anova"]] = one.way
p.value = one.way$output$dat[1,5]
if(p.value>0.05){
  print(str_c(profession," NO, p_value = ", p.value))
}else{
  power <- pwr.anova.test(k = 3,
                          n = NULL,
                          f = one.way$output$etasq,
                          sig.level = 0.05,
                          power = 0.9)
#  one.way.matrix[[profession,"power"]] = power
  print(str_c(profession," YES, p_value = ", p.value," power.test.n=",power$n))
}


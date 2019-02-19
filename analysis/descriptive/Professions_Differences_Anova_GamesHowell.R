# ANOVA Games-Howell Post-Hoc Test
# https://rpubs.com/aaronsc32/games-howell-test

install.packages("userfriendlyscience")
install.packages("farff")
install.packages("ufs")
library(ufs)
library(userfriendlyscience)
library(farff)
library(ggplot2)

file_path <-  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df <-  readARFF(file_path)

#Replace Other * experience to simply other.
df[grep("Other",df$experience),"experience"] <-"Other"

df_male <-  df[df$gender == "Male",]
df_female <-  df[df$gender == "Female",]

profession_names <-  c("Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other")
male_profession_ages_list <- vector(mode="list", length=length(profession_names))
names(male_profession_ages_list) <- profession_names
for(profession in profession_names){
  male_profession_ages_list[[profession]] = df_male[grep(profession,df_male$experience),"age"]
}


df_male_data = df_male[,c("experience","age")]
df_male_data$experience <- as.factor(df_male_data$experience)

one.way <- oneway(df_male_data$experience, y =df_male_data$age , posthoc = 'games-howell')
one.way


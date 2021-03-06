# ANOVA Games-Howell Post-Hoc Test
# https://rpubs.com/aaronsc32/games-howell-test

install.packages("userfriendlyscience")
install.packages("farff")
install.packages("ufs")
library(ufs)
library(userfriendlyscience)
library(farff)
library(ggplot2)
library(pwr)

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


#Profession and age
df_male_data = df_male[,c("experience","age")]
df_male_data$experience <- as.factor(df_male_data$experience)

one.way <- oneway(df_male_data$experience, y =df_male_data$age , posthoc = 'tukey')
#little difference between Tukey and Games-Howell. Tukey assumes homoscedacity. 

one.way <- oneway(df_male_data$experience, y =df_male_data$age , posthoc = 'games-howell')
one.way
#power calculations
pwr.anova.test(k = length(profession_names),
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)

df_female_data = df_female[,c("experience","age")]
df_female_data$experience <- as.factor(df_female_data$experience)
one.way <- oneway(df_female_data$experience, y =df_female_data$age , posthoc = 'tukey')
#little difference between Tukey and Games-Howell. Tukey assumes homoscedacity. 

one.way <- oneway(df_female_data$experience, y =df_female_data$age , posthoc = 'games-howell')
one.way
#power calculations
pwr.anova.test(k = length(profession_names),
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)

#Regardless of gender
df_data = df[,c("experience","age")]
df_data$experience <- as.factor(df_data$experience)
one.way <- oneway(df_data$experience, y =df_data$age , posthoc = 'tukey')
#Tukey and Games-Howell provided the same results.
one.way <- oneway(df_data$experience, y =df_data$age , posthoc = 'games-howell')
one.way
#Power calculations
pwr.anova.test(k = length(profession_names),
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)

#Profession and Years of Experience
df_male_data = df_male[,c("experience","years_programming")]
df_male_data$experience <- as.factor(df_male_data$experience)
one.way <- oneway(df_male_data$experience, y =df_male_data$years_programming , posthoc = 'tukey')
#Tukey and Games-Howell provided the same results.

one.way <- oneway(df_male_data$experience, y =df_male_data$years_programming , posthoc = 'games-howell')
one.way
#Power calculations
pwr.anova.test(k = length(profession_names),
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)

df_female_data = df_female[,c("experience","years_programming")]
df_female_data$experience <- as.factor(df_female_data$experience)
one.way <- oneway(df_female_data$experience, y =df_female_data$years_programming , posthoc = 'tukey')
#Tukey also gave larger p-value than Games-Howell
#Female Undergraduate_Student-Hobbyist, Tukey = 0.059, while Games-Howell=0.003 (hence Type-2 error)

one.way <- oneway(df_female_data$experience, y =df_female_data$years_programming , posthoc = 'games-howell')
one.way
#Power calculations
pwr.anova.test(k = length(profession_names),
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)

#Regardless of gender
df_data = df[,c("experience","years_programming")]
df_data$experience <- as.factor(df_data$experience)
one.way <- oneway(df_data$experience, y =df_data$years_programming , posthoc = 'tukey')
#Tukey and Games-Howell provided the same results.

one.way <- oneway(df_data$experience, y =df_data$years_programming , posthoc = 'games-howell')
one.way
#Power calculations
pwr.anova.test(k = length(profession_names),
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)

#Profession score
df_data = df[,c("experience","qualification_score")]
df_data$experience <- as.factor(df_data$experience)
one.way <- oneway(df_data$experience, y =df_data$qualification_score , posthoc = 'tukey')
#Tukey and Games-Howell provided the same results.

one.way <- oneway(df_data$experience, y =df_data$qualification_score , posthoc = 'games-howell')
one.way
#Power calculations
pwr.anova.test(k = length(profession_names),
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)

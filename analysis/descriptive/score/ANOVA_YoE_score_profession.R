#Are YoE distinct across qualification score levels for any of the professions?
#Are YoE distinct across qualification score levels for any of the genders?

#This analysis is particular for E2 experiment

#------------------------------------------------------
# Distinction for professionals

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'worker_id',
         'session_id',
         'microtask_id',
         'qualification_score',
         'years_programming')

#Replace Other * experience to simply other.
df2[grep("Other",df2$experience),"experience"] <-"Other"

profession_names <-  c("Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other")

male_profession_ages_list <- vector(mode="list", length=length(profession_names))
names(male_profession_ages_list) <- profession_names

#Run ANOVA for each profession
for(profession in profession_names){
  df_prof <- df2[df2$experience]
}



one.way <- oneway(as.factor(df2$qualification_score), y =df2$years_programming , posthoc = 'tukey')
#Tukey and Games-Howell provided the same results.

one.way <- oneway(as.factor(df2$qualification_score), y =df2$years_programming , posthoc = 'games-howell')
one.way

#Power calculations
pwr.anova.test(k = 3,
               n = NULL,
               f = one.way$output$etasq,
               sig.level = 0.05,
               power = 0.9)

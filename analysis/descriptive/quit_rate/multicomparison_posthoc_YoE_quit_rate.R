" 
Did certain participants with more YoE quit earlier?

Analyses only for Experiment-2 (E2), because E1 did not have information about professions
"

library(ufs)
library(userfriendlyscience)
library(farff) #all for reading arff file

library(dplyr) #for select and ddply
library(reshape2) #for dcast

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//consolidated_Final_Experiment_2.arff"
df2 <-  readARFF(file_path)

df2 <-
  select(df2,
         'worker_id',
         'session_id',
         'microtask_id',
         'years_programming')

#counts the number of microtasks executed by each worker_id and session_id
df_group <-
  ddply(df2,
        worker_id ~ session_id ~ years_programming,
        summarise,
        tasks = length(unique(microtask_id)))

df_group['incomplete'] <- 3 - df_group$tasks
df_YoE = select(df_group,years_programming,incomplete)
df_pivot = dcast(df_YoE,incomplete~years_programming,length)

to_drop <- c("incomplete")
df_pivot <- df_pivot[,!names(df_pivot) %IN% to_drop]
mat <- as.matrix(df_pivot)

plot(df_pivot[1,])

#Need to adjust number of incomplete tasks by the total of tasks for each YoE level
#df_p_pivot <- tibble("incomplete" = c(0:2))
mat.length = dim(mat)[2]

for(i in 1:mat.length){
  mat_p[,i] <- as.numeric(mat[,i])/sum(as.numeric(mat[,i]))
}
  
YoE_levels <- as.numeric(colnames(mat_p))
Total_Assignments <- colSums(df_pivot)
#Is there a correlation between YoE and the number of assignements?
cor.test(YoE_levels,Total_Assignments,method="kendall")
#YES, z = -2.7345, p-value = 0.006248, kendall-tau = -0.327968 (medium correlation)

# test if YoE is correlated with rate of incomplete assignments
cor.test(YoE_levels,mat_p[3,],method="kendall")

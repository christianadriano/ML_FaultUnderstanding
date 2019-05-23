" 
Did participants with less experience quit more and earlier?

YES, when taken only the people who quit at certain point, YoE is inversely correlated with number of
incomplete assignments.The correlations are statistically significant (p-value<0.05) and they are strong 
(tau>0.45). These results are true for both levels of incomplete assignments, i.e., 
one or two incomplete tasks.

Comparing both correlations, we can also infer that participants with lower YoE quit earlier.

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
#YES, z = -2.7345, p-value = 0.006248, kendall-tau = -0.327968 (Medium correlation)



#------------------------------------------

#Do the same tests now only looking at the people who quit at a certain point.
df_quitters <- df_pivot[,!sapply(df_pivot,function(x) x[2]==0 && x[3]==0)]

YoE_levels <- as.numeric(colnames(df_quitters))

#Is there correlation between YoE and proportion of assignments with one incomplete task? 
#YES, z = -3.1358, p-value = 0.001714, kendall-tau = -0.4672749 (STRONG)
cor.test(YoE_levels,as.numeric(df_quitters[2,]),method="kendall")

#Is there correlation between YoE and proportion of assignments with two incomplete task? 
#YES, z = -3.1801, p-value = 0.001472, kendall-tau = -0.4992019 (STRONG)
cor.test(YoE_levels,as.numeric(df_quitters[3,]),method="kendall")

plot(YoE_levels,as.numeric(df_quitters[2,]))
plot(YoE_levels,as.numeric(df_quitters[3,]))

#-----------------------------------------

"
Test if YoE is correlated with rate of incomplete assignments inclusive the 
completed ones (which might distort the analysis, because there are 10 out of 35 YoE levels
which show zero assignments with any incomplete tasks.
"

#Is there correlation between YoE and proportion of assignments with one incomplete task? 
#NO, p-value=0.6762
cor.test(YoE_levels,mat_p[2,],method="kendall")

#Is there correlation between YoE and proportion of assignments with two incomplete task? 
#YES, z = -2.7961, p-value = 0.005173, tau=-0.3679905 (Medium)
cor.test(YoE_levels,mat_p[3,],method="kendall")

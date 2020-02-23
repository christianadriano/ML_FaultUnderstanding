"
-------------------------------------------------------
Loads the ground truth for both experiments E1 and E2.
Stores the data as a new column in the data frame 
Colunm name is 'ground_truth'

This script also evaluates each answer against the grond truth.
The result ist stored in a new data frame column named 'answer_correct'
The values of this colums are 'TRUE' or 'FALSE'

For E1, the following comparision give a TRUE value for 'answer_correct':
if ((answer = YES OR PROBABLY_YES) AND ground_truth = YES)
if ((answer = NO or PROBABLY_NOT or IDK) AND grond_truth = NO)

Any other condition, gives FALSE value to 'answer_correct'

This is similar to E2, with the difference that in E2, there are
only three types of answer (YES, NO, IDK)
------------------------------------------------------
"

library (ggplot2)
library (gridExtra)
library(farff)
library(tidyverse) #includes dplyr, stringr,tidyr,ggplot2,tibble,purr,forcats
library(dplyr)

path <- "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//"

"
Load Ground Truth to E2 data
"

df2 <- readARFF(str_c(path, "//consolidated_Final_Experiment_2.arff"))
gt2 <- read.csv(str_c(path, "//ground_truth_E2.csv"))

gt2 <- dplyr::select(gt2, ID,LineID,isBugCovering,type,faulty_lines,all_Lines,LOC_inspection,LOC_original)



"join file_name,microtask_id bugID,ID"
gt2$ID <- as.factor(gt2$ID) #convert to factor I can join with microtask_id column
df2_ground <- left_join(df2,gt2,by=c("microtask_id"="ID"))

"
Apply Ground Truth to E2 data
"
isCorrectList <- (df2_ground$answer=="YES_THERE_IS_AN_ISSUE" &  df2_ground$isBugCovering) |
  ((df2_ground$answer=="NO_THERE_IS_NOT_AN_ISSUE" | df2_ground$answer=="I_DO_NOT_KNOW") &  df2_ground$isBugCovering =="no")

df2_ground$isAnswerCorrect <- isCorrectList



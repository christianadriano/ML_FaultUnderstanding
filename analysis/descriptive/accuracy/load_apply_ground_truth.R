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

path <- "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//"

"
Load and Apply Ground Truth for E2
"

df2 <- readARFF(str_c(path, "//consolidated_Final_Experiment_2.arff"))
gt2 <- read.csv(str_c(path, "//ground_truth_E2.csv"))

"join file_name,microtask_id bugID,ID"

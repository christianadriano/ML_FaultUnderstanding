# ML_FaultUnderstanding

## Goal: 
Investigate the factors that impact the accuracy of fault understanding (ability to recognize the code that is causing a software failure). The analyzed factors consist of attributes of programmers (profession, year of experience, coding ability) and tasks (duration, confidence, difficulty).

## Metrics:
* Quit rate
* Task uptake rate
* Qualification score
* Task duration
* Explanation size
* Inter-rater reliability

## Data: 
Two experiments on identifying the code that is causing a software failure. 
Experiments:
* E1: 5405 tasks, 777 programmers, 10 real failures from 10 popular open source projects
* E2: 2580 tasks, 497 programmers, 8 real failures from 5 popular open source projects

## Analysis methods:
Experiments replication, descriptive statistics (ANOVA, Chi2square, Wilcoxon), correlation Analysis (Kendall-tau), predictive models (logistic regression,Random Forest). 

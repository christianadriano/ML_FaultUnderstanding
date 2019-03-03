#compute chi-square test for gender and professions

#First way of doing it
female_participants <- c(44,28,18,27,16);
male_participants <-  c(125,83,45,89,20);
participants <- rbind(female_participants,male_participants);
inv_part <- cbind(female_participants,male_participants);

colnames(participants) <- c("ProfessionalDeveloper","Hobbyist","GraduateStudent","UndergraduateStudent","Other");
rownames(participants) <- c("females","males");
tbl <- as.table(participants)

chisq = chisq.test(inv_part, correct = FALSE)
chisq

#Second way of doing it

mat <- matrix(c(44,28,18,27,16,125,83,45,89,20),nrow = 5)
tbl <- as.table(mat)
rownames(tbl) <- c("ProfessionalDeveloper","Hobbyist","GraduateStudent","UndergraduateStudent","Other");
colnames(tbl) <- c("females","males");
tbl
chitest <- chisq.test(tbl)
chitest
#X-squared = 6.7268, df = 4, p-value = 0.151
#Hence, we cannot ascertain that there is a gender imbalance in the professions surveyed, which
#is a surprising result. Follows that proportions of males and females across the professions.


#ANALYSIS WITHOUT "OTHER" profession 
#Since the Other group is particularly small, we decided to evaluate if it is skewing the relationship 
#between Gender and Profession.

#
mat <- matrix(c(44,28,18,27,125,83,45,89),nrow = 4)
tbl <- as.table(mat)
rownames(tbl) <- c("ProfessionalDeveloper","Hobbyist","GraduateStudent","UndergraduateStudent");
colnames(tbl) <- c("females","males");
tbl
chitest <- chisq.test(tbl)
chitest
#X-squared = 0.64496, df = 3, p-value = 0.8861
#Even after removing OTHER, there is no particular concentrantion of gender by profession.
#i.e., genders seem to have similar proportions across professions, i.e., gender and profession are independent.
"
Correlations in the Consent Data from E1

TODO:
(DONE)- Add adjusted_score to the df_consent
(DONE)- Compute correlation matrix
(DONE)- Plot matrix
(DONE)- For the non-significant correlations, run TOST (assuming effect less than small)
(DONE) Discuss the absence of a relationship of age with score and duration
- Condition score on yoe so we can measure the relationship of age->score unconfounded by yoe,
same for test_duration.
- Explain and Discuss the Equivalence Test
- Choose a correlation graphical plot to be used

"
#install.packages("TOSTER")
library(TOSTER)
library(dplyr)
#install.packages("Hmisc") #to compute the correlations with the significance levels
library(Hmisc)
#install.packages("corrplot")
library(corrplot)

#----------------------------------------------

"Load data with treatment field (isBugCovering) and ground truth (answer correct)"
source("C://Users//Christian//Documents//GitHub//CausalModel_FaultUnderstanding//data_loaders//load_consent_create_indexes_E1.R")
df_consent <- load_consent_create_indexes()

#compute correlations between qualification_score, adjusted_score, profession_level,test_duration, age, years_programming 
df_data <- df_consent%>%select(adjusted_score,test_duration, age, years_programming)

#--------------------------------------
#CORRELATION MATRIX

#Using Spearman because all data sets failed the Shapiro-Wilk normality test (p-value<0.05)

# mat : is a matrix of data
# ... : further arguments to pass to the native R cor.test function
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  r.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  diag(r.mat) <- 1
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], method=c("kendall"), ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
      r.mat[i, j] <- r.mat[j, i] <- tmp$estimate
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  colnames(r.mat) <- rownames(r.mat) <- colnames(mat)
  return(list(r.mat,p.mat))
}


# matrix of the p-value of the correlation
list_mat <- cor.mtest(df_data)
r.mat <- list_mat[[1]]
p.mat <- list_mat[[2]]
head(p.mat)
head(r.mat)


#The only two non-significant correlations are:
#   row                column   cor            p
# adjusted_score        age  -0.018539331  5.751414e-01
# test_duration         age  -0.003175597  9.183911e-01

"
This indicates that age is not a factor that could be manipulated to interfere in 
the efficacy (adjusted_score) and efficiency (test_duration). Because age cannot be determined by 
any other feature that was part of the experiment, the imbalance can only originate from selection bias
and not confounding. Hence, I investigate the type of selection bias that could lead to 
masking the relationship of age with adjusted_score and test_duration. 

One plausible alternative is that year os experience could determine age via selection bias and
score via a causal relationship, i.e., given the following graph: age<-yoe->score 

Selection bias could emerge from certain people self-selecting to participate in the experiment.
These people would have a particular distribution of years of programming experience and age.

So, what might be happenin is that as yoe increases
the score increases (tau= 0.17, p-value<0.05). However if yoe->age is positive (tau=0.13, p-value<0.05),
than age also increases. However, if age has a negative real (unconfounded) correlation with score,
then, age->score will be cancelled out by the yoe->age. To test this, we need to fix yoe, which
is the same as conditioning.

The age of these people are  This particular group has a relationship with age,
so yoe->age. However, because yoe has a correlation with the score and duration, this effect might
be masking the effect of age on score (age->score). e.g., 


"


#----------------------------------------------------------

#EQUIVALENCE TEST
#Documentation https://github.com/Lakens/TOSTER/blob/master/tests/testthat/test-data_summary_equivalent.R

results <- dataTOSTr(data=df_data,
                     pairs=list(list(i1="adjusted_score",i2="age")),
                          low_eqbound_r = -0.3, 
                          high_eqbound_r = 0.3, alpha=0.05, 
                          desc=TRUE, plots=TRUE)

results

# -----------------------------------------------------------------------------------
#                                                       90% confidence interval
# -----------------------------------------------------------------------------------
# Equivalence Bounds          Low           High         Lower           Upper        
# -----------------------------------------------------------------------------------
# adjusted_score    age    -0.3000000    0.3000000    -0.04095798     0.1082798   
# -----------------------------------------------------------------------------------
#Correlation CI crosses zero, hence the correlation is equivalent to zero.

results <- dataTOSTr(data=df_data,
                     pairs=list(list(i1="test_duration",i2="age")),
                     low_eqbound_r = -0.3, 
                     high_eqbound_r = 0.3, alpha=0.05, 
                     desc=TRUE, plots=TRUE)

results
#---------------------------------------------------------------------------          
#Correlation CI crosses zero, hence the correlation is zero.
# -----------------------------------------------------------------------------------
#                                                       90% confidence interval
# -----------------------------------------------------------------------------------
# Equivalence Bounds          Low           High         Lower           Upper        
# -----------------------------------------------------------------------------------
# test_duration    age    -0.3000000    0.3000000    -0.01226132      0.1365663   
# -----------------------------------------------------------------------------------
#Correlation CI crosses zero, hence the correlation is equivalent to zero.


# ++++++++++++++++++++++++++++
# flattenCorrMatrix
# source: http://www.sthda.com/english/wiki/correlation-matrix-a-quick-start-guide-to-analyze-format-and-visualize-a-correlation-matrix-using-r-software
# ++++++++++++++++++++++++++++
# cormat : matrix of the correlation coefficients
# pmat : matrix of the correlation p-values
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}
f <- flattenCorrMatrix(r.mat, p.mat)
write.csv(f,"C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//analysis//correlation//output//Consent_KendallCorrelation_E1.csv")

#----------------------------------------------------------------------
col<- colorRampPalette(c("red", "grey", "blue"))(20)
corrplot(r.mat, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45, method="number", col=col)


col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(r.mat, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat, sig.level = 0.05, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE 
)

#--------------------------------------------------------
#Hybrid PLOT

#install.packages("PerformanceAnalytics")
library("PerformanceAnalytics")
chart.Correlation(df_data, histogram=TRUE, pch="+", method="kendall")

#--------------------------------------------------------
#HEAT MAP (Not USED)

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = r.mat, col = col, symm = TRUE)

"
Correlations in the Consent Data from E2

TODO:
- Compute correlation matrix
- Plot matrix
(DONE)- For the non-significant correlations, run TOST (assuming effect less than small)

"
#install.packages("TOSTER")
library(TOSTER)
library(dplyr)
install.packages("Hmisc") #to compute the correlations with the significance levels
library(Hmisc)
install.packages("corrplot")
library(corrplot)

#----------------------------------------------

"Load data with treatment field (isBugCovering) and ground truth (answer correct)"
source("C://Users//Christian//Documents//GitHub//CausalModel_FaultUnderstanding//data_loaders//load_consent_create_indexes_E2.R")

df_consent$profession_level <- as.numeric(df_consent$profession_id)

#compute correlations between qualification_score, adjusted_score, profession_level,test_duration, age, years_programming 
df_data <- df_consent%>%select(adjusted_score, profession_level,test_duration, age, years_programming)
df_data$profession_level <- 7-df_data$profession_level #so it is incremental (higher skill, larger level)

colnames(df_data)
#using Spearman because all data sets failed the Shapiro-Wilk normality test (p-value<0.05)
corr_matrix <- cor.test(df_data$adjusted_score,df_data$profession_level,method=c("kendall"))
corr_matrix$estimate

#The only two non-significant correlations are:
#   row                column   cor            p
# qualification_score   age  0.03906618 9.866124e-02
# adjusted_score        age  0.03805823 1.076732e-01


#EQUIVALENCE TEST
#Documentation https://github.com/Lakens/TOSTER/blob/master/tests/testthat/test-data_summary_equivalent.R

results <- dataTOSTr(data=df_data,
                     pairs=list(list(i1="adjusted_score",i2="age")),
                          low_eqbound_r = -0.3, 
                          high_eqbound_r = 0.3, alpha=0.05, 
                          desc=TRUE, plots=TRUE)

results
# -------------------------------------------------------------------
# TOST Results                              r             p            
# -------------------------------------------------------------------
# adjusted_score    age    Pearson's r    0.03558930     0.1325019   
#                          TOST Upper     0.03558930    < .0000001   
#                          TOST Lower     0.03558930    < .0000001  
# -------------------------------------------------------------------
# The p-values for Upper and Lower show that the correlation is bettwen lower and upper.

# -----------------------------------------------------------------------------------
#                                                       90% confidence interval
# -----------------------------------------------------------------------------------
# Equivalence Bounds          Low           High         Lower           Upper        
# -----------------------------------------------------------------------------------
# adjusted_score    age    -0.3000000    0.3000000    -0.003327777    0.07439874   
# -----------------------------------------------------------------------------------
#Correlation CI crosses zero, hence the correlation is zero.

#---------------------------------------------------------------------------          


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
flattenCorrMatrix(corr_matrix$r, corr_matrix$P)

corrplot(corr_matrix$r, type = "upper", order = "hclust", 
        tl.col = "black", tl.srt = 45)

col<- colorRampPalette(c("red", "grey", "blue"))(20)

corrplot(corr_matrix$r, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45, method="number", col=col)

corrplot(corr_matrix$P, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45, method="number", col=col)

#----------------------------------------------------------------------

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
  return(list(r.mat,p.mat))
}
# matrix of the p-value of the correlation
list_mat <- cor.mtest(df_data)
p.mat <- list_mat[[1]]
r.mat <- list_mat[[2]]
head(p.mat)
head(r.mat)


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
#HEAT MAP

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = r.mat, col = col, symm = TRUE)

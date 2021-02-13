"
Correlations in the Consent Data from E2

TODO:
- Compute correlation matrix
- Plot matrix
- For the non-significant correlations, run TOST (assuming effect less than small)

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
corr_matrix <- rcorr(as.matrix(df_data),type="spearman")
corr_matrix

#The only two non-significant correlations are:
#   row                column   cor            p
# qualification_score   age  0.03906618 9.866124e-02
# adjusted_score        age  0.03805823 1.076732e-01


#EQUIVALENCE TEST

results <- dataTOSTr(data=df_data,
                     pairs=list(list(i1="adjusted_score",i2="age")),
                          low_eqbound_r = -0.3, 
                          high_eqbound_r = 0.3, alpha=0.05, 
                          desc=TRUE, plots=TRUE)
          

results
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

#--------------------------------------------------------
#Hybrid PLOT

install.packages("PerformanceAnalytics")
library("PerformanceAnalytics")
chart.Correlation(df_data, histogram=TRUE, pch="+", method="kendall")

#--------------------------------------------------------
#HEAT MAP

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = corr_matrix$r, col = col, symm = TRUE)

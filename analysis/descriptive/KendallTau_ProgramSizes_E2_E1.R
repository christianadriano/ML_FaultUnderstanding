"
Correlation analyzes of LOC, lines, words, and characters for E2 and E1

LOC = Lines of Code
Lines = LOC + javadoc comments
Words = words
Characters = all non-blank space characters
"

file_path <-
  "C://Users//Christian//Documents//GitHub//ML_FaultUnderstanding//data//program_size_E2_csv.csv"

df2 <- read.csv(file_path,header = TRUE,sep=",")

df2
# bugID LOC Lines Words Characters
#   1   23    54   337       2484
#   2    7    13    58        438
#   3   23    31   162       1249
#   4   78    78   241       2641
#   5    7    33   266       1667
#   6   28    28   106        665
#   7   12    21   108        831
#   8   33    62   332       2426


shapiro.test(df2$LOC)
#Not Normal, W = 0.7894, p-value = 0.02202

shapiro.test(df2$Lines)
#Normal, W = 0.93028, p-value = 0.5186

shapiro.test(df2$Words)
#Normal, W = 0.91483, p-value = 0.3893

shapiro.test(df2$Characters)
#Normal, W = 0.8937, p-value = 0.2532

cor.test(df2$LOC,df2$Lines,method=c("kendall"))
# z = 2.0105, p-value = 0.04438
# tau = 0.5929995 

cor.test(df2$LOC,df2$Words,method=c("kendall"))
# z = 0.75394, p-value = 0.4509
# tau = 0.2223748 NOT Significant

cor.test(df2$LOC,df2$Characters,method=c("kendall"))
# z = 1.5079, p-value = 0.1316
# tau = 0.4447496 NOT Significant

cor.test(df2$Lines,df2$Words,method=c("kendall"))
# T = 23, p-value = 0.03115
# tau = 0.6428571 

cor.test(df2$Lines,df2$Characters,method=c("kendall"))
# T = 26, p-value = 0.001736
# tau = 0.8571429

cor.test(df2$Words,df2$Characters,method=c("kendall"))
# T = 25, p-value = 0.005506
# tau = 0.7857143

"
LOC is not correlated with characters, or words. This means that 
when ranking the programs by LOC is different than ranking by 
words or characters. Since Characters, Lines, and Words are 
strongly correlated with each other, I would replace LOC size 
measure with lines
analyzes with LOC with
with both Words and Lines, one could use Characters to have 

"

df2_plot <- select(df2,LOC,Lines,Words,Characters)
plot(df2_plot, main="Experiment-2 Program size measure correlations")
"Char clearly shows that LOC is not correlated with the other measures,
whereas Line, Words, and Characters are correlated."

#---------------------------------------------------------------------------
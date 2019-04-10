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
#   1   23    54   306       2484
#   2    7    13    52        438
#   3   23    31   154       1249
#   4   78    78   241       2641
#   5    7    33   240       1667
#   6   28    28   106        665
#   7   12    21    99        831
#   8   33    62   303       2426


shapiro.test(df2$LOC)
#Not Normal, W = 0.7894, p-value = 0.02202

shapiro.test(df2$Lines)
#Normal, W = 0.93028, p-value = 0.5186

shapiro.test(df2$Words)
#W = 0.90901, p-value = 0.3471

shapiro.test(df2$Characters)
#Normal, W = 0.8937, p-value = 0.2532

cor.test(df2$LOC,df2$Lines,method=c("kendall"))
# z = 2.0105, p-value = 0.04438
# tau = 0.5929995 

cor.test(df2$LOC,df2$Words,method=c("kendall"))
#z = 1.2566, p-value = 0.2089
# tau = 0.3706247 NOT Significant

cor.test(df2$LOC,df2$Characters,method=c("kendall"))
# z = 1.5079, p-value = 0.1316
# tau = 0.4447496 NOT Significant

cor.test(df2$Lines,df2$Words,method=c("kendall"))
# T = 25, p-value = 0.005506
# tau = 0.7857143 

cor.test(df2$Lines,df2$Characters,method=c("kendall"))
# T = 26, p-value = 0.001736
# tau = 0.8571429

cor.test(df2$Words,df2$Characters,method=c("kendall"))
# T = 25, p-value = 0.005506
# tau = 0.7857143

"
LOC is not correlated with Characters, or Words. This means that 
when ranking the programs by LOC is different than ranking by 
Words. or Characters Since Characters, Lines, and Words are 
strongly correlated with each other, I would replace LOC size 
measure with Lines or Words.
"

df2_plot <- select(df2,LOC,Lines,Words,Characters)
plot(df2_plot, main="Experiment-2 Program size measure correlations")
"Char clearly shows that LOC is not correlated with the other measures,
whereas Line, Words, and Characters are correlated."

#---------------------------------------------------------------------------
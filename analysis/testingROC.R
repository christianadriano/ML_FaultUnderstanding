
install.packages("pROC")
library(pROC)

mydata <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")
mylogit <- glm(admit ~ gre, data = mydata, family = "binomial")
summary(mylogit)
prob=predict(mylogit,type=c("response"))
mydata$prob=prob
library(pROC)
g <- roc(admit ~ prob, data = mydata)
plot(g)
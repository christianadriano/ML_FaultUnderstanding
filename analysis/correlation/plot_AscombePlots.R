"
Plots the Anscombe's quartet (http://en.wikipedia.org/wiki/Anscombe%27s_quartet)

TODO:
- add pearson correlation values  DONE
- make background lighter DONE
- add title DONE
- make lines thinner DONE
- compute Spearman correlations DONE
- compute Kendall-tau correlations 
- plot values of Spearman correlations and Kendall-Tau


This plot is used to discuss possible spurious correlation between 
accuracy and certain task attributes like explanation size and difficulty.


"
library(ggplot2)
library(dplyr)
library(tidyr)



head(anscombe)

##   x1 x2 x3 x4   y1   y2    y3   y4
## 1 10 10 10  8 8.04 9.14  7.46 6.58
## 2  8  8  8  8 6.95 8.14  6.77 5.76
## 3 13 13 13  8 7.58 8.74 12.74 7.71
## 4  9  9  9  8 8.81 8.77  7.11 8.84
## 5 11 11 11  8 8.33 9.26  7.81 8.47
## 6 14 14 14  8 9.96 8.10  8.84 7.04

#reshaped into tidy form (http://www.jstatsoft.org/v59/i10/paper)

anscombe_tidy <- anscombe %>%
  mutate(observation = seq_len(n())) %>%
  gather(key, value, -observation) %>%
  separate(key, c("variable", "set"), 1, convert = TRUE) %>%
  mutate(set = c("set I", "set II", "set III", "set IV")[set]) %>%
  spread(variable, value)

head(anscombe_tidy)

#   observation     set  x    y
# 1           1   set I 10 8.04
# 2           1  set II 10 9.14
# 3           1 set III 10 7.46
# 4           1  set IV  8 6.58
# 5           2   set I  8 6.95
# 6           2  set II  8 8.14

anscombe_tidy


cor.test(anscombe_tidy$x,anscombe_tidy$y,method="pearson",alternative =
    "two.sided")
# data:  anscombe_tidy$x and anscombe_tidy$y
# t = 9.1608, df = 42, p-value = 1.437e-11
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#   0.6856660 0.8960719
# sample estimates:
#   cor 
# 0.8163662

cor.test(df$x,df$y,method="spearman",alternative =
           "two.sided")

# set I: rho = 0.8181818, p-value = 0.003734
# set II: rho = 0.6909091, p-value = 0.02306
# set III: rho 0.9909091, p-value < 2.2e-16 
# set IV: rho = 0.5 , p-value=0.1173


#--------------------------------

plot <- ggplot(anscombe_tidy, aes(x, y)) +
  geom_point() +
  ggtitle("Anscombe's quadrants - same Pearson correlation for distinct sets")+
  facet_wrap(~ set) +
  theme_minimal()+
  annotate("text", x = 15, y = 6, label = "italic(R) == 0.816",parse=TRUE)+
  geom_smooth(method = "lm",linetype=2, size=0.3,se = FALSE)

ggsave(dpi=300, filename = ".\\output\\ascombes_quadrants.png")

plot <- ggplot(anscombe_tidy, aes(x, y)) +
  geom_point() +
  ggtitle("Anscombe's quadrants - Spearman correlations")+
  facet_wrap(~ set) +
  theme_minimal()+
  annotate("text", x = 15, y = 6, label = "italic(R) == 0.816",parse=TRUE)+
  geom_smooth(method = "lm",linetype=2, size=0.3,se = FALSE)
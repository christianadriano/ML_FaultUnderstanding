#Quit rate correlations (kendall-tau)
#No statistically significant correlations, even after removing outliers.

E1_locs <-  c(6,62,2,19,8,34,7,6,41)
E1_quit_rate <- c(18,7,3,2,1,1,1,1,1)

kendall_tau_1 <- cor.test(E1_locs,E1_quit_rate,method=c("kendall"))
kendall_tau_1

#z = -0.34731, p-value = 0.7284, tau = -0.09944903 

E2_locs <-  c(23,78,23,3,7,28,12,33)
E2_quit_rate <- c(45,21,20,29,9,6,25,13)

kendall_tau_2 <- cor.test(E2_locs,E2_quit_rate,method=c("kendall"))
kendall_tau_2

#z = -0.62338, p-value = 0.533, tau = -0.1818482

#Now removing outliers

plot(E1_locs,E1_quit_rate)
#remove dots (6,18) (62,7)

E1_locs <-  c(2,19,8,34,7,6,41)
E1_quit_rate <- c(3,2,1,1,1,1,1)

kendall_tau_1 <- cor.test(E1_locs,E1_quit_rate,method=c("kendall"))
kendall_tau_1

#z = -0.95059, p-value = 0.3418, tau = -0.3289758 

plot(E2_locs,E2_quit_rate)
#remove dots (23,45) (78,21)

E2_locs <-  c(23,3,7,28,12,33)
E2_quit_rate <- c(20,29,9,6,25,13)

kendall_tau_2 <- cor.test(E2_locs,E2_quit_rate,method=c("kendall"))
kendall_tau_2

#T = 4, p-value = 0.2722, tau = -0.4666667

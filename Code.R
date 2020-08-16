# Author: Qitian Ma
# Date: 10/08/2020


# Hyperparamter
start_date <- as.Date.character("2020/02/24", format="%Y/%m/%d")
end_date <- as.Date.character("2020/05/03", format="%Y/%m/%d")
n_groups <- 3
rho_mat <- array(rep(1, n_groups), dim=c(n_groups, n_groups))
alpha <- 1.05
delta_d_top_ls <- c(.001, .01, .06)

N_0_ls <- c(.37, .221, .228)  # Lombardia
gamma_ls <- rep(1/18, 3)
sigma <- .0076
beta <- .134
pop_lom <- 8269281
pop_ven <- 4933961
theta_ls <- rep(.75, 3)
l_ls <- sigma * delta_d_top_ls
delta_d_bottom_ls <- delta_d_top_ls * gamma_ls / l_ls
n_days <- end_date - start_date + 1
phi_ls <- rep(.1, 3)
tau_ls <- rep(.1, 3)
eta_ls <- 1 - (l_ls*phi_ls + (1-l_ls) * tau_ls)
k_ls <- rep(0, 3)
lambda <- (sigma*sum(delta_d_top_ls*N_0_ls))**(-1)
colnames_iter_mat <- c("L", "I", "S", "D", "R", "delta_d", "delta_r", "H")
iter_mat <- array(rep(0, n_days*length(colnames_iter_mat)*n_groups), dim=c(n_days, length(colnames_iter_mat), n_groups))
rownames(iter_mat) <- sapply(seq(from=start_date, to=end_date, by=1), as.character)
colnames(iter_mat) <- colnames_iter_mat

# The iteration is computed on a discrete (daily) basis.
# For the sake of uniformity, all the differences are computed based on the privious day's info.
iter_mat[,"L",1:2] <- .6
iter_mat[,"L", 3] <- 1 # L_j

# Initial Condition
iter_mat[1,"I",] <- c(4, 3, 3)
iter_mat[1,"S",] <- N_0_ls * pop_lom - iter_mat[1,"I",]
iter_mat[1,"D",] <- 0
iter_mat[1,"R",] <- 0
iter_mat[1,,]

for (i in 2:n_days){
  iter_mat[i,"H",] <- sigma * sum(delta_d_top_ls*iter_mat[i-1,"I",])
  
  for (j in 1:n_groups){
    delta_I <- beta * (1-theta_ls[j]*iter_mat[i-1,"L",j]) * iter_mat[i-1,"S",j] *
      sum(rho_mat[j,]*eta_ls*iter_mat[i-1,"I",]*(1-theta_ls*iter_mat[i-1,"L",])) /
      sum(rho_mat[j,]*((iter_mat[i-1,"S",] + eta_ls*iter_mat[i-1,"I",] + (1-k_ls)*iter_mat[i-1,"R",])*(1-theta_ls*iter_mat[i-1,"L",])+k_ls*iter_mat[i-1,"R",])) ** (2-alpha) -
      gamma_ls[j]*iter_mat[i-1,"I",j]
    delta_S <- -delta_I
    iter_mat[i,"delta_d",j] <- delta_d_bottom_ls[j] * (1+lambda*iter_mat[i-1,"H",j])
    iter_mat[i,"delta_r",j] <- gamma_ls[j] - iter_mat[i,"delta_d",j]
    delta_D <- iter_mat[i,"delta_d",j] * iter_mat[i-1,"H",j]
    delta_R <- iter_mat[i,"delta_r",j] * iter_mat[i-1,"H",j] + gamma_ls[j] * (iter_mat[i-1,"I",j]-iter_mat[i-1,"H",j])
    
    iter_mat[i,"I",j] <- iter_mat[i-1,"I",j] + delta_I
    iter_mat[i,"S",j] <- iter_mat[i-1,"S",j] + delta_S
    iter_mat[i,"D",j] <- iter_mat[i-1,"D",j] + delta_D
    iter_mat[i,"R",j] <- iter_mat[i-1,"R",j] + delta_R
    }
  
}

library(tidyverse)
young_df <-  tibble(iter_mat[,,1], r)
middle_df <-  data.frame(iter_mat[,,2])
old_df <-  data.frame(iter_mat[,,3])

young_tb <- iter_mat[,,1] %>%
              data.frame() %>%
              rownames_to_column(var = "date") %>%
              as_tibble()

old_tb <- iter_mat[,,3] %>%
  data.frame() %>%
  rownames_to_column(var = "date") %>%
  as_tibble()

young_tb %>%
  select("date","I", "D", "R") %>%
  pivot_longer(-c(date)) %>%
  ggplot(aes(x=parse_date(date), y=value, col=name)) +
  geom_line() + 
  ggtitle(paste("alpha:", as.character(alpha)))
ggsave(paste0("young_traj with alpha ", as.character(alpha), ".pdf"))
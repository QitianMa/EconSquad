
---
Title: Hyperparameter Setting, Initial Conditions & Iterations  
Author: Qian Dong, Wentian Tian, Qitian Ma, Gabriele Carta. \
Date: 16/08/2020
---

## Notation
j = 1 year 20-49  
j = 2 year 50-64  
j = 3 year  65+

## Hyperparameter (Feb. 24th 2020 - May 3rd 2020)
1. $L_j(t)$  lockdown policy  
$L_j = \left\{
	\begin{array}{cc}
	    0.6 & j = 1, 2 \\
	    1   & j = 3
	\end{array}
\right.$

*NOTE: Based on the policy adopted by the Italian government during the lockdown period, $L_j(t)$ is supposed to be 0.6 for the young and middle group while for the old group, it's set to be 1.  $\theta$ is taken as set in Acemoglu's paper for now.*

2. $\{\rho_{i, j}\}_{3*3}$ symmetric matrix &nbsp; $\rho_{i, j} ∈[0,1]$ contact rate between group i and j  
 $\rho_{\{i, j\}}=1,  \forall i,j=1,2,3$   

 *NOTE: The $\rho_{\{i, j\}}$ here are also taken from the baseline model set in Acemoglu's paper, which are the same for any inter-group interactions.*
   
3. $\alpha ∈[1,2]$ index of scale in matching  
   
*NOTE: We may compare the results of these two different matching case and then see which one fits better the data. It's very likely that the reality is between 1 and 2.*
    
4. $\beta$ infection rate   
$\beta=0.134$ 

*NOTE: It's set in the baseline model of Acemoglu's paper.*   

5. $\theta$ lockdown efficiency  
   $\theta = 0.75$

4. $\iota_{j} ∈[0,1]$ fraction of infected people who need ICU  
    $\iota_{j}=\sigma \bar{\delta}_{j}^{d}$
   
5. $\kappa_j∈[0,1]$ fraction of recovered agents allowed to work freely  
   $\kappa_{j}=0$
6. $\gamma_j∈[0,1]$ Non-ICU patients recover rate  
    $\gamma_j = 1/ 18$ 
7.  $\sigma=0.0076$ Coefficient of H(t) equation
      
*NOTE: It's taken from the Acemoglu's paper.*

10.  $\phi_j∈[0,1]$  (conditional) probability that an individual of type j needing ICU care is detected and isolated    
 $\phi_{j} = 0.1$

12.  $\tau_j∈[0,1]$ the constant probability that an infected individual of type j not needing ICU care becomes isolated    
$\tau_{j} = 0.1$

 13.  $\bar{\delta}_{j}^{d}$ The case fatality rates for the three age groups conditional on infection and ICU services being available. 
    
| j     | $\bar{\delta}_{j}^{d}$ |
| ----------- | ----------- |
| 1      | 0.001      |
| 2  | 0.01        |
| 3  | 0.06        |
*NOTE: The values are taken from Ferguson et al. \(2020\) and summarized by Acemoglu.*

## Determined Parameter
1. $H(t)= \sigma \sum_{k} \bar{\delta}_{k}^{d} I_{k}(t)$ 
2. $\underline{\delta}_{j}^{d}=(\bar{\delta_{j}^{d}} \gamma) / \iota_{j}$ 
3. $\delta_{j}^{d}(t)=\underline{\delta}_{j}^{d} \cdot[1+\lambda H(t)]$    
4. $\delta_j^r(t) = \gamma_j - \delta_j^d(t) ∈[0,1]$  ICU patients recover rate  
5. $\eta_j$ $=$ $1 - [\iota_j\phi_j + (1-\iota_j)\tau_j] ∈[0,1]$  rate of infected person fail to be isolated
## Initial Condition
1. $POP_{Lom}=8269281$ 
   
*NOTE: Here we only consider the population of and above 20 years old considering the age groups we are focusing on.*

2. $POP_{Ven}=4033961$ 

*NOTE: Here we only consider the population of and above 20 years old considering the age groups we are focusing on.*

3. $NInfInit_{Lom} = 10$ 
   
*NOTE: Initial infected population in Lombardia, which is the same as assumed in Favero's paper.}*

4. $NInfInit_{Ven} = 5$ 
   
*NOTE: Initial infected population in Veneto, which is the same as assumed in Favero's paper.*

5. $I_{j}(0) = NInfInit_{Lom} * N_j$
   
6. $S_{j}(0)=N_{j}*Pop_{Lom}-I_{j}(0)$ 

## Iteration    
$\Delta{S_j}(t)$ $=$ $-\Delta{I_j}(t)$    
$\Delta{I_j}(t) = \beta [1-\theta_jL_j(t)]S_j(t) \sum_{k}{\rho_{jk}\eta_kI_k(t)(1-\theta_kL_k(t))} / 
\{\sum_k\rho_{jk}[(S_k(t)+\eta_kI_k(t)+(1-\kappa_k)R_k(t)][1-\theta_kL_k(t)]+\kappa_k R_k(t)\}^{2-\alpha} - \gamma_jI_j$    
$\Delta D_j(t) = \delta_j^d(t)H_j(t)$    
$\Delta R_j(t) = \delta_j^r(t)H_j(t) + \gamma_j(I_j(t)-H_j(t))$

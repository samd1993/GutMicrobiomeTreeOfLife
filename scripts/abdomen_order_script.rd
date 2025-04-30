install.packages('ggplot2')
install.packages('mvMORPH')
install.packages('RPANDA')
install.packages(rstan)
rstan_options(auto_write = TRUE')
install.packages('RColorBrewer')
install.packages('ggtree')


library(ggplot2)
library(mvMORPH)
library(RPANDA)
library(rstan)
rstan_options(auto_write = TRUE)
library(RColorBrewer)
library(funrar)

 setwd("~/OneDrive - University of California, San Diego Health/TOL2024/phylo")
 
 tree=read.tree("GMTOLall_abdomen_809species.newick")
 table=t(read.table("GMTOL_abdomen_table809_t.txt"))

source("ABDOMEN.R")

name <- "run_GMToL_order" # the name of the run

code_path <- getwd() # indicates where the stan codes are stored (here, there are directly stored in the working directory) and where the ABDOMEN plots will be generated.

detection_threshold <- 1e-05 # the detection threshold: below this threshold, we assume that we cannot detect the microbial taxa (either because it is not present or because we cannot detect very rare taxa with metabarcoding techniques). Then, all relative abundances below this threshold are set to this threshold. 

seed <- 6 # seed for reproductibility

mean_prior_logY <- 0 # mean value for the Gaussian prior of logY (the latent variables that correspond to the total microbial abundances, relative to the ancestral ones)
sd_prior_logY <- 2  # standard deviation for the Gaussian prior of logY (the latent variables that correspond to the total microbial abundances, relative to the ancestral ones)

nb_cores <- 8 # number of cores to run the analyses
chains <-  4 # number of chains for the inference
warmup <-  10 # number of warmup iterations in STAN
iter <-  20 # total number of iterations in STAN

#or try
detection_threshold <- 1e-04

fit_summary <- ABDOMEN(tree, table, name, 
                       code_path = code_path,
                       detection_threshold = detection_threshold, seed = seed, 
                       mean_prior_logY = mean_prior_logY, sd_prior_logY = sd_prior_logY,
                       nb_cores = nb_cores, chains = chains, warmup = warmup, iter = iter)
                       
         
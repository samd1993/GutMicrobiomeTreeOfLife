install.packages('ggplot2')
install.packages('mvMORPH')
install.packages('RPANDA')
install.packages('rstan')
install.packages('ggimage')
install.packages('RColorBrewer')
#careful with copy pasting (just copy code online)
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
 
BiocManager::install("ggtree")

library(ggimage)
library(ggplot2)
library(mvMORPH)
library(RPANDA)
library(rstan)
rstan_options(auto_write = TRUE)
library(RColorBrewer)
library(ggtree)

 setwd("~/OneDrive - University of California, San Diego Health/TOL2024/phylo")
 
 tree=read.tree("GMTOLall_abdomen_809species.newick")
 table=t(read.table("GMTOL_abdomen_table809_t.txt"))

 tree=read.tree("tree_Cetartiodactyla.tre")
 table=t(read.table("table_bacterial_orders_Cetartiodactyla.txt"))
table=as.matrix(table)
source("ABDOMEN.R")

name <- "run_GMToL_order" # the name of the run

code_path <- getwd() # indicates where the stan codes are stored (here, there are directly stored in the working directory) and where the ABDOMEN plots will be generated.

detection_threshold <- 1e-05 # the detection threshold: below this threshold, we assume that we cannot detect the microbial taxa (either because it is not present or because we cannot detect very rare taxa with metabarcoding techniques). Then, all relative abundances below this threshold are set to this threshold. 

seed <- 6 # seed for reproductibility

mean_prior_logY <- 0 # mean value for the Gaussian prior of logY (the latent variables that correspond to the total microbial abundances, relative to the ancestral ones)
sd_prior_logY <- 2  # standard deviation for the Gaussian prior of logY (the latent variables that correspond to the total microbial abundances, relative to the ancestral ones)

nb_cores <- 6 # number of cores to run the analyses
chains <-  4 # number of chains for the inference
warmup <-  500 # number of warmup iterations in STAN
iter <-  1000 # total number of iterations in STAN

#or try
#detection_threshold <- 1e-04

fit_summary <- ABDOMEN(tree, mtable, name, 
                       code_path = code_path,
                       detection_threshold = detection_threshold, seed = seed, 
                       mean_prior_logY = mean_prior_logY, sd_prior_logY = sd_prior_logY,
                       nb_cores = nb_cores, chains = chains, warmup = warmup, iter = iter)

mtable=as.matrix(table)
htips=tree$tip.label
irow=rownames(mtable)

int=intersect(irow,htips)
length(int)


#prune tree to match table! nice code

tree2<-drop.tip(tree,tree$tip.label[-match(int, tree$tip.label)])
length(tree2$tip.label)
plot(tree2)   

fit_summary <- ABDOMEN(tree2, mtable, name, 
                       code_path = code_path,
                       detection_threshold = detection_threshold, seed = seed, 
                       mean_prior_logY = mean_prior_logY, sd_prior_logY = sd_prior_logY,
                       nb_cores = nb_cores, chains = chains, warmup = warmup, iter = iter)                   

# Specify the color for each microbial taxon:
list_colors <- scales::hue_pal()(ncol(mtable))
names(list_colors) <- colnames(mtable)    

  ABDOMEN_process_output(tree2, mtable, name, fit_summary, code_path = code_path, 
		detection_threshold = detection_threshold, list_colors=list_colors)   
		
# The ancestral microbiota composition estimated for each node of the host phylogenetic tree  (Z0_nodes):
Z0_nodes_o <- ABDOMEN_extract_Z0_nodes(tree2, mtable, fit_summary, detection_threshold = detection_threshold) 

         
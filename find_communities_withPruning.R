#   Behrang Mehrparvar
#   10/9/2015
#   This code loads adjacency matrix from matlab file.
#   It saves the communities and their information in a matlab file.
#   The communities are detected in two steps:
#   - the first step detects communities including self-loops
#   - the second step prunes the singular communities by running detection on them without self-loops


# Input file:     'results/dist_reps.mat'
#   adj.mi:       adjacency matrix with mutual information as dependency
#   all.coms      ground truth community assignments
#   all.patterns  list of all pattens (dataset)

# Output file:    'results/dist_coms.mat'
#   mod_mi        modularity of communities with mutual information as dependency before pruning
#   comp_mi       Rand index with ground truth with mutual information as dependency before pruning
#   mem_mi        membership vector before pruning
#   mod_mi_prune  modularity of communities with mutual information as dependency after pruning
#   comp_mi_prune Rand index with ground truth with mutual information as dependency after pruning
#   mem_mi_prune  membership vector after pruning

library(igraph)
library(R.matlab)

rm(list=ls())

filename <- 'results/dist_reps.mat';
data <- readMat(filename)


g_mi <- graph.adjacency(data[['adj.mi']], "undirected", weighted=TRUE, diag=TRUE)


# compute ground truth

#c_mi2 = c_mi
#c_mi2$membership = data[['all.coms']]
mem_mi_truth <- array(t(data[['all.coms']]))
mod_mi_truth <- modularity(g_mi,array(t(data[['all.coms']])), weights = E(g_mi)$weight)
comp_mi_truth <- compare(mem_mi_truth, array(data[['all.coms']]), method = "rand")




# Run initial detection with self-loops

c_mi <- fastgreedy.community(g_mi)

mem_mi<-membership(c_mi)
mod_mi <- modularity(c_mi)
comp_mi <- compare(mem_mi, mem_mi_truth, method = "rand")





# Find the singular units

mem_mi = membership(c_mi)
freqs_mi = tabulate(mem_mi)
singulars_mi=which(freqs_mi==1)
nonsingulars_mi=which(freqs_mi>1)


if(length(singulars_mi)>1)
{

  # detect communities in singular section
  
  adj_mi_prune = data[['adj.mi']][which(mem_mi %in% singulars_mi),which(mem_mi %in% singulars_mi)]
  mask = !diag(1,dim(adj_mi_prune)[1],dim(adj_mi_prune)[1]);
  
  g_mi_prune <- graph.adjacency(mask*adj_mi_prune, "undirected", weighted=TRUE, diag=TRUE)
  c_mi_prune <- fastgreedy.community(g_mi_prune)
  
  mem_mi_prune <-mem_mi
  base<-0
  if(length(singulars_mi)<length(mem_mi))
  {
    base<-max(nonsingulars_mi)
  }
  mem_mi_prune<-replace(mem_mi, mem_mi %in% singulars_mi, membership(c_mi_prune)+base) 
  
  
  
#  c_mi2 = c_mi
#  c_mi2$membership = mem_mi_prune  
  mod_mi_prune <- modularity(g_mi,mem_mi_prune, weights = E(g_mi)$weight)
  comp_mi_prune <- compare(mem_mi_prune, data[['all.coms']], method = "rand")

}else{
  mod_mi_prune=mod_mi
  comp_mi_prune=comp_mi
  mem_mi_prune=mem_mi
}

filename <- 'results/dist_coms.mat';
writeMat(filename,
         mod_mi=mod_mi,
         comp_mi=comp_mi,
         mem_mi=mem_mi,
         mod_mi_prune=mod_mi_prune,
         comp_mi_prune=comp_mi_prune,
         mem_mi_prune=mem_mi_prune,
         mod_mi_truth=mod_mi_truth,
         comp_mi_truth=comp_mi_truth,
         mem_mi_truth=mem_mi_truth)
         

#array(t(data[['all.coms']]))

#mod_mi
#comp_mi
#mem_mi

#mod_mi_prune
#comp_mi_prune
#mem_mi_prune

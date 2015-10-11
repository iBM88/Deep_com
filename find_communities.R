#   Behrang Mehrparvar
#   10/9/2015
#   This code loads adjacency matrix from matlab file.
#   It saves the communities and their information in a matlab file.

# Input file:     'results/dist_reps.mat'
#   adj.ent:      adjacency matrix with joint entropy as dependency
#   adj.mi:       adjacency matrix with mutual information as dependency
#   all.coms      ground truth community assignments
#   all.patterns  list of all pattens (dataset)

# Output file:    'results/dist_coms.mat'
#   mod_ent       modularity of communities with joint entropy as dependency
#   mod_mi        modularity of communities with mutual information as dependency
#   rand_ent      Rand index with ground truth with joint entropy as dependency
#   rand_mi       Rand index with ground truth with mutual information as dependency

library(igraph)
library(R.matlab)

filename <- 'results/dist_reps.mat';
data <- readMat(filename)






g_ent <- graph.adjacency(data[['adj.ent']], "undirected", weighted=TRUE, diag=TRUE)
c_ent <- fastgreedy.community(g_ent)

g_mi <- graph.adjacency(data[['adj.mi']], "undirected", weighted=TRUE, diag=TRUE)
c_mi <- fastgreedy.community(g_mi)

comp_ent <- compare(membership(c_ent), data[['all.coms']], method = "rand")
comp_mi <- compare(membership(c_mi), data[['all.coms']], method = "rand")







# same calculations without the self-loops

mask = !diag(1,dim(data[['adj.mi']])[1],dim(data[['adj.mi']])[1]);

g_ent_noloop <- graph.adjacency(mask*data[['adj.ent']], "undirected", weighted=TRUE, diag=TRUE)
c_ent_noloop <- fastgreedy.community(g_ent_noloop)

g_mi_noloop <- graph.adjacency(mask*data[['adj.mi']], "undirected", weighted=TRUE, diag=TRUE)
c_mi_noloop <- fastgreedy.community(g_mi_noloop)

comp_ent_noloop <- compare(membership(c_ent_noloop), data[['all.coms']], method = "rand")
comp_mi_noloop <- compare(membership(c_mi_noloop), data[['all.coms']], method = "rand")






# fix the communities
#   when using mutual infromation as the dependency,
#   merge all individual communities into one community
mem_mi_fixed = membership(c_mi)
max_com = max(mem_mi_fixed)+1
freqs = tabulate(mem_mi_fixed)
singulars=which(freqs==1)
for(singulars_index in singulars)
{
  mem_mi_fixed = replace(mem_mi_fixed, mem_mi_fixed == singulars_index, max_com+1)
}
comp_mi_fixed <- compare(mem_mi_fixed, data[['all.coms']], method = "rand")

mem_mi_noloop_fixed = membership(c_mi_noloop)
max_com_noloop = max(mem_mi_noloop_fixed)+1
freqs_noloop = tabulate(mem_mi_noloop_fixed)
singulars_noloop=which(freqs_noloop==1)
for(singulars_noloop_index in singulars_noloop)
{
  mem_mi_noloop_fixed = replace(mem_mi_noloop_fixed, mem_mi_noloop_fixed == singulars_noloop_index, max_com_noloop+1)
}
comp_mi_noloop_fixed <- compare(mem_mi_noloop_fixed, data[['all.coms']], method = "rand")




filename <- 'results/dist_coms.mat';
writeMat(filename,
         mod_ent=modularity(c_ent),mod_mi=modularity(c_mi),
         comp_ent=comp_ent,comp_mi=comp_mi,comp_mi_fixed=comp_mi_fixed,
         mem_ent=membership(c_ent),mem_mi=membership(c_mi),
         mod_ent_noloop=modularity(c_ent_noloop),mod_mi_noloop=modularity(c_mi_noloop),
         comp_ent_noloop=comp_ent_noloop,comp_mi_noloop=comp_mi_noloop,comp_mi_noloop_fixed=comp_mi_noloop_fixed,
         mem_ent_noloop=membership(c_ent_noloop),mem_mi_noloop=membership(c_mi_noloop),
         mem_mi_fixed=mem_mi_fixed,mem_mi_noloop_fixed=mem_mi_noloop_fixed)

t(data[['all.coms']])
c_mi
c_mi_noloop
mem_mi_fixed
mem_mi_noloop_fixed
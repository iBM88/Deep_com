
library(igraph)
library(R.matlab)

rm(list=ls())

#filename <- 'results/dist_reps.mat';
#data <- readMat(filename)

#A<-data[['adj.mi']]

A <- read.table(row.names=1, header=TRUE, text=
                  "           A          B          C          D           E         F
A 0.00000000  0.0000000  0.0000000  0.0000000  0.05119703 1.3431599
B 0.00000000  0.0000000  0.6088082  0.4016954  0.00000000 0.6132168
C 0.00000000  0.6088082  0.0000000  0.0000000  0.63295415 0.0000000
D 0.00000000  0.4016954  0.0000000  0.0000000  0.29831267 0.0000000
E 0.05119703  0.0000000  0.6329541  0.2983127  0.00000000 0.1562458
F 1.34315990  0.6132168  0.0000000  0.0000000  0.15624584 0.0000000")
A <- as.matrix(A)

g_mi <- graph.adjacency(A, "undirected", weighted=TRUE, diag=TRUE)

c_mi <- fastgreedy.community(g_mi)
modularity(c_mi)
modularity(g_mi,membership(c_mi), weights = E(g_mi)$weight)

membership(c_mi)
plot(g_mi)

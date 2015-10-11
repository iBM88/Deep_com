%   Behrang Mehrparvar
%   10/9/2015
%   This code generates patterns with distributed representations
%   consisting of local and distributed communities of hidden units.

%   Requirement:    InfoTheory library
%   [http://www.mathworks.com/matlabcentral/fileexchange/35625-information-theory-toolbox]

%%  issues:
%        1. does it work with imbalanced data
%        2. it doesn't work when two communities are detected as collection
%        of singulars
%           - do detection with loop
%           - do pruning without loops on singulars
%%
clear all;
close all;

patterns = 100;
com_sizes =[1,4];         % set [1,1] for pure local; 
                          % set [log2(pattern) log2(pattern)] for pure distributed
                          % sampled from uniform distribution
max_samples = 1;          % sampled from uniform distribution

isLoop = false;

[ all_coms, all_patterns, all_raw] = generate_distributed( patterns, com_sizes, max_samples);
%[ all_coms, all_patterns] = generate_distributed_sample();  % this woks perfect with joint entropy
load('results/tricky.mat')

% %shuffle features    % doesn't change anything though
% shuffle = randperm(size(all_patterns,2));
% all_patterns = all_patterns(:,shuffle);
% all_coms = all_coms(shuffle);


[ adj_ent ] = adjacency( all_patterns, true );
[ adj_mi ] = adjacency( all_patterns, false );

filename = 'dist_reps.mat';
folder = 'results'; 
save(fullfile(folder,filename),'all_patterns','all_coms','adj_ent','adj_mi');

system('Rscript find_communities.R','-echo');
load('results/dist_coms.mat');



memberships = [all_coms mem_ent mem_ent_noloop mem_mi mem_mi_noloop mem_mi_fixed mem_mi_noloop_fixed];

fprintf('                    with self-loop             no self-loop\n')
fprintf('                    modularity Rand   Size     modularity Rand  Size\n')
fprintf('joint entropy:      %5.3f      %5.3f  %3d      %5.3f      %5.3f  %3d\n',mod_ent,comp_ent,size(unique(mem_ent),1),mod_ent_noloop,comp_ent_noloop,size(unique(mem_ent_noloop),1));
fprintf('mutual information: %5.3f      %5.3f  %3d      %5.3f      %5.3f  %3d\n',mod_mi,comp_mi,size(unique(mem_mi),1),mod_mi_noloop,comp_mi_noloop,size(unique(mem_mi_noloop),1));
fprintf('mutual info.(fixed):%5.3f      %5.3f  %3d      %5.3f      %5.3f  %3d\n',NaN,comp_mi_fixed,size(unique(mem_mi_fixed),1),NaN,comp_mi_noloop_fixed,size(unique(mem_mi_noloop_fixed),1));

fprintf('pattern=%d\ncommunities=%d\n',size(all_patterns,1),size(unique(all_coms),1));

%figure('name','pattern distribution');hist(all_raw,unique(all_raw));

%pruning
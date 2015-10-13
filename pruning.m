% find elements of mi that are singular
freqs = hist(mem_mi,max(mem_mi));
singulars = (freqs==1);
%mask = 15:25;
mask = [1:6 9:14];

% find communities without loop for singulars

adj_mi = adj_mi(mask,mask);
adj_ent = adj_ent(mask,mask);
all_patterns = all_patterns(:,mask);
all_coms = all_coms(mask);

filename = 'dist_reps.mat';
folder = 'results'; 
save(fullfile(folder,filename),'all_patterns','all_coms','adj_ent','adj_mi');

system('Rscript find_communities.R','-echo');
load('results/dist_coms.mat');

memberships = [all_coms mem_ent mem_ent_noloop mem_mi mem_mi_noloop mem_mi_fixed mem_mi_noloop_fixed];


% replace pruned communities with existing
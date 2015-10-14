clc;
close all;

results_mi = [];
results_ex = [];
results_ey = [];
results_ej = [];
results_es = [];

for reps1 = 1:100+1
    for reps2 = 1:100+1

        x = [[0,0,1,1], ones(1,reps1-1),ones(1,reps2-1)];
        y = [[0,1,0,1],zeros(1,reps1-1),ones(1,reps2-1)];

        ex = entropy(x);
        ey = entropy(y);
        es = ex+ey;
        ej = jointEntropy(x,y);

        mi = mutualInformation(x,y);

        results_mi(reps1,reps2) = mi;
        results_ex(reps1,reps2) = ex;
        results_ey(reps1,reps2) = ey;
        results_es(reps1,reps2) = es;
        results_ej(reps1,reps2) = ej;
        %fprintf('reps:%d\tMI:%6.3f\n',reps,mi);
    end
end

figure('name','mutual information');
pcolor(results_mi);
colorbar;
xlabel('size of imbalanced pattern 1');
ylabel('size of imbalanced pattern 2');

figure('name','joint entropy');
pcolor(results_ej);
colorbar;
xlabel('size of imbalanced pattern 1');
ylabel('size of imbalanced pattern 2');


diag_mi = diag(results_mi);
figure('name','mutual information');
plot([1:size(diag_mi,1)],diag_mi);
xlabel('size of imbalanced patterns 1 and 2');
ylabel('mutual information');

diag_ej = diag(results_ej);
diag_es = diag(results_es);
figure('name','entropies');
plot([1:size(diag_ej,1)],diag_ej,'k');
xlabel('size of imbalanced patterns 1 and 2');
ylabel('joint entropy');


figure('name','mutual information');
surf(results_mi);
xlabel('size of imbalanced patterns 1');
ylabel('size of imbalanced patterns 1');
zlabel('mutual information');
colorbar;

figure('name','joint entropy');
surf(results_ej);
xlabel('size of imbalanced patterns 1');
ylabel('size of imbalanced patterns 1');
zlabel('joint entropy');
colorbar;

% vs = [];
% for reps2 = 1:100+1
%     [i,v]=max(results_mi(:,reps2));
%     vs = [vs;v];
% end
% plot(1:100+1,vs);
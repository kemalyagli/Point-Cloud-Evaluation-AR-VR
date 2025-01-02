clear all, close all, clc

addpath("functions")
addpath("data")

load('info_matrix.mat');

%adding lines at the end of all experiments to compansate the ignoring
%effect of hist2dw function
for i=1:length(info_matrix)
    for j=1:length(info_matrix{1,1})
        info_matrix{1,i}{j}(size(info_matrix{1,i}{j},1)+1,1:2)=1;    
    end
end

I=4;
grid_I = [-6:1/I:6];

for i=1:length(info_matrix)
    for j=1:length(info_matrix{1,1})
        d=info_matrix{1,i}{j};
        H{i,j}=hist2dw(d(:,1),d(:,2),d(:,3),grid_I,grid_I);     
    end
end

%2D GAUSSIAN FILTERING

for i=1:length(info_matrix)
    for j=1:length(info_matrix{1,1})
        H_filtered{i,j}=imgaussfilt(H{i,j},1.85);
    end
end

% Example for seeing how it filters 
% figure;imagesc(grid_I,grid_I,H{1,1});
% figure;imagesc(grid_I,grid_I,H_filtered{1,1});

c=1;
for i=1:length(info_matrix)
    for j=1:length(info_matrix{1,1})
        a = [H{i,j}(:)];   % M = [H{1,1}(:) H{1,2}(:) ... H{22,96}(:)]
        M(:,c) = a/norm(a);   
        b = [H_filtered{i,j}(:)];   % M_filtered = [H_filtered{1,1}(:) H_filtered{1,2}(:) ... H_filtered{22,110}(:)]
        M_filtered(:,c) = b/norm(b);  
        c=c+1;
    end
end

%filter or not?
Crr=M_filtered'*M_filtered;
% Crr=M'*M;

%Crr=corr(M);
indices = find(isnan(Crr) == 1);
% Crr(isnan(Crr))=0;
Crr = Crr - diag(diag(Crr));
clusters = [];

for k=1:100
%     disp(k)
    clusters(:,k) = community_louvain(Crr,1);
end
clusters = consensus_und(agreement(clusters),0.3,100);

% save('clusters', 'clusters')
%save('clusters_after_filtering', 'clusters')
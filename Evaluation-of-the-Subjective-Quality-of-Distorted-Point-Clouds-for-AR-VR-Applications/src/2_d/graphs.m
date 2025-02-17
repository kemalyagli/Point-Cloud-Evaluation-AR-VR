clear all, close all, clc

addpath("data\")
addpath("functions\")

filtering=1; %apply Gaussian filter if it's equal to 1.

if filtering
    load('clusters_after_filtering.mat');
else
    load('clusters.mat');
end

num_users=22;
num_votes=5; %from 1 to 5.
num_zones=2; %edge/all
num_levels=4;%4 different kind of noise levels
num_distortions=3; %DG-DR-DS
num_exp=96;
num_clusters=max(clusters);
I=4;
grid_I = [-6:1/I:6];

% 1)Number of Experiments for each Clusters

for i=1:max(clusters) %i is from 1 to number of clusters
    n_of_exp_for_each_clusters (1,i) = sum(clusters(:) == i);
end

figure;bar(n_of_exp_for_each_clusters)
title('Number of Experiments for each Clusters')
xlabel('Cluster-ID')
ylabel('Number of Experiments')

% 2)Number of Experiments for each Clusters in a User

clusters_seperated = reshape(clusters,num_exp,num_users);

for j=1:num_users
    for i=1:max(clusters) %i is from 1 to number of clusters
        n_of_exp_for_each_clusters_in_a_user (j,i) = sum(clusters_seperated(:,j) == i);
    end
end

figure;bar(n_of_exp_for_each_clusters_in_a_user)
title('Number of Experiments for each Clusters in a Specific User')
xlabel('User-ID')
ylabel('Number of Experiments')

legend_names=string(zeros(1,num_clusters));
for i=1:num_clusters
    legend_names(1,i)=sprintf('Cluster-%d', i);
end
legend(legend_names)

% 3)Average pattern for each clusters

for i=1:max(clusters) %i is from 1 to number of clusters
    indices {:,i} = find(clusters(:) == i);%indices of the experiments seperated to cluster-id
end

load('info_matrix.mat');

%adding lines at the end of all experiments to compansate the ignoring
%effect of hist2dw function
for i=1:length(info_matrix)
    for j=1:length(info_matrix{1,1})
        info_matrix{1,i}{j}(size(info_matrix{1,i}{j},1)+1,1:2)=1;    
    end
end

info_matrix_in_one_row=[];
for j=1:num_users
    k=info_matrix{1,j}(:);
    info_matrix_in_one_row=[info_matrix_in_one_row;k];
end

%for cluster-id
for cluster_id=1:num_clusters
    H=zeros(length(grid_I),length(grid_I));
    for i=1:length(indices{1,cluster_id})
        d=info_matrix_in_one_row{indices{1,cluster_id}(i),1};
        H=H+hist2dw(d(:,1),d(:,2),d(:,3),grid_I,grid_I); 
    %     figure;imagesc(grid_I,grid_I,H);
    end
    H=H./length(indices{1,cluster_id});
    figure;imagesc(grid_I,grid_I,H);
    h=colorbar;ylabel(h, 'Time elapsed [s]')
    title(sprintf('Average pattern for Cluster-%d', cluster_id))
    xlabel('Position [m] (x-axis)')
    ylabel('Position [m] (z-axis)') 
end

% 4)Distribution of votes in each clusters

load('data.mat'); %load information of experiments
votes=data2{:,6}; %accessing vote info in the 6th column
votes_seperated = reshape(votes,num_exp,num_users); %in each column we have votes of experiments ordered to user_id
[row,col]=size(clusters_seperated);
fre_of_votes=zeros(num_clusters, num_votes);

for i=1:col
    for j=1:row
        fre_of_votes(clusters_seperated(j,i),votes_seperated(j,i))=fre_of_votes(clusters_seperated(j,i),votes_seperated(j,i))+1;
    end
end

figure;bar(fre_of_votes)
title('Distribution of Votes in each Clusters')
xlabel('Cluster-ID')
ylabel('Frequency of Votes')
legend('Vote (1)','Vote (2)','Vote (3)','Vote (4)','Vote (5)')

% 5)Distribution of zones in each clusters

% load('data.mat'); %load information of experiments
zones=data2{:,5}; %accessing vote info in the 5th column
zones_seperated = reshape(zones,num_exp,num_users); %in each column we have zones of experiments ordered to user_id
[row,col]=size(clusters_seperated);
fre_of_zones=zeros(num_clusters, num_zones);

for i=1:col
    for j=1:row
        fre_of_zones(clusters_seperated(j,i),zones_seperated(j,i))=fre_of_zones(clusters_seperated(j,i),zones_seperated(j,i))+1;
    end
end

figure;bar(fre_of_zones)
title('Distribution of Zones in each Clusters')
xlabel('Cluster-ID')
ylabel('Frequency of Zones')
legend('All','Edges')

% 6)Distribution of noise levels in each clusters

% load('data.mat'); %load information of experiments
levels=data2{:,4}; %accessing vote info in the 4th column
levels_seperated = reshape(levels,num_exp,num_users); %in each column we have zones of experiments ordered to user_id
[row,col]=size(clusters_seperated);
fre_of_levels=zeros(num_clusters, num_levels);

for i=1:col
    for j=1:row
        fre_of_levels(clusters_seperated(j,i),levels_seperated(j,i))=fre_of_levels(clusters_seperated(j,i),levels_seperated(j,i))+1;
    end
end

figure;bar(fre_of_levels)
title('Distribution of Noise Levels in each Clusters')
xlabel('Cluster-ID')
ylabel('Frequency of Levels')
legend('1','2','3','4')

% 7)Distribution of noise levels in each clusters

% load('data.mat'); %load information of experiments
distortions=data2{:,3}; %accessing vote info in the 3rd column
distortions_seperated = reshape(distortions,num_exp,num_users); %in each column we have zones of experiments ordered to user_id
[row,col]=size(clusters_seperated);
fre_of_distortions=zeros(num_clusters, num_distortions);

for i=1:col
    for j=1:row
        fre_of_distortions(clusters_seperated(j,i),distortions_seperated(j,i))=fre_of_distortions(clusters_seperated(j,i),distortions_seperated(j,i))+1;
    end
end

figure;bar(fre_of_distortions)
title('Distribution of Distortions in each Clusters')
xlabel('Cluster-ID')
ylabel('Frequency of Distortions')
legend('DG','DR','NS')


% 8)Distribution of noise levels+distortion in each clusters
fre_of_distortions_levels_1=zeros(num_clusters, num_levels);
fre_of_distortions_levels_2=zeros(num_clusters, num_levels);
fre_of_distortions_levels_3=zeros(num_clusters, num_levels);
for i=1:col
    for j=1:row
        if distortions_seperated(j,i)=='DG'
            fre_of_distortions_levels_1(clusters_seperated(j,i),levels_seperated(j,i))=fre_of_distortions_levels_1(clusters_seperated(j,i),levels_seperated(j,i))+1;
        elseif distortions_seperated(j,i)=='DR'
            fre_of_distortions_levels_2(clusters_seperated(j,i),levels_seperated(j,i))=fre_of_distortions_levels_1(clusters_seperated(j,i),levels_seperated(j,i))+1;
        else distortions_seperated(j,i)=='NS'
            fre_of_distortions_levels_3(clusters_seperated(j,i),levels_seperated(j,i))=fre_of_distortions_levels_1(clusters_seperated(j,i),levels_seperated(j,i))+1;
        end
    end
end

fre_of_distortions_levels = [fre_of_distortions_levels_1 fre_of_distortions_levels_2 fre_of_distortions_levels_3];
figure;bar(fre_of_distortions_levels)
title('Distribution of Distortions+Levels in each Clusters')
xlabel('Cluster-ID')
ylabel('Frequency of Distortions+Levels')
legend('DG (1)','DG (2)','DG (3)','DG (4)','DR (1)','DR (2)','DR (3)','DR (4)','NS (1)','NS (2)','NS (3)','NS (4)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9)Average patterns in each votes

for i=1:num_votes %i is from 1 to 5
    indices {:,i} = find(votes(:) == i);%indices of the experiments seperated to votes
end

load('info_matrix.mat');

%adding lines at the end of all experiments to compansate the ignoring
%effect of hist2dw function
for i=1:length(info_matrix)
    for j=1:length(info_matrix{1,1})
        info_matrix{1,i}{j}(size(info_matrix{1,i}{j},1)+1,1:2)=1;    
    end
end

info_matrix_in_one_row=[];
for j=1:num_users
    k=info_matrix{1,j}(:);
    info_matrix_in_one_row=[info_matrix_in_one_row;k];
end

%for vote-id
for vote_id=1:num_votes
    H=zeros(length(grid_I),length(grid_I));
    for i=1:length(indices{1,vote_id})
        d=info_matrix_in_one_row{indices{1,vote_id}(i),1};
        H=H+hist2dw(d(:,1),d(:,2),d(:,3),grid_I,grid_I); 
    %     figure;imagesc(grid_I,grid_I,H);
    end
    H=H./length(indices{1,vote_id});
    figure;imagesc(grid_I,grid_I,H);                                 
    h=colorbar;ylabel(h, 'Time elapsed [s]')
    title(sprintf('Average pattern for Vote-%d', vote_id))
    xlabel('Position [m] (x-axis)')
    ylabel('Position [m] (z-axis)') 
end



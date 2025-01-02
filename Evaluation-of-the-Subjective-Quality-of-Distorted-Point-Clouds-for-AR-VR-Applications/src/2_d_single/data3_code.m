clear all, close all, clc
addpath("data")
addpath("functions")

load('data.mat');
load('clusters_after_filtering.mat');

for i=1:length(clusters)
    if clusters(i,1)==1
        cluster_names(i,1)="walking along the line";
    else if clusters(i,1)==2
        cluster_names(i,1)="walking around";
    else if clusters(i,1)==3
        cluster_names(i,1)="still standing";
    end
    end
    end
end

data3 = addvars(data2,clusters);
data3 = addvars(data3,cluster_names);
% save('data3', 'data3')

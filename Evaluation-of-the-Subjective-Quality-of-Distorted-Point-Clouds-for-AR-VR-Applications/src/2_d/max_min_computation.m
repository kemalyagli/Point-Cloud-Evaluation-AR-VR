clear all, close all, clc
%max-min computation of positions to set grid_I correctly
addpath("functions")
addpath("data")
load('info_matrix.mat');

for i=1:length(info_matrix)
    for j=1:length(info_matrix{1,1})
        min_d(i,j)=min(min(info_matrix{1,i}{j}(:,1:2)));
        max_d(i,j)=max(max(info_matrix{1,i}{j}(:,1:2)));
    end
end

max(max(max_d))
min(min(min_d))



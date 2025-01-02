clear all, close all, clc
addpath("data")
addpath("functions")
%max-min computation of positions to set grid_I correctly
load('info_matrix_single.mat');

for i=1:length(info_matrix)
    for j=1:length(info_matrix{1,1})
        min_d(i,j)=min(min(info_matrix{1,i}{j}(:,1:2)));
        max_d(i,j)=max(max(info_matrix{1,i}{j}(:,1:2)));
    end
end

max(max(max_d))
min(min(min_d))



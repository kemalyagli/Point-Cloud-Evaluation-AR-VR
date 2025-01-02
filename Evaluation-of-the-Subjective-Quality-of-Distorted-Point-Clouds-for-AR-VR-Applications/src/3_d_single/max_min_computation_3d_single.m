clear all,close all,clc
addpath("data")
load('info_matrix_3d_single.mat');

for i=1:length(info_matrix_3d)
    for j=1:length(info_matrix_3d{1,1})
        min_d(i,j)=min(info_matrix_3d{1,i}{j}(:,2));
        max_d(i,j)=max(info_matrix_3d{1,i}{j}(:,2));
    end
end

max(max(max_d))
min(min(min_d))
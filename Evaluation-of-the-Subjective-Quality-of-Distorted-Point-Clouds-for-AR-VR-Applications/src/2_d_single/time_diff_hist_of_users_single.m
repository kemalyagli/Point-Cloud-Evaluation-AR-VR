%Time difference histogram for the experiments of user_x
clear all,close all, clc
addpath("data")
addpath("functions")

fid = fopen("Recording_1.txt");
data = textscan(fid, '%f %f %f %f %f %f %f %f %f %s','Delimiter',',');
fid = fclose(fid);

%Removing all testing lines
exps_with_testing_data=data{1,10}; %experiments containing testing data 
Index = find(contains(exps_with_testing_data,'StartTesting'));
starting_index_of_experiments = min(Index);

for i=1:length(data)
    data{1,i}=data{1,i}(starting_index_of_experiments:end,:);
end

t = data{1,1}; %time
x_l = data{1,2}; %x-axis location
z_l= data{1,4};  %z-axis location
exps=data{1,10}; %experiments

t_diff=[diff(t);0];

% t_diff=zeros(length(t),1); %pre-allocation
% for i=1:length(t)-1
%     t_diff(i,1) = t(i+1,1)-t(i,1); %the time spent in each location in recordings
% end

%round the positions to the nearest multiple of 0.25
I=4;
x_l_r = round(x_l * I)/I; %rounded x-axis location 
z_l_r = round(z_l * I)/I; %rounded z-axis location

A=[x_l_r z_l_r t_diff]; 

[d, e, f] = unique(exps);
e=sort(e); %each different experiment index stored in e.

for i=1:length(e)-1
    exps_seperated{i} = A([e(i):e(i+1)-1],:);
end
i=length(e);
exps_seperated{i} = A([e(i):end],:); %each different experiment's info (position and time) stored in exps_seperated. 

% help unique
% [C,IA,IC] = unique(A,'rows') also returns index vectors IA and IC such that C = A(IA,:) and A = C(IC,:).

for j=1:length(exps_seperated)
    [C{j},IA,IC] = unique(exps_seperated{j}(:,[1,2]),'rows');
    
    C{j}(:,3)=0;
        for i=1:length(IC)
            C{j}(IC(i,1),3) = C{j}(IC(i,1),3) + exps_seperated{j}(i,3); %Create C by summing time differences for same positions in exps_seperated.
        end
    %indices = find(IC==240); %it's for checking manually for seeing the "for loop" works

    x = C{j}(:,1);
    z = C{j}(:,2);
    w = C{j}(:,3);
    grid_I = [-7:1/I:7];
    figure;imagesc(grid_I,grid_I,hist2dw(x(:),z(:),w(:),grid_I,grid_I));
    h=colorbar;ylabel(h, 'Time elapsed [s]')
    title('Time Difference Histogram')
    xlabel('Position [m] (x-axis)')
    ylabel('Position [m] (z-axis)')       
end
   




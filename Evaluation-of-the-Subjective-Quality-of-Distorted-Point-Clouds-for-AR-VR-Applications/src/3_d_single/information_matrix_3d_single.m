%Information matrix of users and their experiments (positions and time spent)
clear all,close all, clc

numfiles = 15;
mydata = cell(1, numfiles);

for k = 0:numfiles
    myfilename = sprintf('Recording_%d.txt', k+1);
    
    fid = fopen(myfilename); %open experiments of user_k
    data = textscan(fid, '%f %f %f %f %f %f %f %f %f %s','Delimiter',',');
    fid = fclose(fid);
    
    exps_with_testing_data=data{1,10}; %experiments containing testing data 
    Index = find(contains(exps_with_testing_data,'StartTesting'));
    starting_index_of_experiments = min(Index);

    %Removing all testing lines
    for i=1:length(data)
        data{1,i}=data{1,i}(starting_index_of_experiments:end,:);
    end

    t = data{1,1}; %time
    x_l = data{1,2}; %x-axis location
    y_l = data{1,3}; %y-axis location
    z_l= data{1,4};  %z-axis location
    exps=data{1,10}; %experiments

    t_diff=[diff(t);0];
    
    % t_diff=zeros(length(t),1); %pre-allocation
    % for i=1:length(t)-1
    %     t_diff(i,1) = t(i+1,1)-t(i,1); %the time spent in each location in recordings
    % end
    
    I=4;
    x_l_r = round(x_l * I)/I; %rounded x-axis location 
    y_l_r = round(y_l * I)/I; %rounded x-axis location
    z_l_r = round(z_l * I)/I; %rounded z-axis location
    
    A=[x_l_r y_l_r z_l_r t_diff]; 
    
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
        [C{j},IA,IC] = unique(exps_seperated{j}(:,1:3),'rows');
        
        C{j}(:,4)=0;
            for i=1:length(IC)
                C{j}(IC(i,1),4) = C{j}(IC(i,1),4) + exps_seperated{j}(i,4);
            end
        %indices = find(IC==240); %it's for checking manually for seeing the "for loop" works
    
        x = C{j}(:,1);
        y = C{j}(:,2);
        z = C{j}(:,3);
        w = C{j}(:,4);      
    end
    info_matrix_3d{k+1}=C;
end
save('info_matrix_3d_single', 'info_matrix_3d')


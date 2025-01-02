clear all, close all,clc
addpath("class")
I=4;
grid_I_x = [-6:1/I:6];
grid_I_y = [-6:1/I:6];
grid_I_z = [5:1/I:9];

% load('info_matrix_3d.mat');
% 
% I=4;
% grid_I_x = [-6:1/I:6];
% grid_I_y = [-6:1/I:6];
% grid_I_z = [5:1/I:9];
% 
% for i=1:length(info_matrix_3d)
%     for j=1:length(info_matrix_3d{1,1})
%         d=info_matrix_3d{1,i}{j};
%         H{i,j}=scatter3(d(:,1),d(:,3),d(:,2),40,d(:,4),'filled');
%         x_vector{i,j}=H{i,j}.XData;%x
%         z_vector{i,j}=H{i,j}.YData;%z
%         y_vector{i,j}=H{i,j}.ZData;%y
%         w_vector{i,j}=H{i,j}.CData;%w
%     end
% end

% save('x_vector', 'x_vector')
% save('z_vector', 'z_vector')
% save('y_vector', 'y_vector')
% save('w_vector', 'w_vector')


load('w_vector.mat')
load('x_vector.mat')
load('y_vector.mat')
load('z_vector.mat')

num_users=22;
num_exps=96;

%mapping locations to indexes to build sparse 3d matrix
for i=1:num_users
    for j=1:num_exps
        for k=1:length(x_vector{i,j})
            index=find(grid_I_x==x_vector{i,j}(k));
            x_vector_mapped{i,j}(k)=index;
        end
    end
end

for i=1:num_users
    for j=1:num_exps
        for k=1:length(z_vector{i,j})
            index=find(grid_I_y==z_vector{i,j}(k));
            z_vector_mapped{i,j}(k)=index;
        end
    end
end

for i=1:num_users
    for j=1:num_exps
        for k=1:length(y_vector{i,j})
            index=find(grid_I_z==y_vector{i,j}(k));
            y_vector_mapped{i,j}(k)=index;
        end
    end
end

Nx=length(grid_I_x);
Ny=length(grid_I_y);
Nz=length(grid_I_z);

% x=[x_vector_mapped{1,1},Nx];
% z=[z_vector_mapped{1,1},Ny];
% y=[y_vector_mapped{1,1},Nz];
% w=[w_vector{1,1};0];
% snn = ndSparse.build([x',z',y'],w);%https://it.mathworks.com/matlabcentral/fileexchange/29832-n-dimensional-sparse-arrays
% snn = ndSparse.build([x_vector_mapped{1,1}',z_vector_mapped{1,1}',y_vector_mapped{1,1}'],w_vector{1,1});

for i=1:num_users
    for j=1:num_exps
        x=[x_vector_mapped{i,j},Nx];
        z=[z_vector_mapped{i,j},Ny];
        y=[y_vector_mapped{i,j},Nz];
        w=[w_vector{i,j};0];
        snn{i,j} = ndSparse.build([x',z',y'],w);
    end
end

%change sparse matrix into full matrix
for i=1:num_users
    for j=1:num_exps
        snn_full{i,j}=full(snn{i,j});
    end
end

%3D GAUSSIAN FILTERING

for i=1:num_users
    for j=1:num_exps
        snn_full_filtered{i,j}=imgaussfilt3(snn_full{i,j},1.85);
    end
end

c=1;
for i=1:num_users
    for j=1:num_exps
        a = [snn_full{i,j}(:)];   % M = [snn_full{1,1}(:) snn_full{1,2}(:) ... snn_full{22,96}(:)]
        M(:,c) = a/norm(a);   
        b = [snn_full_filtered{i,j}(:)];   % M_filtered = [snn_full_filtered{1,1}(:) snn_full_filtered{1,2}(:) ... snn_full_filtered{22,110}(:)]
        M_filtered(:,c) = b/norm(b);  
        c=c+1;
    end
end

%filter or not?
% Crr=M_filtered'*M_filtered;
 Crr=M'*M;

%Crr=corr(M);
indices = find(isnan(Crr) == 1);
% Crr(isnan(Crr))=0;
Crr = Crr - diag(diag(Crr));
clusters_3d = [];

for k=1:100
%     disp(k)
    clusters_3d(:,k) = community_louvain(Crr,1);
end
clusters_3d = consensus_und(agreement(clusters_3d),0.3,100);

%save('clusters_3d', 'clusters_3d')
% save('clusters_3d_after_filtering', 'clusters_3d')


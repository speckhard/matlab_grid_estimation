% Let's get the MI data for different downsampling

% Load the data
data_limits = 'W10..BV525610';
node_volt_matrix = csvread('/Users/Dboy/Downloads/SG_data_node_volt_solar.csv',...
    9,22, data_limits);
true_branch_data = Sandia;
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
%true_branch_data = SandiaNationalLabTrueNodeDataSheet2;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data);

num_nodes = numel(node_volt_matrix(1,:))
dsample_vec = [1 5 15 30 60];
MI_master_mat = zeros(34,34, numel(dsample_vec));
%% Let's Get the MI data
MI_rows = zeros(numel(dsample_vec), num_nodes);

for i = 1:numel(dsample_vec)
    
    % Down-sample the data.
    node_volt_matrix_dsampled = downsample_v(node_volt_matrix, ...
        dsample_vec(i), 'first', 'no deriv');
    
    % Compute the SDR
    compute_sdr = @run_chow_liu_return_xnode;
    [sdr, estimated_branch_list, MI_mat, leaf_node_SDR, ...
        two_branch_node_SDR, three_branch_node_SDR]= ...
        compute_sdr(node_volt_matrix_dsampled,true_branch_data, ...
       'gaussian','deriv', 'no variable deriv step', ...
        'no discretization', 'use all digits', 'no sig dig');
    disp('the sdr')
    sdr
    reflect_mat = @reflect_lower_triang_mat;
    MI_mat = reflect_lower_triang_mat(MI_mat);
    MI_master_mat(:,:,i) = MI_mat; 
    
    %n35_MI(i,:) = MI_mat(23,:); 

    
end
%% Now Let's Take MI data of the node we want to analyze 
MI_rows = zeros(numel(dsample_vec), num_nodes);
node2measure = 23;
for i = 1:numel(dsample_vec)
    MI_rows(i,:) = MI_master_mat(node2measure,:,i);
end

% Set the Diag Values MI(X,X) = 6
MI_rows(:,node2measure) = 8;
% Now sort, label and display the data

xlabels = dsample_vec
y = 1:34;
label = 1;


xlabels = dsample_vec
y = 1:34;
label = 1;

%
shortend_MI_rows = MI_rows(:,1:34);
% First plot the MI heatmap
% imagesc(y,xlabels, n9_MI)
imagesc(y,xlabels,shortend_MI_rows);

ylabel('Downsampling Resolution (Sample per Minute)')
xlabel('Bus Label')
yticks([0 15 30 45 60])
yticklabels({'1','5','15','30','60'})
%title('Node  for SG')
colorbar
colormap(hot)

ycor = linspace(0,60,5);
xcor = linspace(0.75,34,34);

order_vec = 1:1:34;

color = [0.0 0.5 0.8]
for i = 1:1:numel(shortend_MI_rows(:,1))
    
    [B,I] = sort(shortend_MI_rows(i,:),'descend');
    
    
    for j = 1:1:numel(shortend_MI_rows(1,:))
       txt1 = num2str(round(order_vec(j),1))
         text(I(j),ycor(i),txt1,'HorizontalAlignment','Center','Color',color,'FontSize',15)
    end
end

%
set(gca,'FontSize',17);
title('')


% % First plot the MI heatmap
% imagesc(y,xlabels, n35_MI)
% ylabel('Downsampling Resolution (Sample per Minute)')
% xlabel('Bus Label')
% % Add a colorbar
% colorbar
% % Colormap set to hot
% colormap(hot)
% 
% 
% 
% set(gca,'FontSize',17);
% for i = 1:numel(n35_MI(:,1))
%     
%     for j = 1:numel(n35_MI(1,:))
%        txt1 = num2str(round(n35_MI(i,j),1))
%             text(j,dsample_vec(i),txt1, 'HorizontalAlignment', ...
%         'center','FontSize',fontsize,'Color',[0 0 0], 'Position', [dsample_vec(i), j])
%     end
% end



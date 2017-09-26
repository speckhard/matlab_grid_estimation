% Script to test adding noise, and then seeing if collapsing nodes, still
% works

%% First, copy all of the Sandia data into a new matrix, avoid copying the
% Feeder node, in this case Node 53.
slack_bus = SGdatanodevoltsolar(:,53);
% First, copy the data minus the slack bus
node_volt_matrix = SGdatanodevoltsolar(:,1:52);
% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueNodeData(1:51,:);
%% Find Collapsed Matrix
find_collapsed_nodes_matrix = @collapsed_nodes_matrix;
collapsed_matrix = find_collapsed_nodes_matrix(node_volt_matrix);

%% Add Noise to Data
percent_noise_vec =1/100*[1; 0.1; 0.001; ;1E-5;...
    ;1E-7;1E-9;1E-11];
threshold_vec = [20;15;10;7];

sdr_true_mat = zeros(size(numel(percent_noise_vec),numel(threshold_vec)));
sdr_total_mat = zeros(size(numel(percent_noise_vec),numel(threshold_vec)));
for i=1:numel(percent_noise_vec);
    add_uniform_random_noise = @add_noise;
    node_volt_matrix_noise = add_uniform_random_noise(node_volt_matrix,...
        'local mean', percent_noise_vec(i));
    
%     %% Let's find the MI - with Gaussian Method   
%     find_single_node_entropy = @single_node_entropy_vmag_only;
%     single_node_entropy_vec = find_single_node_entropy(node_volt_matrix_noise);
%     
%     find_joint_entropy = @joint_entropy_vmag_only_fixed_neglog;
%     joint_entropy_matrix = find_joint_entropy(node_volt_matrix_noise);
%     disp('found joint entropy')
%     
%     find_mutual_information = @mutual_information;
%     mutual_information_matrix = find_mutual_information(...
%         single_node_entropy_vec, joint_entropy_matrix);
%     
%     max(max(mutual_information_matrix))
%     
    %% 
    for j = 1:numel(threshold_vec)
        % Find Collapsed Node List
        find_collapsed_nodes_list = @collapsed_nodes_list;
        collapsed_list = find_collapsed_nodes_list(node_volt_matrix_noise,...
            'no MI', threshold_vec(j));
        size(collapsed_list)
        
        % Find SDR
        find_sdr_collapsed_nodes = @sdr_collapsed_nodes;
        [sdr_true, sdr_total] = find_sdr_collapsed_nodes(collapsed_matrix,...
            collapsed_list);
        
        sdr_true_mat(i,j) = sdr_true*100
        sdr_total_mat(i,j) = sdr_total*100
    end
end




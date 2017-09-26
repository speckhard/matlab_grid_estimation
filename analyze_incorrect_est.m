% Script to check if the same nodes are being incorrectly predicted over
% and over again. 

MI_matrices = results.MI_matrices;
err_freq_list = 'empty';

data_limits = 'W10..KH8000';%'W10..BV525610';%'W10..KH525610';

node_volt_matrix = csvread('/Users/Dboy/Downloads/SG2_data_solar_15min.csv',...
   9,22, data_limits);
data_limits = 'A1..B271';%'A1..B51';%'A1..B271';
true_branch_data = csvread('/Users/Dboy/Documents/Stanny/Rajagopal/Python/True_branch_list.csv',...
    0,0, data_limits);

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data);

true_branch_mat = true_branch_data;
num_MI_matrices = numel(MI_matrices(1,1,:));
for d = 1:num_MI_matrices
    
    %% Find Min Span Tree using Kruskal.m
    tic
    find_min_span_tree = @kruskal;
    MI_matrix = MI_matrices(:,:,d);
    mat_of_connectivity = find_min_span_tree(MI_matrix);
    disp('time required to run Kruskal')
    toc
    
    %% Find the pairs from the Matrix of Connectivity
    number_of_buses = numel(true_branch_mat(:,1))+1;
    estimated_node_pairs = zeros(number_of_buses - 1,2);
    p = 0;
    for i = 2:number_of_buses
        for k = 1:i-1
            if (mat_of_connectivity(i,k) ~=0)
                p = p +1;
                estimated_node_pairs(p,:) = [i,k];
            end
        end
    end
    
    %% Find the incorrect branches
    find_wrong_branches = @incorrect_branches;
    incorrect_branches_mat = find_wrong_branches(true_branch_mat,...
        estimated_node_pairs);


    %% Update Err Freq List
    find_err_list = @err_node_list
    num_nodes = numel(true_branch_mat(:,1))+1
    err_freq_list = find_err_list(num_nodes, ...
        incorrect_branches_mat, err_freq_list)
end

    

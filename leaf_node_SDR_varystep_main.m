% Main file to find leaf node SDR of SG datasets
% Last edit: 11/27

%% Setup data
% First, copy the data minus the feeder bus
node_volt_matrix = SGdatanodevolt(:,1:52);
% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueBranchesData(1:51,:);

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 

%% Find leaf Nodes
find_leafs = @find_leaf_nodes;
leaf_node_list = find_leafs(true_branch_data);

%% Take a lens of data
lens_size_vec = 24*60*[5 10 15 20 25 30 50 100 365];
sdr_mat = zeros(2,numel(lens_size_vec),2,2);
num_mins = numel(node_volt_matrix(:,1));

delay_size_vec = [2,5,10];
for g = 1:numel(delay_size_vec)
    node_volt_matrix_deriv = vary_deriv_step(node_volt_matrix,...
        delay_size_vec(i));
    for k = 1:2
        
        if k == 1
            num_bits = 'no discretization';
            MI_method = 'gaussian';
        elseif k ==2
            num_bits = 14;
            MI_method = 'JVHW';
        elseif k == 3
            num_bits = 14;
            MI_method = 'discrete';
        end
        for i = 1:numel(lens_size_vec)
            num_of_lenses = floor(num_mins/lens_size_vec(i));
            lens_size = lens_size_vec(i);
            temp_sdr_vec = zeros(1, num_of_lenses);
            for j = 1:num_of_lenses
                node_volt_mat_lens = node_volt_matrix_deriv((j-1)*lens_size+1:...
                    j*lens_size,:);
                
                %% Find the mutual information of data
                find_MI_mat = @find_vmag_MI;
                mutual_information_mat = find_MI_mat(node_volt_mat_lens, 'gaussian', ...
                    'no discretization');
                %% Reflect MI
                reflect_MI_mat = @reflect_lower_triang_mat;
                mutual_information_mat = reflect_MI_mat(mutual_information_mat);
                
                
                %% Find leaf SDR
                find_leafSDR = @leaf_node_SDR;
                success_counter = find_leafSDR(mutual_information_mat, leaf_node_list,...
                    true_branch_data);
                
                percent_success = success_counter/numel(leaf_node_list)*100;
                temp_sdr_vec(j) = percent_success;
            end
            mean_sdr = mean(temp_sdr_vec);
            std_sdr = std(temp_sdr_vec);
            sdr_mat(1,i,k,g) = mean_sdr;
            sdr_mat(2,i,k,g) = std_sdr;
        end
    end
end
    


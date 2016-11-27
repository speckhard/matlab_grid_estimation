%% First, copy all of the Sandia data into a new matrix, avoid copying the
% Feeder node, in this case Node 53.
% slack_bus = SGdatanodevolt(:,53);
% First, copy the data minus the slack bus
node_volt_matrix = SGdatanodevoltsolar(:,1:52);
% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueNodeData(1:51,:);

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 

%% downsample_vec = [5]
lens_size_vec = [60*24*7*51];
take_lens = @sliding_lens;
sdr_mean = zeros(numel(lens_size_vec))
sdr_std = zeros(numel(lens_size_vec))
num_observations = numel(node_volt_matrix(:,1);

for i = 1:numel(lens_size_vec)
    lens_size = lens_size_vec(i)
    num_lenses = 525601 - (lens_size/2
    temp_sdr_vec = zeros(size(num_lenses))
    while lens_end < num_observations;       
        node_volt_matrix_lens = sliding_lens(node_volt_matrix, ...
            lens_size,j);
        
        compute_sdr = @run_chow_liu_options;
        sdr = compute_sdr(node_volt_matrix_downsampled,true_branch_data, ...
            'gaussian','no_deriv','nograph','no heat_map', ...
        'no discretization'); 
        temp_sdr_vec(j) = sdr;
    end
    sdr_mean = mean(temp_sdr_vec)
    sdr_std = std(temp_sdr_vec)
end

sdr_mat(g,j) = sdr;

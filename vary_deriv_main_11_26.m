% First, copy the data minus the feeder bus
node_volt_matrix = SGdatasolar60min(:,1:52);
% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueBranchesData(1:51,:);

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 

%% Consider The Variable Derivative, with a Gaussian MI
vary_deriv_step = @var_deriv;
delay_size_vec = [1, 2, 5, 10, 20, 30, 40, 50, 60]
sdr_vec = zeros(1, numel(delay_size_vec));
for i = 1:numel(delay_size_vec)
    node_volt_matrix_deriv = vary_deriv_step(node_volt_matrix,...
        delay_size_vec(i));
    
    compute_sdr = @run_chow_liu_options;
    sdr = compute_sdr(node_volt_matrix_deriv,true_branch_data, ...
        'gaussian','no_deriv','nograph','no heat_map',...
        'no discretization')
    sdr_vec(i) = sdr;
end

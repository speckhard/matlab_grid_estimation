% First, copy the data minus the feeder bus
node_volt_matrix = SGdatasolar60min(:,1:52);
% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueBranchesData(1:51,:);

%% Consider Sig Dig
sig_dig_round = @sig_dig;
sig_dig_vec = [1E-2, 1E-1, 1E0, 1E1, 1E2 ,1E3];
sdr_mat = zeros(3, numel(sig_dig_vec));
for i = 1:numel(sig_dig_vec)
    %% Sig Dig of Data
    node_volt_matrix = sig_dig_round(node_volt_matrix,...
        sig_dig_vec(i));
    %% Remove redundant nodes from the dataset.
    collapse_data = @collapse_redundant_data;
    [node_volt_matrix, true_branch_data] = ...
        collapse_data(node_volt_matrix, true_branch_data);
    %% Remove Redundant Branches
    remove_useless_branches = @remove_redundant_branches;
    collapsed_branch_data = remove_useless_branches(true_branch_data);
    
    %% Consider The Derivative Instead
    take_derivative = @consider_derivative;
    node_volt_matrix = take_derivative(node_volt_matrix);

    for j = 1:3
        if j == 1
            num_bits = 'no discretization';
            MI_method = 'gaussian';
        elseif j ==2
            num_bits = 14;
            MI_method = 'JVHW';
        elseif j == 3
            num_bits = 14;
            MI_method = 'discrete';
        end
        compute_sdr = @run_chow_liu_options;
        sdr = compute_sdr(node_volt_matrix_deriv,true_branch_data, ...
            MI_method,'no_deriv','nograph','no heat_map',...
            num_bits)
        sdr_mat(j,i) = sdr;
    end
end

save('sdr_sig_dig_deriv_SGnosolar_main_11_26','sdr_mat')

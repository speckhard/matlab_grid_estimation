% First, copy the data minus the feeder bus
node_volt_matrix = SGdatanodevolt(:,1:52);
% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueNodeData(1:51,:);

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 

%% Consider Sig Dig
sig_dig_round = @sig_dig;
sig_dig_vec = [1E1, 0.5E2, 1E2 , 0.5E3];
sdr_mat = zeros(3, numel(sig_dig_vec));

for i = 1:numel(sig_dig_vec)
    node_volt_matrix_sig = sig_dig_round(node_volt_matrix,...
        sig_dig_vec(i));
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
        %% Consider The Derivative Instead
        take_derivative = @consider_derivative;
        node_volt_matrix_sig_deriv = take_derivative(node_volt_matrix_sig);
        
        compute_sdr = @run_chow_liu_options;
        sdr = compute_sdr(node_volt_matrix_sig_deriv,true_branch_data, ...
            MI_method,'no_deriv','nograph','no heat_map',...
            num_bits)
        sdr_mat(j,i) = sdr;
    end
end

save('sdr_sig_dig_deriv_SGnosolar_main_12_3','sdr_mat')

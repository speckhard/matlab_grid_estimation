%% First, copy all of the Sandia data into a new matrix, avoid copying the
data_limits = 'W10..BW8770';
M = csvread('/Users/Dboy/Downloads/SG_data_solar_60min.csv',...
   9,22, data_limits);
%% Second, copy the list of true branches.
true_branch_data = R4_truebranchlist;
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative Instead
take_derivative = @consider_derivative;
node_volt_matrix = take_derivative(node_volt_matrix);
%% Run Chow-Liu
MI_vector = [string('gaussian'),string('JVHW'), string('discrete')];
num_bits_vector = [12 14] %,6,8,10,12];
sdr_mat = zeros(numel(num_bits_vector),numel(MI_vector));
for j = 1:numel(num_bits_vector);
    for i = 1:numel(MI_vector)
        %% Run Chow-Liu 
        compute_sdr = @run_chow_liu_options;
        sdr = compute_sdr(node_volt_matrix,true_branch_data, ...
            MI_vector(i),'no_deriv','nograph','no heat_map', num_bits_vector(j))
        sdr_mat(j,i) = sdr;
    end
end
%% Save Data
save('SG2_1min_12_2','sdr_mat')
% Main File to run MI Methods vs SDR, where derivative can be switched on
% and off. 

%% First, copy all of the Sandia data into a new matrix, avoid copying the
data_limits = 'W10..BW8770';
node_volt_matrix = csvread('/Users/Dboy/Downloads/SG_data_solar_60min.csv',...
   9,22, data_limits);
%% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueNodeData;
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative Instead

time_resolution_vec = [5 15 30 60]; 
sdr_mat = zeros(3,numel(time_resolution_vec));
% Cycle through the time resolutions of data
for j = 1:numel(time_resolution_vec);
    % Downsample and take the derivative of the data. 
    node_volt_matrix_downsampled_deriv = downsample_v(node_volt_matrix, ...
    time_resolution_vec(j), 'last', 'deriv');

    for i = 1:3
        if i == 1
            MI_vector = 'gaussian';
            num_bits = 'no discretization';
        elseif i == 2
            MI_vector = 'JVHW';
            num_bits = 14;
        else i == 3
            MI_vector = 'discrete';
            num_bits = 14;
        end
        
        %% Run Chow-Liu 
        compute_sdr = @run_chow_liu_options;
        sdr = compute_sdr(node_volt_matrix_downsampled_deriv,...
            true_branch_data,MI_vector,'no_deriv','nograph',...
            'no heat_map', num_bits)
        sdr_mat(i,j) = sdr;
    end
end
%% Save Data
save('SG_last_resolution_vs_SDR_12_3','sdr_mat')
%% First, copy all of the Sandia data into a new matrix, avoid copying the
% % Feeder node, in this case Node 53.
% slack_bus = SGdatanodevolt(:,53);
% First, copy the data minus the slack bus
node_volt_matrix = SGdatanodevoltsolar(:,1:52);
% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueNodeData(1:51,:);

% %% 123 Node
% % Feeder node, in this case Node 53.
% slack_bus = v_vec(:,1);
% % First, copy the data minus the slack bus
% node_volt_matrix = v_vec(:,2:end);
% % Second, copy the list of true branches.
% true_branch_data = mpc_base.branch(:,1:2)-1;
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 
%% Add Noise to Data
percent_noise_vec = 1/100*[1E-4, 0.5E-3, 1E-3, 0.5E-2, 0.01E-2];
sdr_vec = zeros(numel(percent_noise_vec),3);
for i = 1:numel(percent_noise_vec);
    
    add_uniform_random_noise = @add_noise;
    node_volt_matrix_noise = add_uniform_random_noise(node_volt_matrix,...
        'local_mean', percent_noise_vec(i));
    %% Consider The Derivative Instead
    take_derivative = @consider_derivative;
    node_volt_matrix_noise_deriv = take_derivative(node_volt_matrix_noise);
    %% Digitize the Input
    digitizer = @digitize_sig; % Import the digitizer
    bits_desired = 8;
    node_volt_matrix_digital = digitizer(node_volt_matrix_noise_deriv, ...
        bits_desired, 'local','local');
    
    for j =1:3
        if j ==1 
            MI_method = 'gaussian';
        elseif j ==2
            MI_method = 'JVHW';
        else MI_method = 'discrete';
        end
    
%% Run Chow-Liu 
    compute_sdr = @run_chow_liu_options;
    sdr_vec(i,j) = compute_sdr(node_volt_matrix_digital,...
        true_branch_data, ...
        MI_method,'no deriv', 'nograph','no heat_map','no discretization')
        
    end
    
end


% %% Plot the MI data
% find_MI_heatmap = @run_chow_liu_options_heatmap;
% sdr = find_MI_heatmap(node_volt_matrix_downsampled, ...
%     true_branch_data,'gaussian','nograph','heatmap',10)

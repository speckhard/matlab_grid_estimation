%% First, copy all of the Sandia data into a new matrix, avoid copying the
% Feeder node, in this case Node 53.
% slack_bus = SGdatanodevolt(:,53);
% First, copy the data minus the slack bus
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
% %% Add Noise to Data
% percent_noise = 1/100*0.1;
% add_uniform_random_noise = @add_noise
% node_volt_matrix_noise = add_uniform_random_noise(node_volt_matrix,...
%     'node_specific_min_max', percent_noise);

%% Consider The Derivative Instead
% take_derivative = @consider_derivative;
% node_volt_matrix = take_derivative(node_volt_matrix);

%% Downsample  Data to 60 mins
% downsampler = @downsample_v;
% downsampling_interval_mins = 60; % every sixty mins one sample is saved
% node_volt_matrix_downsampled = downsampler(node_volt_matrix, ...
%     downsampling_interval_mins, 'median', 'deriv');
% mean(mean(node_volt_matrix_downsampled))
% %% Digitize the Input
% digitizer = @digitize_sig; % Import the digitizer
% bits_desired = 8;
% node_volt_matrix_digital = digitizer(node_volt_matrix, ...
%     bits_desired, 'local','local');

%% Test Performance of MI_vmag_discrete.m
%MI_vmag_discrete(node_volt_matrix_digital,bits_desired)

MI_vector = [string('gaussian'), string('JVHW'), string('discrete')];
num_bits_vector = [4,6,8,10,12];
sdr_mat = zeros(numel(MI_vector),numel(num_bits_vector));
for j = 1:numel(num_bits_vector);
    for i = 1:numel(MI_vector)
        %% Run Chow-Liu 
        compute_sdr = @run_chow_liu_options;
        sdr = compute_sdr(node_volt_matrix,true_branch_data, ...
            MI_vector(i),'no_deriv','nograph','no heat_map',num_bits_vector(j))
        sdr_mat(i,j) = sdr;
    end
end


% %% Plot the MI data
% find_MI_heatmap = @run_chow_liu_options_heatmap;
% sdr = find_MI_heatmap(node_volt_matrix_downsampled, ...
%     true_branch_data,'gaussian','nograph','heatmap',10)

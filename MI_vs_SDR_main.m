% Main File to run MI Methods vs SDR, where derivative needs to be set
% further down.
%% First, copy all except feeder SG data into a new matrix.
% 60 min file has 8770 datapoints
% 15 min file has 35050 datapoints
% Column W corresponds to Node 1, Column KI corresponds to node 273. We
% purposely leave out the feeder node since it's vmag value is not constant. 
data_limits = 'W10..KH525610';
% node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Downloads/SG2_data_solar_1min.csv',...
%    9,22, data_limits);
node_volt_matrix = v_vec(:,2:end);
%% Second, copy the list of true branches.
data_limits = 'A1..B271';
% true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
%     0,0, data_limits);
true_branch_data = squeeze(mpc_base.branch(:,1:2)-1);
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches.
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative of Data. 
take_derivative = @consider_derivative;
node_volt_matrix = take_derivative(node_volt_matrix);
%% Run Chow-Liu
% Number of nodes contained in data-set.
num_nodes = numel(node_volt_matrix(1,:));
% Create a matrix to save SDR data.
sdr_mat = zeros(3, 1);
compute_sdr = @run_chow_liu_return_data;
% Create a matrix to store estimated branches.
est_branch_matrices = zeros(num_nodes-1,2,3); 
% Create a matrix to store MI_matrix. 
MI_matrices = zeros(num_nodes,num_nodes,3);

for i = 1:3
    if i == 1
        MI_method = 'gaussian';
        num_bits = 'no discretization';
    elseif i == 2
        MI_method = 'JVHW';
        num_bits = 14;
    else 
        MI_method = 'MLE'
        num_bits = 14;
    end
    % Run Chow-Liu, return the sdr and the estimated branch list.
    [sdr, est_branch_list, mutual_information_mat] = ...
        compute_sdr(node_volt_matrix,true_branch_data, ...
        MI_method,'no_deriv','nograph',...
        'no heat_map', num_bits);
    % Store sdr.
    sdr_mat(i) = sdr
    % Store estimtated branches list.
    est_branch_matrices(:,:,i) = est_branch_list;
    % Store mutual information matrix.
    MI_matrices(:,:,i) = mutual_information_mat;
end

%% Calculate Bin Size, before saving. 
global_min = min(min(node_volt_matrix));
global_max = max(max(node_volt_matrix));
bin_size = (global_max-global_min)/(2^num_bits - 1);
%% Save Data
% Create a structure to store analysis data. 
field1 = 'sdr';
field2 = 'est_branches';
field3 = 'MI';
field4 = 'bin_size';
value1 = sdr_mat;
value2 = est_branch_matrices;
value3 = MI_matrices;
value4 = bin_size;
results = struct(field1, value1, field2, value2, field3, value3,...
    field4, value4);
% Save a .mat file.
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results/SG2-solar-1min-deriv_12_10-fixed272node'...
     ,'results')
%% Initialize Parallel Cluster Environment
cluster = parcluster('local')
tmpdirforpool = tempname
mkdir(tmpdirforpool)
cluster.JobStorageLocation = tmpdirforpool

msg = sprintf('setting matlabpool to %s', getenv('NSLOTS'))
cluster.NumWorkers = str2num(getenv('NSLOTS'))

parpool(cluster)
isempty(gcp('nocreate'))
%% Import Data to analyze 
% First, copy the data minus the feeder bus
% 60 min file has 8760 datapoints. End point 8770. 
% 15 min file has 35040 datapoints. End point 35050
% 1min file has 525600 datapoints. End point 525610
% Column W corresponds to Node 1, Column KI corresponds to node 273. We
% purposely leave out the feeder node since it's vmag value is not constant.
data_limits = 'W10..BV525610'% 'W10..KH525610';
% node_volt_matrix = csvread('/farmshare/user_data/dts/SG_data_node_volt.csv', ...
%     9,22,data_limits);
% node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG2_data_volt_1min.csv',...
%    9,22, data_limits);
% node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Downloads/SG2_data_solar_1min.csv',...
%    9,22, data_limits);
node_volt_matrix = csvread('/farmshare/user_data/dts/SG_data_node_volt.csv',...
   9,22, data_limits);

%node_volt_matrix = SGdatasolar60min(:,1:52);
% Second, copy the list of true branches.
data_limits = 'A1..B51';%'A1..B51';%'A1..B271';
% true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
%     0,0, data_limits);
true_branch_data = csvread('/farmshare/user_data/dts/SG1_true_branch_data.csv',...
    0,0, data_limits);
% true_branch_data = csvread('/Users/Dboy/Downloads/SG1_true_branch_data.csv',...
%     0,0, data_limits);
%true_branch_data = SandiaNationalLabTrueNodeData(1:51,:);
%true_branch_data = SGTrueBranchesData;
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data);
%% Add Noise to Data
percent_noise_vec = 1/100*[10^-4, 10^-3.5, 10^-3, 10^-2.5];
num_MI_methods = 3;
num_reps = 20; % Number of repititions to add noise.
sdr_mat = zeros(numel(percent_noise_vec),num_reps,num_MI_methods);
leaf_sdr_mat = zeros(numel(percent_noise_vec),num_reps,num_MI_methods);
two_branch_sdr_mat = ...
    zeros(numel(percent_noise_vec),num_reps,num_MI_methods);
three_branch_sdr_mat = ...
    zeros(numel(percent_noise_vec),num_reps,num_MI_methods);
MI_counter = 1;
num_nodes = numel(node_volt_matrix(1,:));
MI_matrices = zeros(num_nodes,num_nodes, num_MI_methods...
    *numel(percent_noise_vec));
est_branches_mat = zeros(num_nodes-1, 2, num_MI_methods*...
    numel(percent_noise_vec));

add_uniform_random_noise = @add_noise;
run_chow_liu = @run_chow_liu_return_xnode;

for i = 1:numel(percent_noise_vec);
    for j = 1:num_reps
        node_volt_matrix_noise = add_uniform_random_noise(node_volt_matrix,...
            'local_mean', percent_noise_vec(i));       
        for k = 1:num_MI_methods
            if k == 1
                num_bits = 'no discretization';
                MI_method = 'gaussian';
            elseif k ==2
                num_bits = 14;
                MI_method = 'JVHW';
            elseif k == 3
                num_bits = 14;
                MI_method = 'MLE';
            end
            %% Run Chow-Liu
            num_bits
            [sdr, estimated_branch_list, MI_mat, leaf_node_SDR, ...
                two_branch_node_SDR, three_branch_node_SDR] = ...
                run_chow_liu(node_volt_matrix_noise, ...
                true_branch_data, MI_method, 'deriv', 'no vary derive',...
                num_bits, 'no sig digits', 'n/a');          
            sdr
            leaf_node_SDR
            sdr_mat(i,j,k) = sdr;
            leaf_sdr_mat(i,j,k) = leaf_node_SDR;
            two_branch_sdr_mat(i,j,k) = two_branch_node_SDR;
            three_branch_sdr_mat(i,j,k) = three_branch_node_SDR;
            MI_matrices(:,:,MI_counter) = MI_mat;
            est_branches_mat(:,:,MI_counter) = estimated_branch_list;
            MI_counter = MI_counter +1;
        end        
    end   
end

%% Save Data as a structure
field1 = 'sdr_mat';
field2 = 'leaf_sdr_mat';
field3 = 'two_branch_sdr_mat';
field4 = 'three_branch_sdr_mat';
field5 = 'decimal_noise_vec';
field6 = 'MI_matrices';
field7 = 'est_branches_mat';
value1 = sdr_mat;
value2 = leaf_sdr_mat;
value3 = two_branch_sdr_mat;
value4 = three_branch_sdr_mat;
value5 = percent_noise_vec;
value6 = MI_matrices;
value7 = est_branches_mat;

results = struct(field1, value1, field2, value2, field3, value3,...
    field4, value4, field5, value5, field6, value6, field7, value7)
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results/noise/SG1_test'...
     ,'results')
 %% Close Parpool session
delete(gcp('nocreate'))


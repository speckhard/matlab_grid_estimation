% %% Initialize Parallel Cluster Environment
% cluster = parcluster('local')
% tmpdirforpool = tempname
% mkdir(tmpdirforpool)
% cluster.JobStorageLocation = tmpdirforpool
% 
% msg = sprintf('setting matlabpool to %s', getenv('NSLOTS'))
% cluster.NumWorkers = str2num(getenv('NSLOTS'))
% 
% parpool(cluster)
% isempty(gcp('nocreate'))
%% Import Data to analyze 
% First, copy the data minus the feeder bus
% 60 min file has 8760 datapoints. End point 8770. 
% 15 min file has 35040 datapoints. End point 35050
% 1min file has 525600 datapoints. End point 525610
% Column W corresponds to Node 1, Column KI corresponds to node 273. We
% purposely leave out the feeder node since it's vmag value is not constant.
data_limits = 'W10..BV525610';% 525610';%'W10..BV525610';%'W10..KH525610';
node_volt_matrix = csvread('/farmshare/user_data/dts/SG_data_node_volt.csv', ...
    9,22,data_limits);
% node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Downloads/SG2_data_solar_1min.csv',...
%    9,22, data_limits);
% node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG2_data_volt_1min.csv',...
%    9,22, data_limits);
% node_volt_matrix = csvread('/Users/Dboy/Downloads/SG_data_solar_60min.csv',...
%    9,22, data_limits);
%node_volt_matrix = SGdatasolar60min(:,1:52);
% Second, copy the list of true branches.
data_limits = 'A1..B51'; %'A1..B51';%'A1..B271';
% true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
%     0,0, data_limits);
true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG1_true_branch_data.csv',...
    0,0, data_limits);
% true_branch_data = csvread('/Users/Dboy/Downloads/SG1_true_branch_data.csv',...
%     0,0, data_limits);
%true_branch_data = SandiaNationalLabTrueNodeData(1:51,:);
%true_branch_data = SGTrueBranchesData;

% For 123 Node Network
% load('/Users/Dboy/Downloads/Node123_RandPF.mat')
% % Remove the feeder node 
% node_volt_matrix = v_vec(:,2:end);
% true_branch_data = mpc_base.branch(2:end,1:2);
% true_branch_data = true_branch_data -1;

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data);

%% Consider Sig Dig
time_interval_vec = [5 15 30 60];
sdr_mat = zeros(3, numel(num_dsample_methods));
leaf_sdr_mat = zeros(3, numel(num_dsample_methods));
two_branch_sdr_mat = zeros(3, numel(time_interval_vec), ...
    numel(num_dsample_methods));
three_branch_sdr_mat = zeros(3, numel(time_interval_vec), ...
numel(num_dsample_methods));
compute_sdr = @run_chow_return_xnode;
MI_mat_counter = 1;
num_MI_methods = 3;
num_nodes = numel(node_volt_matrix(1,:));
num_dsample_methods = 6;
MI_matrices = zeros(num_nodes,num_nodes, num_MI_methods...
    *numel(num_dsample_methods)*numel(time_interval_vec));

for h = 1:numel(time_interval_vec)
    for i = 1:num_dsample_methods
        if i == 1
            dsample_method = 'first'
        elseif i == 2
            dample_method = 'mean'
        elseif i == 3
            dample_method = 'median'
        elseif i == 4
            dsample_method = '95th'
        elseif i == 5
            dsample_method = 'max'
        elseif i == 6
            dsample_method = 'min'
        end
        dsample = @downsample_v;
        node_volt_matrix_dsampled = dsample(node_volt_matrix, ...
            time_interval_vec(h), dsample_method, 'no deriv');
        for j = 1:num_MI_methods
            if j == 1
                MI_method = 'gaussian';
                num_bits = 'no discretization';
            elseif j ==2
                MI_method = 'JVHW';
                num_bits = 14;
            elseif j == 3
                MI_method = 'MLE';
                num_bits = 14;
            end
            %% Consider The Derivative Instead
            compute_sdr = @run_chow_liu_return_xnode;
            [sdr, estimated_branch_list, MI_mat, leaf_node_SDR, ...
                two_branch_node_SDR, three_branch_node_SDR]= ...
                compute_sdr(node_volt_matrix_dsampled,true_branch_data, ...
                MI_method,'deriv', 'no variable deriv step', ...
                num_bits, 'use all digits', 'no sig dig');
            sdr
            leaf_node_SDR
            sdr_mat(j,h, i) = sdr;
            leaf_sdr_mat(j,h, i) = leaf_node_SDR;
            two_branch_sdr_mat(j,h, i) = two_branch_node_SDR;
            three_branch_sdr_mat(j,h,i) = three_branch_node_SDR;
            MI_matrices(:,:,MI_mat_counter) = MI_mat;
            MI_mat_counter = MI_mat_counter +1;
        end
    end
end

%% Save Data as a structure
field1 = 'sdr_mat';
field2 = 'leaf_sdr_mat';
field3 = 'two_branch_sdr_mat';
field4 = 'three_branch_sdr_mat';
field5 = 'MI_matrices';
field6 = 'time_interval_vec';
field7 = 'downsample_methods';
value1 = sdr_mat;
value2 = leaf_sdr_mat;
value3 = two_branch_sdr_mat;
value4 = three_branch_sdr_mat;
value5 = MI_matrices;
value6 = time_interval_vec;
value7 = ['first,', 'mean,', 'median,', '95th,', 'max,','min,'];

results = struct(field1, value1, field2, value2, field3, value3,...
    field4, value4, field5, value5, field6, value6);
%% Save a .mat file.
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results/SG1_deriv_dsample_method_12_24_v1'...
     ,'results')
 %% Close Matlab Parallel Environment
delete(gcp('nocreate'))

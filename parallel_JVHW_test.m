% Scirpt to test parallelization of JVHW method.

%% Initialize Parallel Cluster Environment
cluster = parcluster('local')
tmpdirforpool = tempname
mkdir(tmpdirforpool)
cluster.JobStorageLocation = tmpdirforpool

msg = sprintf('setting matlabpool to %s', getenv('NSLOTS'))
cluster.NumWorkers = str2num(getenv('NSLOTS'))

matlabpool(cluster)

%% First, copy all except feeder SG data into a new matrix.
% 60 min file has 8770 datapoints
% 15 min file has 35050 datapoints
% Column W corresponds to Node 1, Column KI corresponds to node 273. We
% purposely leave out the feeder node since it's vmag value is not constant. 
data_limits = 'W10..BV525610';
node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG2_data_volt_1min.csv',...
   9,22, data_limits);
% node_volt_matrix = csvread('/Users/Dboy/Downloads/SG_data_node_volt_solar.csv',...
%    9,22, data_limits);
%node_volt_matrix = v_vec(:,2:end);
%% Second, copy the list of true branches.
data_limits = 'A1..B51';
% true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
%     0,0, data_limits);
true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG1_true_branch_data.csv',...
    0,0, data_limits);
true_branch_data = csvread('/Users/Dboy/Downloads/SG1_true_branch_data.csv',...
    0,0, data_limits);
%true_branch_data = squeeze(mpc_base.branch(2:end,1:2)-1);
% %% Remove redundant nodes from the dataset.
% collapse_data = @collapse_redundant_data;
% [node_volt_matrix, true_branch_data] = ...
%     collapse_data(node_volt_matrix, true_branch_data);
% %% Remove Redundant Branches.
% remove_useless_branches = @remove_redundant_branches;
% true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative of Data.
take_derivative = @consider_derivative;
node_volt_matrix = take_derivative(node_volt_matrix);
%% Digitize the Data
digitizer = @digitize_sig; % Import the digitizer
num_bits = 14; % Set the number of bits for digitizing the data.
node_volt_matrix = digitizer(node_volt_matrix, ...
    num_bits, 'local','local');
%% Take the Regular Non-parallel JVHW
JVHW_MI = @find_JVHW_MI;
MI_mat_JVHW = JVHW_MI(node_volt_matrix, ...
    'no diagonals'); 
%% Find the par JVHW
JVHW_MI = @find_parallel_JVHW_MI;
MI_mat_JVHW_par = JVHW_MI(node_volt_matrix, ...
    'no diagonals'); 
%% Find the lin par JVHW
JVHW_MI = @find_lin_par_JVHW_MI;
MI_mat_JVHW_lin_par = JVHW_MI(node_volt_matrix); 
%% Compare the two matrices to ensure they are the same. 
if isequal(MI_mat_JVHW_par, MI_mat_JVHW)
    disp('MIs from par and non-par JVHW methods are the same')
else disp('MIs from par and non-par JVHW methods are not the same')
end
if isequal(MI_mat_JVHW, MI_mat_JVHW_lin_par)
    disp('MIs from lin-par and non-par JVHW methods are the same')
else disp('MIs from lin-par and non-par JVHW methods are not the same')
end

%% Close Matlab Parallel Environment
matlabpool close
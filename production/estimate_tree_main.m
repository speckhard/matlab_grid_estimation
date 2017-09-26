% This script serves as a main file to run grid topology estimation using
% scripts written in the Stanford Sustainable Systems Laboratory at
% Stanford University.
%
% Author: Daniel Speckhard
% E-mail: dts@stanford.edu
% Date of last revision: February 22nd, 2017

%% First, copy all data except feeder node data into a new matrix.
% Sample every 60 min file has 8770 datapoints for 1 year's worth of data.
% Sample every 15 min file has 35050 datapoints 1 year's worth of data.
data_limits = 'W10..BV8770'; 
node_volt_matrix = ...
    csvread(...
    '/Users/your_user_name/Downloads/SG_data_solar_60min.csv',...
    9,22, data_limits);

%% Second, copy the list of true branches.
data_limits = 'A1..B51';
true_branch_data = ...
    csvread(...
    '/Users/your_user_name/Downloads/SG1_true_branches.csv',...
    0,0, data_limits);
%% Remove redundant nodes from the dataset.
% This step looks for nodes in the input data that have excatly the same 
% data at each measurement. We call these nodes redundant nodes. This step 
% removes redundant nodes. This step can alter the node integer labels in 
% the input true branch matrix and input node voltage matrix fed into the 
% algorithm if redundant nodes are present. The resulting labelling for 
% both matrices will run from 1 - (# intial nodes - # redundant nodes).
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove redundant branches.
% This step removes any branches connecting one node to itself (e.g.
% (2,2)).
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data);

%% Set parmaters of the algorithm.
MI_method = 'gaussian'; % Other options are 'JVHW' and 'discrete'.
deriv_method ='deriv'; % This will consider the ?Vmag for MI calculations.
type_of_deriv = 'regular step size'; % This will set ? step sive for ?Vmag.
num_bits = 'no discretization'; % Change this to discretize data.
sig_digit_flag = 'no trimming of data'; % Change this to trim data
sig_digit = 'n/a'; % Change this to trim data to sig_digit signif. digits.
graph = 'graph'; % This will plot the graph of the estimated tree.

%% Run the algorithm on the data.
run_algorithm = @estimate_tree;

[sdr, estimated_branch_list, MI_mat, leaf_node_SDR] = ...
    run_algorithm(node_volt_matrix,true_branch_data, ...
    MI_method, deriv_method, type_of_deriv,...
    num_bits, sig_digit_flag, sig_digit, graph);

disp('The SDR is:')
disp(sdr)
disp('The leaf node SDR is:')
disp(leaf_node_SDR)



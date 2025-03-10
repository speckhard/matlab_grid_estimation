%% Import Data to analyze 
% First, copy the data minus the feeder bus
% 60 min file has 8760 datapoints. End point 8770. 
% 15 min file has 35040 datapoints. End point 35050
% 1min file has 525600 datapoints. End point 525610
% Column W corresponds to Node 1, Column KI corresponds to node 273. We
% purposely leave out the feeder node since it's vmag value is not constant.
data_limits = 'W10..KH525610';%'W10..BV525610';%'W10..KH525610';
% node_volt_matrix = csvread('/farmshare/user_data/dts/SG2_data_node_volt.csv', ...
%     9,22,data_limits);
node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Downloads/SG2_data_solar_1min.csv',...
   9,22, data_limits);
% node_volt_matrix = csvread('/Users/Dboy/Downloads/SG_data_node_volt_solar.csv',...
%    9,22, data_limits);
%node_volt_matrix = SGdatasolar60min(:,1:52);
% Second, copy the list of true branches.
data_limits = 'A1..B271';%'A1..B51';%'A1..B271';
true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
    0,0, data_limits);
% true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG1_true_branch_data.csv',...
%     0,0, data_limits);
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
sig_dig_round = @sig_dig;
sig_dig_vec = [1E0, 1E1, 1E2 , 1E3];
round_vec = [0, 1, 2, 3]; 
sdr_mat = zeros(3, numel(sig_dig_vec));

for i = 1:numel(sig_dig_vec)
    for j = 1:3
        if j == 1
            num_bits = 'no discretization';
            MI_method = 'gaussian';
        elseif j ==2
            num_bits = 14;
            MI_method = 'JVHW';
                node_volt_matrix = sig_dig_round(node_volt_matrix,...
        sig_dig_vec(i));
        elseif j == 3
            num_bits = 14;
            MI_method = 'discrete';
                            node_volt_matrix = sig_dig_round(node_volt_matrix,...
        sig_dig_vec(i));
        end
        %% Consider The Derivative Instead  
        compute_sdr = @run_chow_liu_options;
        sdr = compute_sdr(node_volt_matrix,true_branch_data, ...
            MI_method,'deriv','nograph','no heat_map',...
            num_bits)
        sdr_mat(j,i) = sdr;
    end
end

%% Save Data as a structure
field1 = 'mean_sdr_mat';
field2 = 'std_sdr_mat';
field3 = 'leaf_mean_sdr';
field4 = 'leaf_std_sdr';
field5 = 'two_branch_mean_sdr';
field6 = 'two_branch_std_sdr';
field7 = 'three_branch_mean_sdr';
field8 = 'three_branch_std_sdr';
field9 = 'downsample_vec';
field10 = 'lens_vec';
value1 = mean_sdr_mat;
value2 = std_sdr_mat;
value3 = leaf_mean_sdr_mat;
value4 = leaf_std_sdr_mat;
value5 = two_branch_mean_sdr_mat;
value6 = two_branch_std_sdr_mat;
value7 = three_branch_mean_sdr_mat;
value8 = three_branch_std_sdr_mat;
value9 = downsample_vec;
value10 = lens_size_vec;

results = struct(field1, value1, field2, value2, field3, value3,...
    field4, value4, field5, value5, field6, value6, field7, value7, ...
    field8, value8, field9, value9, field10, value10);
% Save a .mat file.
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results/SG2_solar_deriv_lens_res_corn_12_23_v1'...
     ,'results')

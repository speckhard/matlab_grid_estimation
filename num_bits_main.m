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
% data_limits = 'W10..KH525610';% 525610';%'W10..BV525610';%'W10..KH525610';
% node_volt_matrix = csvread('/farmshare/user_data/dts/SG2_data_volt_1min.csv', ...
%     9,22,data_limits);
% node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Downloads/SG2_data_solar_1min.csv',...
%    9,22, data_limits);
% node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG2_data_volt_1min.csv',...
%    9,22, data_limits);
% node_volt_matrix = csvread('/Users/Dboy/Downloads/SG2_data_solar_15min.csv',...
%    9,22, data_limits);
%node_volt_matrix = SGdatasolar60min(:,1:52);
% Second, copy the list of true branches.
%'A1..B51';%'A1..B271';
% true_branch_data = csvread('/farmshare/user_data/dts/SG2_true_branch_data.csv',...
%     0,0, data_limits);
% true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG1_true_branch_data.csv',...
%     0,0, data_limits);
% data_limits = 'A1..B271'
% true_branch_data = csvread('/Users/Dboy/Documents/Stanny/Rajagopal/Python/True_branch_list.csv',...
%     0,0, data_limits);
%true_branch_data = SandiaNationalLabTrueNodeData(1:51,:);
%true_branch_data = SGTrueBranchesData;

% % For 123 Node Network
% load('/Users/Dboy/Downloads/Node123_RandPF.mat')
% % Remove the feeder node
% node_volt_matrix = v_vec(:,2:end);
% true_branch_data = mpc_base.branch(2:end,1:2);
% true_branch_data = true_branch_data -1;


disp('here')
%% Consider Num Bits Vec
num_bits_vec = [4 6 8 10 12 14 16];
lens_size_vec = 24*60*[120];
mean_sdr_mat = zeros(3, numel(num_bits_vec));
std_sdr_mat = zeros(3, numel(num_bits_vec));
mean_leaf_sdr_mat = zeros(3, numel(num_bits_vec));
std_leaf_sdr_mat = zeros(3, numel(num_bits_vec));
mean_two_branch_sdr_mat = zeros(3, numel(num_bits_vec));
std_two_branch_sdr_mat = zeros(3, numel(num_bits_vec));
mean_three_branch_sdr_mat = zeros(3, numel(num_bits_vec));
std_three_branch_sdr_mat = zeros(3, numel(num_bits_vec));
compute_sdr = @run_chow_return_xnode;
MI_mat_counter = 1;
num_MI_methods = 3;
num_nodes = 220; %numel(node_volt_matrix(1,:));
MI_matrices = zeros(num_nodes,num_nodes, num_MI_methods*numel(num_bits_vec));
err_freq_mat = zeros(num_nodes, numel(num_bits_vec), num_MI_methods);
find_wrong_branches = @incorrect_branches;
gen_err_list = @err_node_list;

for i = 1:numel(num_bits_vec)
    num_bits = num_bits_vec(i)
    
    for j = 1:numel(lens_size_vec)
        num_mins = 525600; %% numel(node_volt_matrix(:,1));
        lens_size = lens_size_vec(j)
        
        if lens_size ~= floor(lens_size)
            error('non-integer lens/res combo')
        end
        
        temp_err_freq_mat = zeros(num_nodes, num_MI_methods);
        num_of_lenses = floor((num_mins)/lens_size)
        
        temp_sdr_mat = zeros( num_of_lenses, num_MI_methods);
        temp_leaf_sdr_mat = zeros( num_of_lenses, num_MI_methods);
        temp_2branch_sdr_mat = zeros(num_of_lenses, num_MI_methods);
        temp_3branch_sdr_mat = zeros( num_of_lenses, num_MI_methods);
        
        for k = 1:num_of_lenses
            
            if k == 1
                
                data_limits = 'W10..KH175210';% 525610';%'W10..BV525610';%'W10..KH525610';
                node_volt_matrix = csvread('/farmshare/user_data/dts/SG2_data_volt_1min.csv', ...
                9,22,data_limits);
                data_limits = 'A1..B271'
                true_branch_data = csvread('/farmshare/user_data/dts/SG2_true_branch_data.csv',...
                    0,0, data_limits);
            elseif k ==2 
                data_limits = 'W175210..KH350410'  
                node_volt_matrix = csvread('/farmshare/user_data/dts/SG2_data_volt_1min.csv', ...
                9,22,data_limits);            
            data_limits = 'A1..B271'
            true_branch_data = csvread('/farmshare/user_data/dts/SG2_true_branch_data.csv',...
                0,0, data_limits);
            elseif k ==3
                data_limits = 'W350410..KH525610'
                node_volt_matrix = csvread('/farmshare/user_data/dts/SG2_data_volt_1min.csv', ...
                    9,22,data_limits);
                data_limits = 'A1..B271'
                true_branch_data = csvread('/farmshare/user_data/dts/SG2_true_branch_data.csv',...
                    0,0, data_limits);
            end
            %% Remove redundant nodes from the dataset.
            collapse_data = @collapse_redundant_data;
            [node_volt_matrix, true_branch_data] = ...
                collapse_data(node_volt_matrix, true_branch_data);
            %% Remove Redundant Branches
            remove_useless_branches = @remove_redundant_branches;
            true_branch_data = remove_useless_branches(true_branch_data);

%             node_volt_mat_lens = ...
%                 node_volt_matrix((k-1)*lens_size+1:...
%                 k*lens_size,:);
            for l = 1:1% 1:num_MI_methods
                if l == 1
                    MI_method = 'gaussian';
                elseif l ==2
                    MI_method = 'JVHW';
                elseif l == 3
                    MI_method = 'MLE';
                end
                %% Consider The Derivative Instead
                compute_sdr = @run_chow_liu_return_xnode;
                [sdr, estimated_branch_list, MI_mat, leaf_node_SDR, ...
                    two_branch_node_SDR, three_branch_node_SDR]= ...
                    compute_sdr(node_volt_matrix,true_branch_data, ...
                    MI_method,'deriv', 'no variable deriv step', ...
                    num_bits, 'use all digits', 'no sig dig');
                
                sdr
                leaf_node_SDR
                temp_sdr_mat(k,l) = sdr;
                temp_leaf_sdr_mat(k,l) = leaf_node_SDR;
                temp_2branch_sdr_mat(k,l) = two_branch_node_SDR;
                temp_3branch_sdr_mat(k,l) = three_branch_node_SDR;
                incorrect_branch_mat = find_wrong_branches(...
                    true_branch_data, estimated_branch_list);
                temp_err_freq_mat(:,l) = gen_err_list(...
                    num_nodes, incorrect_branch_mat,...
                    temp_err_freq_mat(:,l));
                MI_matrices(:,:,MI_mat_counter) = MI_mat;
                MI_mat_counter = MI_mat_counter +1;
            end
        end
        mean_sdr_mat(:,i) = mean(temp_sdr_mat,1);
        std_sdr_mat(:,i) = std(temp_sdr_mat,1,1);
        mean_leaf_sdr_mat(:,i) = mean(temp_leaf_sdr_mat,1);
        std_leaf_sdr_mat(:,i) = std(temp_leaf_sdr_mat,1,1);
        mean_two_branch_sdr_mat(:,i) = mean(temp_2branch_sdr_mat,1);
        std_two_branch_sdr_mat(:,i) = std(temp_2branch_sdr_mat,1,1);
        mean_three_branch_sdr_mat(:,i) = mean(temp_3branch_sdr_mat,1);
        std_three_branch_sdr_mat(:,i) = std(temp_3branch_sdr_mat,1,1);
        err_freq_mat(:,i,:) = temp_err_freq_mat./num_of_lenses;
    end
end
%% Save Data as a structure
field1 = 'mean_sdr_mat';
field2 = 'std_sdr_mat';
field3 = 'mean_leaf_sdr_mat';
field4 = 'std_leaf_sdr_mat';
field5 = 'mean_two_branch_sdr_mat';
field6 = 'std_two_branch_sdr_mat';
field7 = 'mean_three_branch_sdr_mat';
field8 = 'std_three_branch_sdr_mat';
field9 = 'MI_matrices';
field10 = 'num_bits';
field11 = 'err_freq_mat';
value1 = mean_sdr_mat;
value2 = std_sdr_mat;
value3 = mean_leaf_sdr_mat;
value4 = std_leaf_sdr_mat;
value5 = mean_two_branch_sdr_mat;
value6 = std_two_branch_sdr_mat;
value7 = mean_three_branch_sdr_mat;
value8 = std_three_branch_sdr_mat;
value9 = MI_matrices;
value10 = num_bits_vec;
value11 = err_freq_mat;

results = struct(field1, value1, field2, value2, field3, value3,...
    field4, value4, field5, value5, field6, value6,...
    field7, value7, field8, value8, field9, value9, ...
    field10, value10, field11, value11);
%% Save a .mat file.
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results/num_bits/SG2_deriv_num_bits_lens_2_12_G_only_v4_corn'...
    ,'results')

%% Close Matlab Parallel Environment
delete(gcp('nocreate'))

% Scirpt to find the x node SDR and regular SDR for different lenses of
% data and different first type downsampling resoltions.

%% Import Data to analyze 
% First, copy the data minus the feeder bus
% 60 min file has 8760 datapoints. End point 8770. 
% 15 min file has 35040 datapoints. End point 35050
% 1min file has 525600 datapoints. End point 525610
% Column W corresponds to Node 1, Column KI corresponds to node 273. We
% purposely leave out the feeder node since it's vmag value is not constant.
data_limits = 'W10..BV525610';%'W10..KH525610';
node_volt_matrix = csvread('/farmshare/user_data/dts/SG_data_node_volt.csv', ...
    9,22,data_limits);
% node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG2_data_volt_1min.csv',...
%    9,22, data_limits);
% node_volt_matrix = csvread('/Users/Dboy/Downloads/SG_data_node_volt_solar.csv',...
%    9,22, data_limits);
%node_volt_matrix = SGdatasolar60min(:,1:52);
% Second, copy the list of true branches.
data_limits = 'A1..B51';%'A1..B271';
% true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
%     0,0, data_limits);
true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG1_true_branch_data.csv',...
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
%% Downsample the data
downsample_vec = [1, 5, 15, 30, 60];
lens_size_vec = 24*60*[1 4 7 14 30 60 90 180 364];
run_chow_liu = @run_chow_liu_return_xnode;
num_MI_methods = 3;
mean_sdr_mat = zeros(numel(downsample_vec),numel(lens_size_vec),...
    num_MI_methods);
std_sdr_mat = zeros(numel(downsample_vec),numel(lens_size_vec),...
    num_MI_methods);
leaf_mean_sdr_mat = zeros(numel(downsample_vec),numel(lens_size_vec),...
    num_MI_methods);
leaf_std_sdr_mat = zeros(numel(downsample_vec),numel(lens_size_vec),...
    num_MI_methods);
two_branch_mean_sdr_mat = zeros(numel(downsample_vec),...
    numel(lens_size_vec),num_MI_methods);
two_branch_std_sdr_mat = zeros(numel(downsample_vec),...
    numel(lens_size_vec),num_MI_methods);
three_branch_mean_sdr_mat = zeros(numel(downsample_vec),...
    numel(lens_size_vec),num_MI_methods);
three_branch_std_sdr_mat = zeros(numel(downsample_vec),...
    numel(lens_size_vec),num_MI_methods);

for i = 1:numel(downsample_vec);
    node_volt_mat_downsampled = downsample_v(node_volt_matrix, ...
        downsample_vec(i), 'first', 'deriv') ; 
              
        for j = 1:numel(lens_size_vec)
            num_mins = numel(node_volt_mat_downsampled(:,1));
            lens_size = lens_size_vec(j)/downsample_vec(i);
            
            if lens_size ~= floor(lens_size)
                error('non-integer lens/res combo')
            end
            
            num_of_lenses = floor((num_mins)/lens_size);

            temp_sdr_mat = zeros( num_of_lenses, num_MI_methods);
            temp_leaf_sdr_mat = zeros( num_of_lenses, num_MI_methods);
            temp_2branch_sdr_mat = zeros(num_of_lenses, num_MI_methods);
            temp_3branch_sdr_mat = zeros( num_of_lenses, num_MI_methods);
            
            for k = 1:num_of_lenses
                node_volt_mat_lens = ...
                    node_volt_mat_downsampled((k-1)*lens_size+1:...
                    k*lens_size,:);
                
                for l = 1:num_MI_methods
                    if l == 1
                        num_bits = 'no discretization';
                        MI_method = 'gaussian';
                    elseif l ==2
                        num_bits = 14;
                        MI_method = 'JVHW';
                    elseif l == 3
                        num_bits = 14;
                        MI_method = 'MLE';
                    end
                    [sdr, estimated_branch_list, MI_mat, leaf_node_SDR, ...
                        two_branch_node_SDR, three_branch_node_SDR] = ...
                        run_chow_liu(node_volt_mat_lens, ...
                        true_branch_data, MI_method, 'no deriv', num_bits);
                    sdr
                    leaf_node_SDR
                    temp_sdr_mat(k,l) = sdr;
                    temp_leaf_sdr_mat(k,l) = leaf_node_SDR;
                    temp_2branch_sdr_mat(k,l) = two_branch_node_SDR;
                    temp_3branch_sdr_mat(k,l) = three_branch_node_SDR;
                end        
            end
            mean_sdr_mat(i,j,:) = mean(temp_sdr_mat,1);
            std_sdr_mat(i,j,:) = std(temp_sdr_mat,1,1);
            leaf_mean_sdr_mat(i,j,:) = mean(temp_leaf_sdr_mat,1);
            leaf_std_sdr_mat(i,j,:) = std(temp_leaf_sdr_mat,1,1);
            two_branch_mean_sdr_mat(i,j,:) = mean(temp_2branch_sdr_mat,1);
            two_branch_std_sdr_mat(i,j,:) = std(temp_2branch_sdr_mat,1,1);
            three_branch_mean_sdr_mat(i,j,:) = mean(temp_3branch_sdr_mat,1);
            three_branch_std_sdr_mat(i,j,:) = std(temp_3branch_sdr_mat,1,1);
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
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results/SG1_deriv_lens_res_barley_12_16_v6'...
     ,'results')

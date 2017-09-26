% Main file to find lens size vs SDR for all MI methods. 
% Last edit: 12/12

%% Setup data
%% First, copy all of the Sandia data into a new matrix, avoid copying the
data_limits = 'W10..BW525610';
node_volt_matrix = csvread(...
    '/afs/ir.stanford/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG_data_node_volt.csv',...
   9,22, data_limits);
% Remove feeder bus
node_volt_matrix = node_volt_matrix(:,1:52);
%% Second, copy the list of true branches, remove the feeder bus
true_branch_data = SandiaNationalLabTrueNodeData; 
true_branch_data = true_branch_data(1:51,:);

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 

%% Consider The Derivative Instead
take_derivative = @consider_derivative;
node_volt_matrix = take_derivative(node_volt_matrix);
%% Take a lens of data
lens_size_vec = 24*60*[30 90 180];
sdr_mat = zeros(2,3,numel(lens_size_vec));
num_mins = numel(node_volt_matrix(:,1));
compute_sdr = @run_chow_liu_options;

for k = 1:3
    if k == 1
        num_bits = 'no discretization';
        MI_method = 'gaussian';
    elseif k ==2
        num_bits = 14;
        MI_method = 'JVHW';
    elseif k == 3
        num_bits = 14;
        MI_method = 'discrete';
    end
    for i = 1:numel(lens_size_vec)
        num_of_lenses = floor(num_mins/lens_size_vec(i));
        lens_size = lens_size_vec(i);
        temp_sdr_vec = zeros(1, num_of_lenses);
        for j = 1:num_of_lenses
            node_volt_mat_lens = node_volt_matrix((j-1)*lens_size+1:...
                j*lens_size,:);
            
            
            sdr = compute_sdr(node_volt_mat_lens,...
                true_branch_data,MI_method,'no_deriv','nograph',...
                'no heat_map', num_bits)
            temp_sdr_vec(j) = sdr;
        end
        mean_sdr = mean(temp_sdr_vec);
        std_sdr = std(temp_sdr_vec);
        sdr_mat(1,k,i) = mean_sdr;
        sdr_mat(2,k,i) = std_sdr;
    end
end

%% Save Data
save(...
    '/afs/ir.stanford/users/d/t/dts/Documents/Rajagopal/Sandia Data/lens_vs_SDR_12_3_SG',...
    'sdr_mat')
gaussian_sdr_mean = squeeze(sdr_mat(1,1,:));
gaussian_sdr_std = squeeze(sdr_mat(2,1,:));
JVHW_sdr_mean = squeeze(sdr_mat(1,2,:));
JVHW_sdr_std = squeeze(sdr_mat(2,2,:));
discrete_sdr_mean = squeeze(sdr_mat(1,3,:))
discrete_sdr_std = squeeze(sdr_mat(2,3,:));

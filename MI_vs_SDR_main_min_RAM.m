% Main File to run MI Methods vs SDR, where derivative needs to be set
% further down.

% This script uses only nested functions when using the input dataset. This
% saves massive amounts of memory.

%% First, copy all except feeder SG data into a new matrix.
% 60 min file has 8770 datapoints
% 15 min file has 35050 datapoints
% Column W corresponds to Node 1, Column KI corresponds to node 272. We
% purposely leave out the feeder node since it's vmag value is not constant. 
data_limits = 'W10..KI525610';
node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Downloads/SG2_data_solar_1min.csv',...
   9,22, data_limits);
% node_volt_matrix = v_vec(:,2:end);
%% Second, copy the list of true branches.
data_limits = 'A1..B271';
true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
    0,0, data_limits);
% true_branch_data = squeeze(mpc_base.branch(2:end,1:2)-1);
%% Remove redundant nodes from the dataset.
% The guts of the following section is derived from
% collapse_redundant_data.m.
number_observations = numel(node_volt_matrix(:,1));
number_identical_nodes = 0;
outer_loop_index = 1;
matrix_of_identical_nodes = zeros(numel(true_branch_data(:,1)), ...
    numel(true_branch_data(1,:)));
tic
while outer_loop_index < numel(node_volt_matrix(1,:))
    % we dont want to evaluate whether one node is the same as another
    % column so we check starting with node i+1
    % re-intialize k
    inner_loop_index = outer_loop_index + 1; 
    while inner_loop_index <= numel(node_volt_matrix(1,:))
        
        % check whether it is the same node
        if (sum(node_volt_matrix(:,outer_loop_index) ...
                == node_volt_matrix(:,inner_loop_index)) ...
                == number_observations)
            
            number_identical_nodes = number_identical_nodes + 1;
            matrix_of_identical_nodes(number_identical_nodes, :) = ...
                [outer_loop_index,inner_loop_index];
            % now let's remove the identical node
            %Node_Volt_Matrix(:,k) = ones(number_observations,1)*k;
            node_volt_matrix(:,inner_loop_index) = [];
           
            for g = 1:numel(true_branch_data(:,1))
                % check if we find the second identical node-k in the row
                for h = 1:numel(true_branch_data(1,:))
                    if true_branch_data(g,h) == inner_loop_index
                        true_branch_data(g,h) = outer_loop_index;
                    elseif true_branch_data(g,h) > inner_loop_index
                        true_branch_data(g,h) = true_branch_data(g,h) -1;
                    end
                end
            end
        %end
        else
        % if a column was not deleted continue iterating. We dont increment
        % iterator if a col was deleted since now col k is a different col
            inner_loop_index = inner_loop_index +1;
        end
    end
    outer_loop_index = outer_loop_index + 1;
end
disp('the number of redundant nodes is')
disp(number_identical_nodes)
disp('time to remove redundant nodes')
toc
%% Remove Redundant Branches.
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 
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

for MI_counter = 1:3
    disp('value of i')
    MI_counter
    if MI_counter == 1
        MI_flag = 'gaussian';
        num_bits = 'no discretization';
    elseif MI_counter == 2
        MI_flag = 'JVHW';
        num_bits = 14;
    else
        MI_flag = 'MLE';
        num_bits = 14;
    end
    

    % Run Chow-Liu, return the sdr and the estimated branch list.
    %% Consider The Derivative of Data.
    %This function is based on consider_derivative.m.
    tic
    node_volt_matrix = node_volt_matrix(2:end,:) ...
        - node_volt_matrix(1:(end-1),:);
    disp('time to take the quasi derivative of the data')
    toc
    % Check if we need to discreteize
    if strcmp(num_bits,'no discretization') ~= 1
        if isinteger(int8(num_bits)) ~= 1
            error('Num Bits (the last arg) is not an integer below 255')
        end
        tic
        global_min = 'local';
        global_max = 'local';
        % Check to see if we should use the local or the global min
        if strcmp(global_min, 'local')
            % Set the global min to the local min.
            global_min = min(min(node_volt_matrix));
        end
        if strcmp(global_max, 'local')
            % Set the global min to the local min.
            global_max = max(max(node_volt_matrix));
        end
        node_volt_matrix = node_volt_matrix - global_min;
        bin_size = (global_max-global_min)/(2^num_bits - 1);
        node_volt_matrix = round(node_volt_matrix./bin_size);
        disp('time to digitize data')
        toc
    end
    
    % If the entropy_flag is the string gaussian in lower case, proceed to
    % model the data as guassian to find the MI.
    if strcmp(MI_flag, 'gaussian')
        
        %% Find the entropy of each node, H(i).
        tic        
        % calculate the number of buses (this is used in the for loop below)
        number_of_buses = numel(node_volt_matrix(1,:));       
        % initialize the entropy vector for which values will be calculated
        single_node_entropy_vec = zeros(1,number_of_buses); % intialize the vector       
        for i_ent=1:number_of_buses
            % Note here we only have one dimension, vmag(i), in our entropy calc.
            single_node_entropy_vec(i_ent) = 1/2 * ...
                (1+log(2*pi)) + 0.5*log(det(cov( ...
                node_volt_matrix(:,i_ent))));
        end
        disp('time required to find entropy')
        toc
        %% Find the joint entropy of pairs of different nodes, H(i,j).
        tic
        number_of_buses = numel(node_volt_matrix(1,:));
        joint_entropy_matrix = zeros(number_of_buses,number_of_buses);      
        for i_joint=2:number_of_buses
            for k_joint=1:(i_joint-1)
                determinant_of_cov_matrix = det(...
                    cov(node_volt_matrix(:,i_joint) , ...
                    node_volt_matrix(:,k_joint)));
                if (determinant_of_cov_matrix <= 0) && ...
                        (determinant_of_cov_matrix >  -0.0001)
                    joint_entropy_matrix(i_joint,k_joint) = -1E3;
                else 
                    joint_entropy_matrix(i_joint,k_joint) = 2/2 ...
                        *(1+log(2*pi))+0.5*log(determinant_of_cov_matrix);
                end
            end
        end
        disp('time required to find joint entropy')
        toc
        %% Find the mutual information of pairs of different nodes, I(i,j).
        tic
        find_mutual_information = @mutual_information;
        mutual_information_matrix = find_mutual_information(...
            single_node_entropy_vec, joint_entropy_matrix);
        disp('time required to find mutual information')
        toc      
    elseif strcmp(MI_flag, 'JVHW')
        %% Find the JVHW MI
        tic        
        number_of_buses = numel(node_volt_matrix(1,:));
        mutual_information_matrix = zeros(number_of_buses,number_of_buses);        
        loop_endpoint = 1;
        MI_JVHW = @est_MI_JVHW;        
        for i_JVHW=1:number_of_buses
            for k_JVHW=1:(i_JVHW-loop_endpoint)
                mutual_information_matrix(i_JVHW,k_JVHW) = ...
                    MI_JVHW(node_volt_matrix(:,i_JVHW),...
                    node_volt_matrix(:,k_JVHW));
            end
        end
        disp('time to find the JVHW MI')
        toc
    elseif strcmp(MI_flag, 'MLE')
        tic
        number_of_buses = numel(node_volt_matrix(1,:));
        MI_MLE = @est_MI_MLE;
        mutual_information_matrix = zeros(number_of_buses,number_of_buses);
        loop_endpoint = 1;  
        for i_MLE=1:number_of_buses
            for k_MLE=1:(i_MLE-loop_endpoint)
                mutual_information_matrix(i_MLE,k_MLE) = ...
                    MI_MLE(node_volt_matrix(:,i_MLE),...
                    node_volt_matrix(:,k_MLE));                
            end
        end      
        disp('Time to find the discrete MLE MI ')
        toc
    else
        error('entropy flag can only be gaussian or JVHW')
    end    
    %% Find Min Span Tree using Kruskal.m
    tic
    find_min_span_tree = @kruskal;
    mat_of_connectivity = find_min_span_tree(mutual_information_matrix)
    disp('time required to run Kruskal')
    toc
    
    %% Find the pairs from the Matrix of Connectivity
    number_of_buses = numel(node_volt_matrix(1,:));
    estimated_node_pairs = zeros(number_of_buses - 1,2);
    p = 0;
    for i_connec = 2:number_of_buses
        for k_connec = 1:i_connec-1
            if (mat_of_connectivity(i_connec,k_connec) ~=0)
                p = p +1;
                estimated_node_pairs(p,:) = [i_connec,k_connec]
            end
        end
    end
    
    %% Find the SDR
    find_sdr = @findSDR;
    [succesful_branch_counter, SDR] = ...
        find_sdr(estimated_node_pairs, true_branch_data);
    sdr_percent = SDR;
    
    % Store sdr.
    sdr_mat(MI_counter) = SDR
    % Store estimtated branches list.
    est_branch_matrices(:,:,MI_counter) = estimated_node_pairs;
    % Store mutual information matrix.
    MI_matrices(:,:,MI_counter) = mutual_information_matrix;
end
%% Calculate Bin Size, before saving. 
global_min = min(min(node_volt_matrix));
global_max = max(max(node_volt_matrix));
%bin_size = (global_max-global_min)/(2^num_bits - 1);
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
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results/SG2-solar-1min-deriv_12_11_min_RAM_corn'...
     ,'results')
% save('results')
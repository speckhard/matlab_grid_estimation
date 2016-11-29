function mutual_information_matrix = find_vmag_MI(node_volt_matrix, ...
    entropy_flag, num_bits)

% This function calculates the MI based on which entropy scheme is selected
% in the entropy flag (discrete, JVHW or gaussian). It also allows one to
% digitize the input node_volt_matrix with a certain num_bits if one
% chooses and to avoid discretization if one chooses no_discretization
% option. 

% This function was created as part of single node SDR experiments 11/27. 

if strcmp(num_bits,'no discretization') ~= 1
    if isinteger(int8(num_bits)) ~= 1
        error('Num Bits (the last arg) is not an integer below 255')
    end
    disp('digitizing input to') 
    disp(num_bits)
    %% Digitize the Input
    digitizer = @digitize_sig; % Import the digitizer
    node_volt_matrix = digitizer(node_volt_matrix, ...
    num_bits, 'local','local');
end
if strcmp(entropy_flag, 'gaussian')
    
    %% Find the entropy of each node, H(i).
    tic
    find_single_node_entropy = @single_node_entropy_vmag_only;
    single_node_entropy_vec = find_single_node_entropy(node_volt_matrix);
    disp('time required to find entropy')
    toc
    %% Find the joint entropy of pairs of different nodes, H(i,j).
    tic
    find_joint_entropy = @joint_entropy_vmag_only_fixed_neglog;
    joint_entropy_matrix = find_joint_entropy(node_volt_matrix);
    size(joint_entropy_matrix)
    toc
    %% Find the mutual information of pairs of different nodes, I(i,j).
    tic
    find_mutual_information = @mutual_information;
    mutual_information_matrix = find_mutual_information(...
        single_node_entropy_vec, joint_entropy_matrix);
    disp('time required to find mutual information')
    toc
    
elseif strcmp(entropy_flag, 'JVHW')
    %% Find the JVHW MI
    tic
    JVHW_MI = @find_JVHW_MI;
    mutual_information_matrix = JVHW_MI(node_volt_matrix, ...
        'no diagonals'); % This last option, ensures diagonal values
    % are not computed.
    disp('time to find the JVHW MI')
    toc 
elseif strcmp(entropy_flag, 'discrete')
    tic
    find_discrete_MI = @MI_vmag_discrete;
    mutual_information_matrix = find_discrete_MI(node_volt_matrix, ...
        num_bits);
    disp('Time to find the discrete MI')
    toc
else
    error('entropy flag can only be gaussian or JVHW')
end
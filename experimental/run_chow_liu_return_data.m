function [sdr_percent, estimated_node_pairs, mutual_information_matrix]...
    = run_chow_liu_return_data(Node_Volt_Matrix,...
    true_branch_pairs, MI_flag, deriv_flag, graph_flag, ...
    MI_heatmap_flag, num_bits)

% This function runs the Chow-Liu algorithm on grid vmag data.

% Inputs: 
% - Node_Volt_Matrix is a matrix of size (num observations, num
% nodes), that contains vmag data at different times (rows) and nodes
% (columns). 
% - true_branch_pairs is a list of branches that are in the correct tree
% graph. 
% - MI_flag determines which method to use, discrete, JVHW or Gaussian, 
% computing the mutual information.
% - deriv_flag takes the derivative of the data before discretizing or 
% running any analysis. 
% - graph_flag determines whether to graph the estimated figure or not 
% once analysis is complete.
% - MI_heatmap_flag determines whether to plot the mutual information
% between nodes heatmap.
% - num bits is the number of bits to which to discretize the data. 


% Ouputs:
% - sdr_percent is the successful detection rate percentage of algorithm. 
% - estimated_node_pairs is the the list of nodes the algorithm estimates
% to be contained in the depenedance tree. 
% - mutual_information_matrix is the matrix of mutual information computed
% between nodes using the method specifid in MI_flag. The matrix is size
% (num nodes, num nodes). 


%% Take the derivative of the data if deriv flag set.
if strcmp(deriv_flag, 'deriv')
    disp('taking deriv of data')
    take_derivative = @consider_derivative;
    Node_Volt_Matrix = take_derivative(Node_Volt_Matrix);
end

%% Digitize the input if num_bits flag set. 
if strcmp(num_bits,'no discretization') ~= 1
    if isinteger(int8(num_bits)) ~= 1
        error('Num Bits (the last arg) is not an integer below 255')
    end
    digitizer = @digitize_sig; % Import the digitizer
    Node_Volt_Matrix = digitizer(Node_Volt_Matrix, ...
    num_bits, 'local','local');
end

% If the entropy_flag is the string gaussian in lower case, proceed to
% model the data as guassian to find the MI.
if strcmp(MI_flag, 'gaussian')
    
    %% Find the entropy of each node, H(i).
    tic
    find_single_node_entropy = @single_node_entropy_vmag_only;
    single_node_entropy_vec = find_single_node_entropy(Node_Volt_Matrix);
    disp('time required to find entropy')
    toc
    %% Find the joint entropy of pairs of different nodes, H(i,j).
    tic
    find_joint_entropy = @joint_entropy_vmag_only_fixed_neglog;
    joint_entropy_matrix = find_joint_entropy(Node_Volt_Matrix);
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
    JVHW_MI = @find_JVHW_MI;
    mutual_information_matrix = JVHW_MI(Node_Volt_Matrix, ...
        'no diagonals'); % This last option, ensures diagonal values
    % are not computed.
    disp('time to find the JVHW MI')
    toc 
elseif strcmp(MI_flag, 'discrete')
    tic
    find_discrete_MI = @MI_vmag_discrete;
    mutual_information_matrix = find_discrete_MI(Node_Volt_Matrix, ...
        num_bits);
    disp('Time to find the discrete MI')
    toc
elseif strcmp(MI_flag, 'MLE')
    tic
    MLE_MI = @find_MLE_MI;
    mutual_information_matrix = MLE_MI(Node_Volt_Matrix, ...
        'no diagonals');
    disp('Time to find the discrete MI ')
    toc
else
    error('entropy flag can only be gaussian or JVHW')
end

%% Find Min Span Tree using Kruskal.m
tic
find_min_span_tree = @kruskal;
mat_of_connectivity = find_min_span_tree(mutual_information_matrix);
disp('time required to run Kruskal')
toc

%% Find the pairs from the Matrix of Connectivity
number_of_buses = numel(Node_Volt_Matrix(1,:));
estimated_node_pairs = zeros(number_of_buses - 1,2);
p = 0;
for i = 2:number_of_buses
    for k = 1:i-1
        if (mat_of_connectivity(i,k) ~=0)
            p = p +1;
            estimated_node_pairs(p,:) = [i,k];
        end
    end
end


%% Find the SDR
find_sdr = @findSDR;
[succesful_branch_counter, SDR] = ...
    find_sdr(estimated_node_pairs, true_branch_pairs);

sdr_percent = SDR;

%% Graph the Tree if graph_flag is set
if strcmp(graph_flag, 'graph')
    
    G = graph(estimated_node_pairs(:,1),estimated_node_pairs(:,2));
    
    % the default nodelables are too small to read in the 123 node grid
    % we erase them and add them again with font size 7.
    % This is a workaround for the lack of nodelabel.fontsize obj property
    % in node graphs in matlab.
    h = plot(G, 'NodeLabel', []);
    
    for i=1:length(h.XData)
        text(h.XData(i),h.YData(i),num2str(i),'fontsize',18);
    end
end
end

    
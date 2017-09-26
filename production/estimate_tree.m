function [sdr_percent, estimated_branches, mutual_information_matrix,...
    leaf_node_sdr]...
    = estimate_tree(node_volt_matrix,...
    true_branches, MI_method, derivative_method, deriv_step_size, ...
    num_bits, sig_digit_flag, sig_digit, graph_flag)

% This function runs the Chow-Liu algorithm using voltage magnitude data.
% The function calculates the mutual information (MI) by approximating the
% data as a Gaussian distribution or discretizing the data and calculating
% the discrete MI or using the JVHW estiamtors. The function returns an
% estimated tree, mutual information values and estimation success metrics.
% The function requires that the true tree structure be fed as input.
%
% sdr_percent, estimated_branches, mutual_information_matrix,...
%    leaf_node_sdr, two_branch_node_SDR, three_branch_node_SDR]...
%    = estimate_tree(node_volt_matrix,...
%    true_branches, MI_method, derivative_method, deriv_step_size, ...
%     num_bits, sig_digit_flag, sig_digit, graph_flag)
%
% Inputs:
% ----- node_volt_matrix: A matrix containing the voltage magnitude data.
% The number of columns should be the number of nodes in the system. The
% number of rows in the matrix corresponds to the number of datapoints
% where the voltage magnitude is measured across all nodes.
%
% ----- true_branches: This is a matrix containing the true branches in
% the system. The number of rows in this matrix corresponds to the number
% of true branches in the system. THe number of columns should be equal to
% two, which is the number of nodes involved in a single branch.
%
% ----- MI_method: This string will determine how the mutual information
% between nodes is approximated. MI_method can take on three possible
% values: 'Gaussian', 'JVHW' and 'Discrete'. If none of these methods is
% chosen the function returns an error.
%
% ----- derivative_method: This string determines how the voltage magnitude
% data will be transformed before the mutual information is calculated. The
% derivative_method can be set to 'deriv' or 'vary_deriv' which will set
% the variable of analysis to be the change in voltage magnitude,
% Delta_Vmag, between data-points. Delta_Vmag will then be used to
% calculate the mutual information (MI) between nodes. When the derivative
% method is equal to 'deriv', Delta_Vmag (the variable used for further
% analysis) is equal to voltage_mangitude(node x, t) -
% voltage_magnitude(node x, t - 1). When the derivative method input is
% set to 'vary_deriv', Delta_Vmag equals voltage_mangitude(node x, t) -
% voltage_magnitude(node x, t - step_size) where 'step-size' refers to the
% integer number of data-points used in the change in voltage mangitude
% calculation. The step_size is set in the deriv_step_size input variable.
% If the derivative method is not set to 'vary_deriv' or 'deriv' the
% voltage magnitude and not the change in voltage magntidue is used for
% MI calculations.
%
% ----- deriv_step_size: This value sets the spacing used for the change
% in voltage magntiude calculation. When both derivative_method is set to
% 'vary_deriv' and the deriv_step_size variable is set to an integer value,
% the change in voltage mantiude is used as the variable for MI calculation
% and tree estiamtion and is caluclated as: Delta_Vmag equals
% voltage_mangitude(node x, t) - voltage_magnitude(node x, t -  step_size).
% If the derivative method is not set to 'deriv' this input will not change
% alter the output. Nofmrally, this input is set to equal 1 which will set
% the change in voltage magnitude to be a difference between a single
% data-point.
%
% ----- num_bits: The data can be discretized into equal spacings before
% analysis. This input variable sets the number of bits used to discretize
% the data in node_volt_matrix. The integer number will set the number of
% bits so that the voltage magnitude data in node_volt_matrix will be
% binned into 2^(num_bits -1) equally spaced bins between the global max
% and min of the data. If num_bits is set to 'no discretiztaion' then the
% data is not discretized.
%
% ----- sig_digit_flag: If this flag is set to 'sig_dig' the data will be
% rounded to the nearest significant digit specified by sig_digit.
%
% ----- sig_digit: This input specifies to what significant digit the data
% should be rounded when the sig_digit_flag is set to 'sig_dig'.
%
% ----- graph_flag: If this flag is equal to the string 'graph', the
% estimated tree will be plotted as a Matlab Graph. For larger node systems
% Matlab does a poor job of plotting.
%
% Ouputs:
% ----- sdr_percent: This value is the successful detection rate percentage
% of the estimation algorithm. It equals the number of correctly identified
% branches divided by the total number of branches.
%
% ----- estimated_branches: This is a matrix size (number of branches x 2)
% where each row is a pair of nodes corresponding to an estimated branch
% from the algorithm output. 
%
% ----- mutual_information_matrix: This is a matrix size (number of nodes x
% number of nodes). The values in the matrix, b(i,j) for instance,
% corresponds to the pair-wise mutual information between nodes i and j
% calculated using the change in voltage magnitude or the
% voltage magnitude (depending on how derivative_method is set). Only the
% lower triangluar portion of the matrix is populated since the matrix is
% symmetric. The self-information, b(i,i), is set equal to 0 (for us this
% value is not useful).
%
% ------ leaf_node_sdr: This is the percentage of branches that contain one
% leaf node that are estimated correctly by the algorithm.


%% Check if the significant digit flag is set.

if strcmp(sig_digit_flag, 'sig_dig')
    disp(['Trimming data to the significant digit -', sig_dig])
    take_sig_dig = @sig_dig;
    node_volt_matrix = take_sig_dig(node_volt_matrix, sig_digit);
end

%% Check if the derivative method is set.
if strcmp(derivative_method, 'deriv')
    disp('Using change in voltage magnitude for MI caclulations.')
    take_derivative = @consider_derivative;
    node_volt_matrix = take_derivative(node_volt_matrix);
elseif strcmp(derivative_method, 'vary_deriv')
    disp(['Using change in voltage magnitude with step size',...
        deriv_step_size])
    take_derivative = @var_deriv;
    node_volt_matrix = take_derivative(node_volt_matrix, deriv_step_size);
end


%% Digitize the input node_volt_matrix if num_bits flag is set.
% If the num_bits flag is set to 'no discretization' then the data is not
% discretized.
if strcmp(num_bits,'no discretization') ~= 1
    if (num_bits ~= int8(num_bits))
        % Too large of discretization is chosen, return an error.
        error('Num Bits (the 3rd last arg) is not an integer below 255')
    end
    digitizer = @digitize_sig; % Import the digitizer function.
    node_volt_matrix = digitizer(node_volt_matrix, ...
        num_bits, 'local','local', 'even_spaced');
end

% If the entropy_flag is the string gaussian in lower case, proceed to
% model the data as guassian to find the MI.
if strcmp(MI_method, 'gaussian')
    % There's an error using the uint16 type matrix to run matlab's cov()
    % function. So let's convert the matrix to a double if it has been
    % discretized to an integer type matrix.
    
    if strcmp(num_bits,'no discretization') ~= 1
        node_volt_matrix = double(node_volt_matrix);
    end
    %% Find the entropy of each node, H(i).
    tic
    find_single_node_entropy = @single_node_entropy_vmag_only;
    single_node_entropy_vec = find_single_node_entropy(node_volt_matrix);
    disp('time required to find entropy')
    toc
    %% Find the joint entropy of pairs of different nodes, H(i,j).
    tic
    find_joint_entropy = @joint_entropy_vmag_only;
    joint_entropy_matrix = find_joint_entropy(node_volt_matrix);
    disp('time required to find joint entropy')
    toc
    %% Find the mutual information of pairs of different nodes, I(i,j).
    tic
    find_mutual_information = @mutual_information;
    mutual_information_matrix = find_mutual_information(...
        single_node_entropy_vec, joint_entropy_matrix);
    disp('time required to find mutual information')
    toc
    
% Check if the MI_method is set to JVHW.
elseif strcmp(MI_method, 'JVHW')
    %% Find the JVHW MI
    tic % For timing performance.
    JVHW_MI = @find_lin_par_JVHW_MI;
    mutual_information_matrix = JVHW_MI(node_volt_matrix);
    toc
    
% Check if the MI_method is set to discrete.
elseif strcmp(MI_method, 'discrete')
    tic
    find_discrete_MI = @MI_vmag_discrete;
    mutual_information_matrix = find_discrete_MI(node_volt_matrix, ...
        num_bits);
    disp('Time to find the discrete MI')
    toc
elseif strcmp(MI_method, 'MLE')
    tic
    MLE_MI = @find_lin_par_MLE_MI;
    mutual_information_matrix = MLE_MI(node_volt_matrix);
    disp('Time to find the discrete MI ')
    toc
else
    error('entropy flag can only be gaussian, JVHW or discrete')
end

%% Find Min Span Tree using Kruskal.m
tic
find_min_span_tree = @kruskal;
mat_of_connectivity = find_min_span_tree(mutual_information_matrix);
disp('time required to find min span tree')
toc

%% Find the estimated branches from the Matrix of Connectivity.
number_of_buses = numel(node_volt_matrix(1,:));
% Initialize a matrix to store estimated branches.
estimated_branches = zeros(number_of_buses - 1,2);
p_counter = 0; % Counter used to keep track of saved branches.
% Recall the mat_of_connectivity is symmetric so we only need to look at
% the lower triangular values (the diagonal values are not usefull since we
% don't connect one node to itself).
for i = 2:number_of_buses
    for k = 1:i-1
        if (mat_of_connectivity(i,k) ~=0)
            p_counter = p_counter +1;
            estimated_branches(p_counter,:) = [i,k];
        end
    end
end

%% Find the successful detection rate (SDR) as a percent.
find_sdr = @find_SDR;
[succesful_branch_counter, SDR] = ...
    find_sdr(estimated_branches, true_branches);
sdr_percent = SDR;

%% Find the x node SDRs
% This function is used to find the number of leaf nodes in the system.
x_SDR = @x_node_SDR; 
% disp('size of mi matrix') % Used for debugging
% disp(size(mutual_information_matrix))
% Find and return the leaf node SDR.
leaf_node_sdr = x_SDR(mutual_information_matrix, true_branches, 1);

%% Graph the Tree if graph_flag is set to 'graph'.
if strcmp(graph_flag, 'graph')
    
    G = graph(estimated_branches(:,1),estimated_branches(:,2));
    
    h = plot(G, 'NodeLabel', []);
    
    % The fontsize should be adjusted here depending on the number of nodes
    % being plotted. The below commands labels the graph.
    for i=1:length(h.XData)
        text(h.XData(i),h.YData(i),num2str(i),'fontsize',18);
    end
end
end


function entropy_vec = gaussian_mix_node_entropy(node_volt_matrix)

% The entorpy of a single node is calculated by approximating the
% distribution of the data a mixture of gaussians. We caclulate the data
% using a zeroth order taylor approx for the mixture. 

% Input: node_volt_matrix: matrix of node/voltage. The rows are the
% observations of voltage magnitude at different times and the columns are
% different nodes. 

% Output: Entropy_vec, a vector that stores the entropy values for each
% node. 

% Number of nodes in the system
num_nodes = node_volt_matrix(:,1);
entropy_vec = zeros(1, num_nodes);

% Let's cycle through each node and find the entropy.
for i = 1:num_nodes
    
    % Fit the data using Matlab's EM algorithm, this algorithm maximized
    % the posterier distribution probability of the data for a mixture of
    % two gaussians, in an iterative approach.
    GMModel = fitgmdist(node_volt_matrix(:,i),2)
    % Extrac the mean's and sigma's (covariance matrices). 
    mu_vec = GMModel.mu;
    % Sigma values are the variances of each independent gaussian. 
    sigma_vec = squeeze(GMModel.Sigma); 
    % The weighting of each gaussian mixture. 
    proportion_vec = GMModel.ComponentProportion
   
    zero_order_entropy = proportion_vec(1)/(sqrt(sigma(1)*2*pi)) +...
        proportion_vec(2)/(sqrt(sigma(2)*2*pi));
    
    entropy_vec(i) = zero_order_entropy;
end

    
    

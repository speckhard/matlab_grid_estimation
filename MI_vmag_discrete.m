function mutual_information_matrix = MI_vmag_discrete(...
    node_volt_matrix, num_bits)

% Function to calculate the MI
% Inputs:
% node volt matrix, data of vmag. Columns represent different nodes, rows
% represent different times of observations.
% num_bits: the number of bits to which the data has been discretized
% Ouputs:
% mutual_information_matrix 
% MI(x,y) = sum p(x,y)*log(p(x,y)/(p(x)*p(y)), note we need to make sure p(x) ~= 0, since
% 0*log(0) returns NaN in Matlab. 

% Max discrete value from num bits
max_discrete_val = 2^(num_bits)-1;
% Support of probability(V(node X)). The number of possible discrete
% outcomes of V(Node(X)). 
possib_num_outcomes = numel(0:max_discrete_val);
% Possible outcomes in a vector
possib_outcomes_vec = 0:max_discrete_val;
% Number of nodes in the input voltage mag matrix Vmag(Node X, Time Y)
num_nodes = numel(node_volt_matrix(1,:));
% Number of observations
num_observations = numel(node_volt_matrix(:,1));

prob_matrix = sparse(possib_num_outcomes, num_nodes);

% Find individual probabilities
% Cycle through the nodes and find the P(Vmag(Node i == Outcome))
for i = 1:num_nodes
    % The possible_outcomes_vec sets the edges, but if we dont add a final
    % edge at the end, we end up binning the last two possible values
    % together into the final bin possible_outcomes_vec -1 <->
    % possible_outcomes_vec.
    prob_matrix(:,i) = histcounts(node_volt_matrix(:,i), ...
        [possib_outcomes_vec (max_discrete_val+1)])/num_observations;
end

mutual_information_matrix = zeros(num_nodes,num_nodes);
% Find the mutual information matrix
for i = 1:num_nodes
    for j =1:(i-1) % Only calculate lower triangular portion.
        % Caclulate the joint pdf of both nodes
        joint_pf = sparse(hist3([node_volt_matrix(:,i),node_volt_matrix(:,j)], ...
            'Edges',{possib_outcomes_vec,possib_outcomes_vec}) ...
            /num_observations);
        % Cycle through possible outcomes, in joint_pf (size possib
        % outcomes x possib outcomes)
        for k = 1:possib_num_outcomes
            for l = 1:possib_num_outcomes
                if joint_pf(k,l) ~= 0  % prob_matrix(k,i) ~= 0) && (prob_matrix(l,j) ~=0)
                    mutual_information_matrix(i,j) = ...
                        mutual_information_matrix(i,j) + joint_pf(k,l)*...
                        log(joint_pf(k,l)/(prob_matrix(k,i)*prob_matrix(l,j)));
                end
            end
        end
    end
end

                

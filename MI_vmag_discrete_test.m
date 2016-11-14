% MI vmag discrete test
num_bits = 2
% Max discrete value from num bits
max_discrete_val = 2^(num_bits)-1;
% Support of probability(V(node X)). The number of possible discrete
% outcomes of V(Node(X)). 
possib_num_outcomes = numel(0:max_discrete_val);
% Possible outcomes in a vector
possib_outcomes_vec = 0:max_discrete_val;
% Number of nodes in the input voltage mag matrix Vmag(Node X, Time Y)
num_nodes = 2;%numel(node_volt_matrix(1,:));

test_matrix = [1 2 ; 2 3 ];

expected_joint_probability_mat = zeros(possib_num_outcomes, ...
    possib_num_outcomes);

joint_pf_12 = [0 0 0 0;0 0 1 0 ; 0 0 0 1; 0 0 0 0]/2;
single_prob_1 = [0 1 1 0]/2;
single_prob_2 = [0 0 1 1]/2;

MI_12 = 1/2*log(1/2/(1/2*1/2))*2
expected_MI_mat = [0 0; MI_12 0];

find_MI = @MI_vmag_discrete;
mutual_information_mat = find_MI(test_matrix,num_bits);

if isequal(mutual_information_mat, expected_MI_mat)
    disp('mutual_information_discrete function is working correctly')
else 
    disp('mutual information function is not working correctly')
end


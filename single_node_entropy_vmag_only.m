% his function computes the entropy vector, h(i), of single nodes
function single_node_entropy_vec = ...
    single_node_entropy_vmag_only(v_matrix)

% this function takes in a 2d matrix of dimenstional array (observation
% number, bus number ). 

% calculate the number of buses (this is used in the for loop below)
number_of_buses = numel(v_matrix(1,:));

% initialize the entropy vector for which values will be calculated
single_node_entropy_vec = zeros(1,number_of_buses); % intialize the vector

for i=1:number_of_buses
    % Note here we only have one dimension, vmag(i), in our entropy calc.
    single_node_entropy_vec(i) = 1/2 * ...
        (1+log(2*pi)) + 0.5*log(det(cov( ... 
        v_matrix(:,i))));
end
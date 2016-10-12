% his function computes the entropy vector, h(i), of single nodes
function single_node_entropy_vec = single_node_entropy(v_clean_matrix)

% this function takes in a 3d matrix of dimenstional array (real/imaginary, 
% bus number, observation number) of size 
% ( 2, number of buses, number of observations).

% calculate the number of buses (this is used in the for loop below)
number_of_buses = numel(v_clean_matrix(1,1,:));
% calculate the number of measurements (this is used in the for loop below)
number_of_observations = numel(v_clean_matrix(:,1,1));

% initialize the entropy vector for which values will be calculated
single_node_entropy_vec = zeros(1,number_of_buses); % intialize the vector

for i=1:number_of_buses
    % note squeeze is required to turn a 3d matrix of size (1,2,8760)
    % like the one we use to calculate the gaussian matrix, into a
    % 2D matrix of size (2,8760) since only 2D matrices can be fed into
    % the matlab function cov()
    single_node_entropy_vec(i) = 2/2 * ...
        (1+2*log(2*pi)) + 0.5*log(det(cov( ... 
        [squeeze(v_clean_matrix(:,1,i)), ... 
        squeeze(v_clean_matrix(:,2,i))])));
end
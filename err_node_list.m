function err_freq_list = err_node_list(num_nodes, incorrect_branch_mat,...
    err_freq_list)

% This function updates a list that tells how many times a node has been
% predicted incorrectly by the grid. 

% Input: num_nodes, is the number of nodes that are estimated in the grid.

% incorrect_branch_mat is the matrix of incorrectly predicted branches by
% the grid estimation algorithm. The matrix is size num of incorrect
% branches x 2. Each row is a incorrectly estimated branch. 

% Input/Output: err_freq_list is the vector where each row corresponds to
% a node in the grid. The value assosciated with each node is the number 
% of times this node has been found incorrect. This is also the output of 
% the function. If one of the branches connected with the node is incorrect
% then we say the node has been predicted incorrectly and assign a score of
% 1 during the function call. If the nodes isn't in the
% incorrect_branch_mat, then we assign a score of zero during the function
% call. 

if isequal(err_freq_list, 'empty')
    disp('here')
    % THis means the err_freq_list has yet to be initialized, let's
    % initalize it. 
    err_freq_list = zeros(num_nodes, 1);
end

% Let's linearize the incorrect branch mat
incorrect_branch_vec = [incorrect_branch_mat(:,1);...
    incorrect_branch_mat(:,2)];

for i = 1:num_nodes
    % Let's check to see if we can find the node in the incorrect
    % branch_vec.
    if (find(incorrect_branch_vec == i) > 0)
        err_freq_list(i) = err_freq_list(i) + 1;
    end
end

end
        
        








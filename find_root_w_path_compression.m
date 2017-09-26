function [root, root_vector] = find_root_w_path_compression(x, root_vector)

% [root, root_vector] = find_root_w_path_compression(x, root_vector)
%
% This function finds the root of node x and returns a new root vector
% which stores the root of each node. The function is recursive in that if
% it doesn't find the root of the node by looking at the parent of the node
% it continues to find the parent of the parent of the node until the root
% is found. 
%
% Input:
% ----- x: This is an integer corresponding to the node label. X is 
% specified since we want to find the root of node x.
% ----- root_vector: This vector keeps track of the root of each 
% node (i.e., the ultimate parent of each node). root_vector(x) is the root
% of node x.
% 
% Ouput:
% ----- root: This is the root of node x. Root is an integer corresponding
% to the node label of the root of node x. 
% ----- root_vector: This is the same vector as the input root_vector 
% except the values have been updated since the root of node x has been
% updated from the function call. 



find_root = @find_root_w_path_compression;

% Check if the node's root is equal to itself. If not let's find the the
% root of the node recursively.
if x ~= root_vector(x)
    [root, root_vector] = ...
        find_root(root_vector(x), root_vector);
    root_vector(x) = root;
end
root_vector = root_vector;
root = root_vector(x);
end

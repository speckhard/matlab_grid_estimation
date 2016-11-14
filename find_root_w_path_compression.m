function [root, root_vector] = find_root_w_path_compression(x, root_vector);

find_root = @find_root_w_path_compression;
% This function finds the root and uses path compression to enhance
% performance.

if x ~= root_vector(x)
    [root, root_vector] = ...
        find_root(root_vector(x), root_vector);
    root_vector(x) = root;
end
root_vector = root_vector;
root = root_vector(x);
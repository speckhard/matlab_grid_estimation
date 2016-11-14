function weighted_matrix_of_connectivity = kruskal(MI_matrix);
% This function performs the Kruskal algorithm
%tic
number_of_buses = numel(MI_matrix(:,1));
number_of_branches = 0; % initialized to zero.
weighted_matrix_of_connectivity = zeros(number_of_buses,number_of_buses);

rank_vector = zeros(number_of_buses, 1);
root_vector = linspace(1,number_of_buses,number_of_buses);

find_root = @find_root_w_path_compression;

% We start off with a zero max MI 
max_MI = 0;
size_of_MI_matrix = size(MI_matrix);

while number_of_branches < (number_of_buses - 1)
    % find the max value in A, M corresponds to the value, I to the indix of
    % MI_matrix(:)
   
    [max_MI,I] = max(MI_matrix(:)); 
    % Now find the actual row and column indices.
    [I_row, I_col] = ind2sub(size_of_MI_matrix, I);
    
    % In case there are several branches of the same weight.
    x= I_row(1);
    y= I_col(1);
    
    % Find the root of vertex (I_row) and vertex (I_col)
    [r, root_vector] = find_root(x, root_vector);
    [s,root_vector] = find_root(y, root_vector);

    
    % Check if roots are the same.
    if r == s;
        
    elseif rank_vector(r) > rank_vector(s)
        root_vector(r) = s;
        weighted_matrix_of_connectivity(x,y) = max_MI;
        weighted_matrix_of_connectivity(y,x) = max_MI;
        number_of_branches = number_of_branches +1;
    elseif rank_vector(s) > rank_vector(r)
        root_vector(r) = s;
        weighted_matrix_of_connectivity(x,y) = max_MI;
        weighted_matrix_of_connectivity(y,x) = max_MI;
        number_of_branches = number_of_branches +1;
    else
        root_vector(r) =s;
        rank_vector(s) = rank_vector(s) +1;
        weighted_matrix_of_connectivity(x,y) = max_MI;
        weighted_matrix_of_connectivity(y,x) = max_MI;
        number_of_branches = number_of_branches +1;
    end
    
    % Set the value of the MI_matrix to a very negative number
    % to avoid testing the same branch again. 
    MI_matrix(x,y) = -10E8;
end

%disp('time required to find min span tree of data')
%toc







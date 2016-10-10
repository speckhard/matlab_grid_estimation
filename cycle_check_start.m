function y = cycle_check_start(x,z,valid_pairs)

% function to find the best starting point for checking if there
% will be a cycle if the connection between x,z is retained

list_of_connections_for_x = []; list_of_connections_for_z = [];

for i = 1:numel(valid_pairs(:,1))  %add one:numel
    if ismember(x, valid_pairs(i,:))
        % if x is a member of the row, append row number
        % to the list of connections
        list_of_connections_for_x = [list_of_connections_for_x, i];
    end
    if ismember(z, valid_pairs(i,:))
        list_of_connections_for_z = [list_of_connections_for_z, i];
    end
end

if list_of_connections_for_x > list_of_connections_for_z
    y = 1;
else
    y =  0;
end

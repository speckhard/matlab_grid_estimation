function y = cycle_check(x,z,start_flag, valid_pairs, excluded_pairs)

% this function checks if a connection between x and z can be made
% without creating a cycle in the undirected dependence tree

% start_flag determines whether we will start at x or z, and follow
% different connections to see if we end up at the potential paring node
% z or x.

if start_flag == 0;
    start_point = x;
    target_point = z;
else
    start_point =z;
    target_point =x;
end

list_of_connections_for_start =[];
start_point
target_point
valid_pairs

for i = 1:numel(valid_pairs(:,1));
    
    if ismember(start_point, valid_pairs(i,:))
        % if x is a member of the row, append row number
        % to the list of connections
        
        % check first that the connection pair is not part of the excluded
        % pairs  TODO: make both these if statements one statement
        %if ~ismember(valid_pairs(i,:),excluded_pairs)
        
        list_of_connections_for_start = [list_of_connections_for_start i];
        
    end
end

if isempty(list_of_connections_for_start)
    y = 0
else
    
for i = numel(list_of_connections_for_start)
    if ismember(target_point, valid_pairs(list_of_connections_for_start(i),:))
        y =  1; % cycle has been detected
        disp('cycle_has_been_detected')
        disp(valid_pairs(list_of_connections_for_start(i),:))
        break
    else
        
        %excluded_pairs = [excluded_pairs; ...
            %valid_pairs(list_of_connections_for_start(i),:)];
        if valid_pairs(list_of_connections_for_start(i),1) == start_point
            
            new_start_point = valid_pairs(list_of_connections_for_start(i),2);
            
        else
            new_start_point = valid_pairs(list_of_connections_for_start(i),1);
        end
        
        valid_pairs(list_of_connections_for_start(i),:) = []; % remove this connection
        %since it has been checked
        if cycle_check(new_start_point, target_point,0, valid_pairs, excluded_pairs) ~= 0
            y = 1;
            break;
        end
        
        
            
        
        % TODO: I should pre-allocate space for excluded pairs to speed up
        % run-time
    end
       y = 0;
end
end

    

    
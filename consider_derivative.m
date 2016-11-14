function Node_Volt_Matrix = consider_derivative(Node_Volt_Matrix);

% This function considerst the derivative of the Node Volt Matrix data, the
% voltage magnitude at different nodes/times data. 
tic
for i = 1:numel(Node_Volt_Matrix(1,:))
    % subtract the data by the previous time measurement
    Node_Volt_Matrix(2:end,i) = Node_Volt_Matrix(2:end,i) ... 
        - Node_Volt_Matrix(1:(end-1),i);
end

% We drop the first row of data in the Node Volt Matrix since it has not
% been subtracted by a previous term and therefore is very different than
% the other terms. 
Node_Volt_Matrix = Node_Volt_Matrix(2:end,:);

disp('time to take the quasi derivative of the data')
toc
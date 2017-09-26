function weighted_matrix_of_connectivity = kruskal(MI_matrix, true_branches, xpos, ypos)

% weighted_matrix_of_connectivity = kruskal(MI_matrix)
% 
% This function performs find the maximum spanning tree based on pair-wise
% mutual information values stored in the input matrix, MI_matrix. The
% function returns a matrix of connectivity, 
% weighted_matrix_of_connectivity. Note the algorithm implemented here uses
% path compression to speed up performance.
%
% Input:
% ----- MI_matrix: This matrix is size (number of nodes x number of nodes).
% The matrix is lower triangular, meaning the diagonal and elements above
% the diagonal are zero since the mutual information between two nodes
% MI(i,j) = MI(j,i) is symmetric and the self-information MI(i,i) is not
% used in the algorithm since we don't connect a node to itself (to avoid
% cycles).
%
% Ouput:
% ----- weighted_matrix_of_connectivity: This is a matrix size (number of
% nodes x number of nodes). If weighted_matrix_of_connectivity(i,j)
% does not equal zero then there the algorithm returns a branch between
% nodes i and j. The value of weighted_matrix_of_connectivity(i,j) is the
% mutual information, MI between i and j.

tic % For timing performance.
% Find the number of buses.
number_of_buses = numel(MI_matrix(:,1));
% Create a variable that keeps track of the number of branches returned by
% the algorithm.
number_of_branches = 0; % initialized to zero.
% Initialize the matrix of connectivity.
weighted_matrix_of_connectivity = zeros(number_of_buses,number_of_buses);
% This keeps track of the rank of a node. This keeps track of many levels
% of parents the node has.
rank_vector = zeros(number_of_buses, 1);
% This root vector keeps track of the root of each node (i.e., the ultimate
% parent of each node). The root_vector(i) is the root of node i. The
% vector is initialized so that each node has itself as its parent.
root_vector = linspace(1,number_of_buses,number_of_buses);
% This function finds the root of a node. In other words, itt finds the 
% ultimate parent of the node. 
find_root = @find_root_w_path_compression;

% We look at the MI_matrix to find the maximum pair-wise mutual
% information. Initially we set the maximum we have found to be equal to
% zero.
max_MI = 0;
size_of_MI_matrix = size(MI_matrix);
t = 1
wrong_branch = 0;
wrong_branch_array = [];
while number_of_branches < (number_of_buses - 1)
    % find the max value in A, M corresponds to the value, I to the index 
    % of MI_matrix(:). 
   
    [max_MI,I] = max(MI_matrix(:)); 
    % Now find the actual row and column indices.
    [I_row, I_col] = ind2sub(size_of_MI_matrix, I);
    %disp(['row: ', num2str(I_row), 'col: ' num2str(I_col),'MI val: ', num2str(MI_matrix(I_row, I_col))]);
    % In case there are several branches of the same weight.
    x= I_row(1);
    y= I_col(1);
    
    % Find the root of vertex (I_row) and vertex (I_col)
    [r, root_vector] = find_root(x, root_vector);
    [s,root_vector] = find_root(y, root_vector);

    % Check if roots are the same.
    if r == s;
        MI_matrix(x,y) = -10E8;
        continue 
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
        root_vector(r) = s;
        rank_vector(s) = rank_vector(s) +1;
        weighted_matrix_of_connectivity(x,y) = max_MI;
        weighted_matrix_of_connectivity(y,x) = max_MI;
        number_of_branches = number_of_branches +1;
    end
    
    % Set the value of the MI_matrix to a very negative number
    % to avoid testing the same branch again. 
    MI_matrix(x,y) = -10E8;
    
    B = graph(weighted_matrix_of_connectivity);
    h = plot(B, 'NodeLabel', [],'XData', xpos, 'YData', ypos, 'Marker', 'o', 'MarkerSize', 9, 'LineWidth',3.0);% 'Layout','force');
    if ((ismember([x,y], ...
            true_branches,'rows')) || (ismember([y,x], true_branches...
            ,'rows')) ) ~= 1
        wrong_branch = wrong_branch + 2;
        wrong_branch_array(wrong_branch-1:wrong_branch) = [x,y];
        highlight(h,wrong_branch_array,'EdgeColor','r','LineWidth',3.5);
    end
    set(gca,'visible','off')
    set(gca,'XtickLabel',[],'YtickLabel',[]);
    for i=1:length(h.XData)
        text(h.XData(i)+0.05,h.YData(i),num2str(i),'fontsize',18);
    end
    %set(gca,'fontsize',14);
%         ylim([-1 1]);
%     xlim([0 2*pi]);
    grid on;
    if t < 30
        savefig(['/Users/Dboy/Documents/Stanny/Rajagopal/github_scripts/gif/MVurban_dsicrete', int2str(t)])
        %print(['/gif/MVurban_dsicrete' + int2str(t)], '-depsc')
        %print('MVurbandiscrete_25', '-depsc')
    end
    % gif utilities
    set(gcf,'color','w'); % set figure background to white
    drawnow;
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    outfile = 'kruskal_mvUrban_discrete2.gif';
 
    % On the first loop, create the file. In subsequent loops, append.
    if t==1
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',inf);
    else
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'writemode','append');
    end
    
    t = t +1;
end

disp('time required to find min span tree of data')
toc
end








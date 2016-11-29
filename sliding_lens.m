function node_volt_matrix_lens = ...
    sliding_lens(node_volt_matrix, lens_length, lens_number)

% In this scheme we move each next lens so it starts at the half-way point
% of the previous lens. 

% The number of lens is thus the number of side-side by lenses that fit
% multiplied by two. Ex. Lens size 2. Dataset size 9. Here 2 side by side
% 4 datasets fit. If we move halfway over each lens, we get 0-2, 1-2, 2-3,
% 3-4, 4-5, 5-6, 6-7, 7-8, 8-9, 9 lens, which is equal to the number of 1
% sized lenses that fit. Same works for lens size 4, 0-4, 2-6, 4-8, 4
% datasets fit as expected for lens size 2, side by side. 

% At the moment only even number lens-lengths work 

% Function will take a lens of the node_volt matrix and will 
node_volt_matrix_lens = node_volt_matrix(lens_number/2*lens_length:...
    lens_number/2*lens_length+lens_length,:);
end

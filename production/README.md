#Rajagopal_Grid_Estimation/production

This sub-directory is meant to contain Matlab scripts to used for researchers interested in estimating grid topologies using mutual information based techniques. This directory is meant to contain programs that have been heavily tested are ready to be shared externally.

Summary of functions:

collapse_redundant_data - collapse nodes that contain data identitical into a single node.

consider_derivative.m - convert voltage magnitude data into the change in voltage magnitude data (relative difference in voltage magnitude from one timepoint to another).

digitize_sig.m - discretize the voltage magnitude signal

estimate_tree.m - returns a estimated tree (branches/nodes) of the grid topology following mutual information techniques described in <http://ieeexplore.ieee.org/abstract/document/7744625/>

estimate_tree_main.m - main file to estimate the grid topology based on voltage magnitude using mutual information based techniques.

find_SDR.m - finds the succesful detection rate (SDR) of the tree estimation.

find_root_w_path_compression.m - finds the root of a node. 

find_x_nodes.m - returns the number of nodes that have a certain number of branches.

joint_entropy_vmag_only.m - finds the joint entropy between paris of nodes.

kruskal.m - implmentation of the Kruskal algorithm (min-span tree).

mutual_information.m - find the mutual information of pairs of nodes.

reflect_lower_triang_mat.m - reflects the lower triangular portion of a matrix over the diagonal.

remove_redundant_branches.m - removes branches to redundant nodes (nodes with idential data).

single_node_entropy_vmag_only.m - find self-information of a single node.

var_deriv.m - returns variable delta voltage magnitude data (variable time differences in |V| data). 

x_node_SDR.m - function to find the succesful detection rate (SDR) for nodes with a certain number of branches.












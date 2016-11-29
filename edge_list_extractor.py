"""
Script to extract the list of node to node edges in a pydot tree. The 
resulting list is saved as a csv file. 
"""

## Author: DTS
## Created: Nov 22, 2016

import networkx as nx # Used to load and process pydot file. 
import numpy as np  # used  for matrices and saving csv file. 

# Load the file as a network x graph. 
G = nx.Graph( nx.drawing.nx_agraph.read_dot('R4-12.47-2.dot'))

# Create a very large number that is larger than the number of edges in the 
# matrix.
large_number_edges = 400; 
# We then initialize a matrix of 2 x large_number_edges so that we can stroe
# the true edges in this matrix, without having to alter its size. We also
# stroe the edge numbers as integer values (int16). 
true_branch_list = np.zeros((380,2),np.int16) 
# We keep track of how many true edges have been stored in the true branch
# list by updated matrix_index. 
matrix_index = 0;
# We loop through the edges in the pydot file. 
for line in nx.generate_edgelist(G,data=False):
    
    # Each line (i.e. edge) containes two nodes. 
    # We split each line into two seperate nodes.
    branch_array = line.split()
    # Check if if both elements in branch array are nodes by ensuring the first
    # char of both values is n.
    if (branch_array[0][0] == 'n') and (branch_array[1][0]=='n'):
        # Find the number of characters in each node name (node127 or node12).
        node0_int_len = len(branch_array[0])
        node1_int_len = len(branch_array[1])
        # Save on ly the numbers of the nodes.
        branch_array_int = [
                            branch_array[0][4:node0_int_len], 
                            branch_array[1][4:node1_int_len]
                            ]
        true_branch_list[matrix_index,:]=branch_array_int
        matrix_index = matrix_index +1 # Update counter for true edges.
        
# Now let's truncate the unused rows of true_branch_list.
# We know only matrix_index rows were used.
true_branch_list = true_branch_list[0:matrix_index,:]

# Now let's save the file.
np.savetxt('True_branch_list.csv',true_branch_list,fmt='%u',delimiter=',')

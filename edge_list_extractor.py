# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

## this script works to extract the list of edges in a graph
## Author: DTS
## Created: Nov 22, 2016

#from graphviz import Source
#import pydotplus
import networkx as nx
import numpy as np

# Load the file as a network x graph. 
G = nx.Graph( nx.drawing.nx_agraph.read_dot('R4-12.47-2.dot'))

# Create a 300x2 zero matrix, we choose 300 since that is much higher than
# the total number of nodes. We are not sure of the size of mat we'll need.
true_branch_list = np.zeros((380,2),np.int16) 
matrix_index = 0;
for line in nx.generate_edgelist(G,data=False):
    
    # line returns as node 127 tm85.
    # We split line into two seperate nodes.
    branch_array = line.split()
    # Check if if both elements in branch array are nodes.
    if (branch_array[0][0] == 'n') and (branch_array[1][0]=='n'):
        node0_int_len = len(branch_array[0])
        node1_int_len = len(branch_array[1])
        branch_array_int = [branch_array[0][4:node0_int_len], branch_array[1][4:node1_int_len]]
        true_branch_list[matrix_index,:]=branch_array_int
        matrix_index = matrix_index +1
        
# Now let's truncate the unused rows of true_branch_list.
# We know only matrix_index rows were used.
#true_branch_list = true_branch_list[0:matrix_index,:]

# Now let's save the file
np.savetxt('True_branch_list.csv',true_branch_list,fmt='%u',delimiter=',')

# Rajagopal_Grid_Estimation
Scripts to evaluate different algorithms for grid estimation

The following scripts are to reproduce results from the Chow-Liu algorithm in the NAPS paper by Yizheng and Dr. Weng

mutual_information_compututation_10_7_16
This script is the main script to compute the graph of the estimated grid topology

cycle_check_start.m
This script determines which node out of a potential branch that we should begin searching for a cycle if this branch is created

cycle_check.m
This script checks to see if adding a branch will create a cycle in our graph. 

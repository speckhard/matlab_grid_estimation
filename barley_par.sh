

#!/bin/bash

#$ -N matlab_par_JVHW_lin_parfor_v6
#$ -cwd
#$ -M dts@stanford.edu
#$ -m besa
#$ -j yes
#$ -pe shm 8

module load matlab
matlab -nodesktop -r 'maxNumCompThreads' </afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Matlab_Code/Rajagopal_Grid_Estimation/parallel_JVHW_test.m
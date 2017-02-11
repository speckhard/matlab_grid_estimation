

#!/bin/bash

#$ -N matlab_par_num_bits_lens_MI_G_only_SG2_021017_v1
#$ -cwd
#$ -M dts@stanford.edu
#$ -m besa
#$ -j yes
#$ -pe shm 8
#$ -l mem_free=9.2G

module load matlab
matlab -nodesktop -r 'maxNumCompThreads' </afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Matlab_Code/Rajagopal_Grid_Estimation/num_bits_main.m
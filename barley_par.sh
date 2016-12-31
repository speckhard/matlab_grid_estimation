

#!/bin/bash

#$ -N matlab_par_noise_SG1_test3
#$ -cwd
#$ -M dts@stanford.edu
#$ -m besa
#$ -j yes
#$ -pe shm 8
#$ -l mem_free=4.2G

module load matlab
matlab -nodesktop -r 'maxNumCompThreads' </afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Matlab_Code/Rajagopal_Grid_Estimation/noise_vs_SDR.m
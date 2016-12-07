

#!/bin/bash

#$ -N matlab_example
#$ -m bes
#$ -M chekh@stanford.edu

module load matlab
matlab -nodesktop -singleCompThread < /farmshare/software/examples/matlab/helloworld.m

disp('hello world')
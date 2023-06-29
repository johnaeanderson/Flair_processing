#!/bin/bash

# Define directories
SCRIPTS_DIR="scripts"
ORIGINAL_DATA_DIR="original_data"
OUTPUTS_DIR="outputs"



# Run MATLAB PLES estimation
/Applications/MATLAB_R2021b.app/bin/matlab -nojvm -nosplash -batch "run('${SCRIPTS_DIR}/batch_ples.m')"


#!/bin/bash

i=$1

# Define directories
SCRIPTS_DIR="scripts"
ORIGINAL_DATA_DIR="original_data"
OUTPUTS_DIR="outputs"



#now use a nonlinear transform (fnirt) to warp the T1 to the MNI space
fnirt --ref=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz --in= ${OUTPUTS_DIR}/${i}_ses-1_T1w_ror_restore_bet.nii.gz --aff= ${OUTPUTS_DIR}/${i}_T1_MNI_Affine.mat  --config=T1_2_MNI152_2mm --cout= ${OUTPUTS_DIR}/${i}_T1_MNI_Nonlin --iout= ${OUTPUTS_DIR}/${i}_T1_in_MNI_space


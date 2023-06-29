#!/bin/bash

i=$1

# Define directories
SCRIPTS_DIR="scripts"
ORIGINAL_DATA_DIR="original_data"
OUTPUTS_DIR="outputs"

# reorient the images to the standard (MNI) orientation [fslreorient2std]
# first the FLAIR image
fslreorient2std ${ORIGINAL_DATA_DIR}/${i}_FLAIR.nii ${OUTPUTS_DIR}/${i}_ses-1_FLAIR_ro.nii  

# now the T1 image
fslreorient2std ${ORIGINAL_DATA_DIR}/${i}_MPRAGE1_filled_lpa_mr${i}_Flair_aligned.nii ${OUTPUTS_DIR}/${i}_ses-1_T1w_ro.nii 

# automatically crop the image [robustfov]
# first the FLAIR image
robustfov -i ${OUTPUTS_DIR}/${i}_ses-1_FLAIR_ro.nii -r ${OUTPUTS_DIR}/${i}_ses-1_FLAIR_ror.nii 

# now the T1 image
robustfov -i ${OUTPUTS_DIR}/${i}_ses-1_T1w_ro.nii -r ${OUTPUTS_DIR}/${i}_ses-1_T1w_ror.nii 

# bias-field correction (RF/B1-inhomogeneity-correction) [FAST]
# first the FLAIR image
fast -t 3 -n 3 -H 0.1 -I 4 -l 20.0 --nopve -B -o ${OUTPUTS_DIR}/${i}_ses-1_FLAIR_ror ${OUTPUTS_DIR}/${i}_ses-1_FLAIR_ror 

# now the T1 image
fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 --nopve -B -o ${OUTPUTS_DIR}/${i}_ses-1_T1w_ror.nii ${OUTPUTS_DIR}/${i}_ses-1_T1w_ror.nii 

# remove all files *except* for the restored files
gunzip ${OUTPUTS_DIR}/*_ror_restore.nii.gz 

# brain extraction using BET
# FLAIR Image 
hd-bet -i ${OUTPUTS_DIR}/${i}_ses-1_FLAIR_ror_restore.nii -device cpu -mode fast -tta 0 

# T1 weighted image
hd-bet -i ${OUTPUTS_DIR}/${i}_ses-1_T1w_ror_restore.nii -device cpu -mode fast -tta 0 

# Call Matlab and the LST toolbox
# Registration to standard space (linear and non-linear) [FLIRT and FNIRT]
# First register the FLAIR to the T1 (FLIRT)

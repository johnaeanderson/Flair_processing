#!/bin/bash

set -e

i=$1

# Define directories
OUTPUTS_DIR="outputs"

# Function to remove .nii duplicates of .nii.gz files
remove_nii_duplicates() {
  dir_path=$1
  for file in "$dir_path"/*.nii.gz; do
    nii_file="${file%.*}"
    if [ -e "$nii_file" ]; then
      echo "Removing file $nii_file"
      rm "$nii_file"
    fi
  done
}

# Remove .nii duplicates in OUTPUTS_DIR
remove_nii_duplicates $OUTPUTS_DIR

# Now align the T1 to the MNI_152_2mm_brain image using an affine transform
flirt -in ${OUTPUTS_DIR}/${i}_ses-1_T1w_ror_restore_bet.nii.gz -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz -out ${OUTPUTS_DIR}/${i}_T1_MNI_Affine.nii.gz -omat ${OUTPUTS_DIR}/${i}_T1_MNI_Affine.mat

# Now use a nonlinear transform (fnirt) to warp the T1 to the MNI space
fnirt --ref=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz --in=${OUTPUTS_DIR}/${i}_ses-1_T1w_ror_restore_bet.nii.gz --aff=${OUTPUTS_DIR}/${i}_T1_MNI_Affine.mat  --config=T1_2_MNI152_2mm --cout=${OUTPUTS_DIR}/${i}_T1_MNI_Nonlin --iout=${OUTPUTS_DIR}/${i}_T1_in_MNI_space

# Now flirt the FLAIR image to the anatomical image using boundary based registration (BBR)
epi_reg --epi=${OUTPUTS_DIR}/${i}_ses-1_FLAIR_ror_restore_bet.nii.gz --t1=${OUTPUTS_DIR}/${i}_ses-1_T1w_ror_restore.nii.gz --t1brain=${OUTPUTS_DIR}/${i}_ses-1_T1w_ror_restore_bet.nii.gz --out=${OUTPUTS_DIR}/${i}_FLAIR_to_T1 -v

# Now concatenate the transforms
convertwarp --ref=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz --warp1=${OUTPUTS_DIR}/${i}_T1_MNI_Nonlin.nii.gz --premat=${OUTPUTS_DIR}/${i}_FLAIR_to_T1.mat  --out=${OUTPUTS_DIR}/${i}_my_comprehensive_warps --relout

# Apply the transforms to the relevant data
applywarp --ref=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz --in=${OUTPUTS_DIR}/ples_lpa_m${i}_ses-1_FLAIR_ror_restore.nii --warp=${OUTPUTS_DIR}/${i}_my_comprehensive_warps --rel  --out=${OUTPUTS_DIR}/ples_lpa_m${i}_ses-1_FLAIR_ror_restore_in_MNI_space.nii

# Makefile

#.PHONY: all script1 script2 script3 script4 clean

all: script1 script2 script3 script4 clean

# Define directories
SCRIPTS_DIR := scripts
ORIGINAL_DATA_DIR := original_data
OUTPUTS_DIR := outputs

# Adjust the parallel calls to include directories. The shell scripts should 
# also be modified to output their results in the 'outputs' directory.
script1:
	cat $(ORIGINAL_DATA_DIR)/subs.txt | parallel -j 8 ./$(SCRIPTS_DIR)/image_processing_01_preprocessing.sh {}

script2: script1
	./$(SCRIPTS_DIR)/image_processing_02_matlab_ples.sh

script3: script2
	cat $(ORIGINAL_DATA_DIR)/subs.txt | parallel -j 8 ./$(SCRIPTS_DIR)/image_processing_03_alignment.sh {}

script4: script3
	python $(SCRIPTS_DIR)/html_parser.py

# The clean command should be modified to only clean files in the 'outputs' directory.
clean:
	find $(OUTPUTS_DIR) -type f ! -name '*_in_MNI_space.nii.gz' ! -name '*.html' ! -name '*.sh' ! -name '*.m' ! -name '*.py' ! -name 'Makefile' ! -name 'subs.txt' ! -name 'summary.csv' -delete

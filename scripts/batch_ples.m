% batch_ples.m

	addpath('/Users/johnanderson/Documents/MATLAB/spm12');
	addpath('/Users/johnanderson/Documents/MATLAB/spm12/toolbox/LST');

	% Define the directory where the files are stored
	directory = '/Users/johnanderson/Downloads/FLAIR_York_Sample/make_example/outputs';

	% Find files that match the specified pattern
	files = dir(fullfile(directory, '*_ses-1_FLAIR_ror_restore.nii'));

	% Initialize an empty cell array
	fileList = cell(1, length(files));

	% Loop through the struct array of files and save the full file paths to the cell array
	for i = 1:length(files)
	    fileList{i} = fullfile(directory, files(i).name);
	end

	% Now, loop over the file list, and pass each file to ps_LST_lpa function
	for i = 1:length(fileList)
	    output{i} = ps_LST_lpa(fileList{i});
	end

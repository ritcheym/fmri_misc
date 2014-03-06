Functions
--------------
### SPM-specific
* **batch_template.m:** This script is an example of how to set up a batch script for running SPM8 routines across multiple subjects. More extensive documentation [here](http://hippocampish.wordpress.com/2013/03/19/setting-up-a-subject-batch-script-with-spm8/).
* **save_spm_slices.m:** This script saves an image file depicting whole-brain slices with a thresholded overlay corresponding to the currently-loaded results contrast.
* **save_spm_table.m:** This script saves a tab-delimited text file listing cluster and peak information for the currently-loaded results contrast.

### Other
* **adjmat2gml.m:** This function generates a GML file from a weighted adjacency matrix, for network visualization in Gephi.
* **cell2csv.m:** A slightly modified version of [cell2csv](http://www.mathworks.com/matlabcentral/fileexchange/4400-cell-array-to-csv-file-cell2csv-m) from the Matlab File Exchange.

Dependencies
--------------
* SPM8, download from http://www.fil.ion.ucl.ac.uk/spm/software/spm8/

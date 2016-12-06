Functions
--------------
### SPM scripts
* `batch_system`: See the [README](batch_system) for guidelines on how to effectively set up an SPM batch system.
* `generate_spm_singletrial.m`: This script uses existing SPM model files to generate single-trial models, which are useful for functional connectivity or pattern similarity analyses. I haven't updated this script in awhile but there's a [newer version](https://github.com/tsalo/misc-fmri-code) floating around.
* `define_contrasts.m`: Function for generating contrast vectors based on regressor names in an SPM.mat file
* `save_spm_all.m`: Simple tool for saving out SPM results, including a results table, slice overlay image, and thresholded nii

Dependencies
--------------
* SPM8 or SPM12 - download [here](http://www.fil.ion.ucl.ac.uk/spm/software/spm/)

Guide to setting up a subject batch system with SPM
----
### Introduction

This is a brief tutorial on how to set up a batch script to interface with the SPM batch job system.

This content was previously published [here](https://hippocampish.wordpress.com/2013/03/19/setting-up-a-subject-batch-script-with-spm8/#more-13), but it has been considerably updated since then. The example scripts were generated with SPM12. I've used the same type of system with SPM8 and even EEGLAB, so the general principles can be applied in a variety of ways. Please let me know if you have comments or suggestions.

The SPM batch job system is designed to simplify the creation of pre-processing and analysis pipelines for fMRI data. It does not, however, include a good system for running the same pipeline across a group of subjects. The ability to batch across subjects is important because we often want to run the same pre-processing stream, for example, across 20 or more subjects, and manually updating the batch job for each subject would be tedious and prone to error. This is exactly the type of situation where Matlab (or any programming language) comes in handy.

### File overview

The scripts in this folder provide an example of a batch system designed to play nicely with the SPM batch. There are 4 example scripts:

- `batch_preproc.m`: The primary control script that calls the other functions
- `initialize_vars.m`: A function that defines all of the subject-specific paths and variables
- `job_realign.m` and `job_segment.m`: These functions contain (generalized) output from the SPM batch editor. `job_realign` runs through realignment for two runs of functional data, and `job_segment` runs segmentation on a T1 image. These functions are just intended to give you an idea of how the scripts work together, and they are meant to be replaced with the batch job output for your own project.

### How to adapt the scripts for your own project

- Use the Batch Editor included in SPM to set up your pipeline for a single subject. There’s documentation on how to use the Batch Editor in the SPM [manual](http://www.fil.ion.ucl.ac.uk/spm/doc/) and [here](http://ccpweb.wustl.edu/pdfs/spm8processingman.pdf).
- Save the SPM batch job as a .m file, e.g., `job_realign.m`. This will allow you to easily edit the .m file for use in the next step.
- Set up your control script, e.g., `batch_preproc.m`.
  - This script should contain a loop that iterates across all of your subjects, running the SPM jobs for each subject
  - At a minimum, this script should call the initialization function and the job functions that you've saved out from SPM. I have it configured to be able to run multiple job functions in sequence.
- Set up the initialization function, e.g., `initialize_vars.m`
  - This function should specify the directories that contain all necessary data files.
  - It should specify naming conventions for functional and anatomical subfolders.
  - It should also specify exceptions to the naming conventions in a subfunction called `run_exceptions`.
  - Note that once you've set up this script once, you should be able to use it for any new batch scripts. This way, if you need to make any changes to the paths, etc, you can do it just once.
- Generalize the SPM job functions.
  - You're going to start from the saved batch job function, e.g., `job_realign.m`.
  - Replace file directories, etc, with variables that will be passed by the control script. For simplicity, all variables that will be passed to the job functions can be packaged into a data structure (`b`).
  - Add the necessary syntax at top to turn this script into a function, e.g., `function [matlabbatch] = job_realign(b)`.
- Finally, add the code to actually run the job to the end of the function (see example script).

Basically, the idea is that you want to run your SPM batch job for each individual subject. The job stays the same- the only thing that (usually) changes is where the files are stored. By replacing the file locations written into the SPM job with Matlab variables, we can update that information for each subject by using a for-loop. On each iteration of the for-loop, we pass subject-specific information about file locations, etc, to the job function, which then creates and runs an SPM job that is tailored to that specific subject.

### Tips for an efficient batch system

- Use the file selector tool in the SPM Batch Editor whenever possible. It will usually simplify the process of generalizing your batch job, especially if you put all of the file selectors at the beginning of your pipeline.
- Likewise, take advantage of the ability to embed dependencies within the SPM batch job. In the example below, the 4 different pre-processing steps are serially dependent, meaning that I only ever have to modify the initial file selector variables.
- In the control script (`batch_preproc`), if you call your SPM functions within a try-catch command, then the script won’t entirely crash out if just one of your subjects has a bug (e.g., misnamed data folder). Use in combination with an error log to alert you to any errors that happened along the way (see example script).
- I generally store all 'stable' variables in the initialize_vars script (e.g., the paths to the data files), and more job-specific variables in the batch_job function (e.g., the path to a job-specific analysis folder).
- Make sure to save out information about what you’ve done. The batch wrapper script here saves the SPM job (matlabbatch variable) to the subject’s data directory. It also changes directories on each iteration so that SPM’s .ps output winds up in the right subject’s folder (assuming graphics are being displayed, see advice [here](https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;69498df5.1501)).
- Although this example is configured for basic pre-processing jobs, once you have the script set up, you’ll find that it’s very easy to sub in different batch_job sub-functions for other purposes– e.g., running first-level models, using imcalc to create masks, etc. You can add variables to the `b` structure as you go.

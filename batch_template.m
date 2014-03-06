function [] = batch_template()

% This function is an example of how to set up a batch script for running
% SPM8 routines across multiple subjects. It loops across subjects, 
% defining subject-specific variables (according to default variables + 
% subject-specific exceptions). These variables are then substituted into a
% subfunction containing the output from the SPM8 batch editor. In this 
% way, the script is very flexible- any routine from the SPM8 batch system 
% can be generalized to fit into this framework. The below batch_job
% subfunction is a basic fMRI pre-processing routine.
%
% Author: Maureen Ritchey, updated 03/2013

clear all;
curdir = pwd;

%Specify variables
outLabel = 'batch_pp'; %output label
subjects = {'s01' 's02'};
dataDir = '/fMRI/Projects/Example/Data/';
runs = {'epi_0001' 'epi_0002'};
anatDir = 'mprage';

for i=1:length(subjects)
    %Define variables for individual subjects
    b.curSubj = subjects{i};
    b.dataDir = strcat(dataDir,b.curSubj,'/');
    b.runs = runs;
    b.anatDir = anatDir;
    
    %Run exceptions for subject-specific naming conventions
    b = run_exceptions(b);
    
    %specify matlabbatch variable with subject-specific inputs
    matlabbatch = batch_job(b);
    
    %save matlabbatch variable for posterity
    outName = strcat(b.dataDir,outLabel,'_',date);
    save(outName, 'matlabbatch');
    
    %run matlabbatch job
    cd(b.dataDir);
    try
        spm_jobman('initcfg')
        spm('defaults', 'FMRI');
        spm_jobman('serial', matlabbatch);
    catch
        cd(curdir);
        continue;
    end
    cd(curdir);
    
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [b] = run_exceptions(b)

if strcmp(b.curSubj,'s02')
    b.runs = {'epi_0002' 'epi_0003'};
end

end


function [matlabbatch]=batch_job(b)
%This function generates the matlabbatch variable: can be copied in
%directly from the batch job output, then modify lines as necessary to
%generalize the paths, etc, using b variables

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_fplist.dir = {[b.dataDir b.anatDir '/']}; %modified for batch
matlabbatch{1}.cfg_basicio.file_fplist.filter = '^s';
matlabbatch{1}.cfg_basicio.file_fplist.rec = 'FPList';
matlabbatch{2}.cfg_basicio.file_fplist.dir = {[b.dataDir b.runs{1} '/']}; %modified for batch
matlabbatch{2}.cfg_basicio.file_fplist.filter = '^f';
matlabbatch{2}.cfg_basicio.file_fplist.rec = 'FPList';
matlabbatch{3}.cfg_basicio.file_fplist.dir = {[b.dataDir b.runs{2} '/']}; %modified for batch
matlabbatch{3}.cfg_basicio.file_fplist.filter = '^f';
matlabbatch{3}.cfg_basicio.file_fplist.rec = 'FPList';
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep;
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1).tname = 'Session';
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(1).name = 'class';
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(1).value = 'cfg_files';
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1).sname = 'File Selector (Batch Mode): Selected Files (^f)';
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1});
matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1).src_output = substruct('.','files');
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1) = cfg_dep;
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1).tname = 'Session';
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1).tgt_spec{1}(1).name = 'class';
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1).tgt_spec{1}(1).value = 'cfg_files';
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1).sname = 'File Selector (Batch Mode): Selected Files (^f)';
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1});
matlabbatch{4}.spm.spatial.realign.estwrite.data{2}(1).src_output = substruct('.','files');
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.which = [0 1];
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{4}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep;
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1).tname = 'Reference Image';
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(1).value = 'image';
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1).src_output = substruct('.','rmean');
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1) = cfg_dep;
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tname = 'Source Image';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(1).name = 'class';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(1).value = 'cfg_files';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).sname = 'File Selector (Batch Mode): Selected Files (^s)';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).src_output = substruct('.','files');
matlabbatch{5}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.interp = 1;
matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1) = cfg_dep;
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1).tname = 'Source Image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.source(1).src_output = substruct('.','rmean');
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1) = cfg_dep;
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1).tname = 'Images to Write';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1).sname = 'Realign: Estimate & Reslice: Realigned Images (Sess 1)';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(1).src_output = substruct('.','sess', '()',{1}, '.','cfiles');
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2) = cfg_dep;
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2).tname = 'Images to Write';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2).sname = 'Realign: Estimate & Reslice: Realigned Images (Sess 2)';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(2).src_output = substruct('.','sess', '()',{2}, '.','cfiles');
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3) = cfg_dep;
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3).tname = 'Images to Write';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(3).src_output = substruct('.','rmean');
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4) = cfg_dep;
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4).tname = 'Images to Write';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4).sname = 'Coregister: Estimate & Reslice: Coregistered Images';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(4).src_output = substruct('.','cfiles');
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5) = cfg_dep;
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5).tname = 'Images to Write';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5).sname = 'Coregister: Estimate & Reslice: Resliced Images';
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.normalise.estwrite.subj.resample(5).src_output = substruct('.','rfiles');
matlabbatch{6}.spm.spatial.normalise.estwrite.eoptions.template = {'/fMRI/spm8/templates/EPI.nii,1'};
matlabbatch{6}.spm.spatial.normalise.estwrite.eoptions.weight = '';
matlabbatch{6}.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;
matlabbatch{6}.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
matlabbatch{6}.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';
matlabbatch{6}.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;
matlabbatch{6}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
matlabbatch{6}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
matlabbatch{6}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
matlabbatch{6}.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -50
                                                             78 76 85];
matlabbatch{6}.spm.spatial.normalise.estwrite.roptions.vox = [2 2 2];
matlabbatch{6}.spm.spatial.normalise.estwrite.roptions.interp = 1;
matlabbatch{6}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{6}.spm.spatial.normalise.estwrite.roptions.prefix = 'w';
matlabbatch{7}.spm.spatial.smooth.data(1) = cfg_dep;
matlabbatch{7}.spm.spatial.smooth.data(1).tname = 'Images to Smooth';
matlabbatch{7}.spm.spatial.smooth.data(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{7}.spm.spatial.smooth.data(1).tgt_spec{1}(1).value = 'image';
matlabbatch{7}.spm.spatial.smooth.data(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{7}.spm.spatial.smooth.data(1).tgt_spec{1}(2).value = 'e';
matlabbatch{7}.spm.spatial.smooth.data(1).sname = 'Normalise: Estimate & Write: Normalised Images (Subj 1)';
matlabbatch{7}.spm.spatial.smooth.data(1).src_exbranch = substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.spm.spatial.smooth.data(1).src_output = substruct('()',{1}, '.','files');
matlabbatch{7}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{7}.spm.spatial.smooth.dtype = 0;
matlabbatch{7}.spm.spatial.smooth.im = 0;
matlabbatch{7}.spm.spatial.smooth.prefix = 's';


end


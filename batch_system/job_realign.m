function [matlabbatch] = job_realign(b)

matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {[b.dataDir b.funcRuns{1}]};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^f';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {[b.dataDir b.funcRuns{2}]};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^f';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{3}.spm.spatial.realign.estimate.data{1}(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^f)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.spm.spatial.realign.estimate.data{2}(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^f)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
matlabbatch{3}.spm.spatial.realign.estimate.eoptions.sep = 4;
matlabbatch{3}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
matlabbatch{3}.spm.spatial.realign.estimate.eoptions.rtm = 1;
matlabbatch{3}.spm.spatial.realign.estimate.eoptions.interp = 2;
matlabbatch{3}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
matlabbatch{3}.spm.spatial.realign.estimate.eoptions.weight = '';
matlabbatch{4}.spm.spatial.realign.write.data(1) = cfg_dep('Realign: Estimate: Realigned Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','cfiles'));
matlabbatch{4}.spm.spatial.realign.write.data(2) = cfg_dep('Realign: Estimate: Realigned Images (Sess 2)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','cfiles'));
matlabbatch{4}.spm.spatial.realign.write.roptions.which = [0 1];
matlabbatch{4}.spm.spatial.realign.write.roptions.interp = 4;
matlabbatch{4}.spm.spatial.realign.write.roptions.wrap = [0 0 0];
matlabbatch{4}.spm.spatial.realign.write.roptions.mask = 1;
matlabbatch{4}.spm.spatial.realign.write.roptions.prefix = 'r';

spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);

end
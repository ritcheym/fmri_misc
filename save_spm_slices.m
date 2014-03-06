% This script saves a png file showing the image overlay for whatever SPM 
% results file is currently loaded.
% The output filename is automatically generated to include information 
% about the current contrast and threshold. Tested with SPM8.
%
% USAGE: call directly from command line while SPM results are loaded
%
% Author: Maureen Ritchey, 05-2012, updated 03-2014

% update with your SPM8 directory
spmdir = '/path/to/spm8/';

% specify a label to be tacked on to the end of filename
% label = inputdlg('Label for table:');

% draw the overlay image
image = slover([spmdir 'canonical/single_subj_T1.nii']);
image = add_spm(image);
image.slices = [-48:4:84]; % these slices work for the above T1; otherwise adjust
paint(image)

% clean up filename information
idinfo = strcat(xSPM.title,'_',xSPM.thresDesc);
idinfo = strrep(idinfo,' ','_');
idinfo = strrep(idinfo,'.','-');
idinfo = strrep(idinfo,'(','');
idinfo = strrep(idinfo,')','');

filename = [xSPM.title '_' xSPM.STAT '_' xSPM.thresDesc '_k' num2str(xSPM.k)];
% filename = [xSPM.title '_' xSPM.STAT '_' xSPM.thresDesc '_k' num2str(xSPM.k) '_' label{1}];

% clean up filename
filename = strrep(filename,' ','_');
filename = strrep(filename,'0.','0-');
removechars = {'.nii' '.img' '.' ',' '(' ')' '[' ']' '<' '/' ':'};
for i=1:length(removechars)
    filename = strrep(filename,removechars{i},'');
end

% print image to file
style = hgexport('factorystyle');
style.Background = 'black';
style.Format = 'png';
hgexport(gcf, [filename '_slices.png'], style);
% This script generates an SPM table for whatever SPM results file is 
% currently loaded.
% The output filename is automatically generated to include information 
% about the current contrast and threshold. Tested with SPM8.
%
% USAGE: call directly from command line while SPM results are loaded
%
% Author: Maureen Ritchey, 05-2012, updated 03-2014

% specify a label to be tacked on to the end of filename
% label = inputdlg('Label for table:');

% generate SPM table
TabDat = spm_list('List',xSPM,hReg);

% get the table information and clean up
d   = [TabDat.hdr;TabDat.dat];
xyz = d(4:end,end);
xyz2 = num2cell([xyz{:}]');
d(4:end,end:end+2) = xyz2;
d(3,:)=[];

% generate filename
filepath = xSPM.swd;
filename = [xSPM.title '_' xSPM.STAT '_' xSPM.thresDesc '_k' num2str(xSPM.k)];
% filename = [xSPM.title '_' xSPM.STAT '_' xSPM.thresDesc '_k' num2str(xSPM.k) '_' label{1}];

% clean up filename
filename = strrep(filename,' ','_');
filename = strrep(filename,'0.','0-');
removechars = {'.nii' '.img' '.' ',' '(' ')' '[' ']' '<' '/' ':'};
for i=1:length(removechars)
    filename = strrep(filename,removechars{i},'');
end

% cell2csv from matlab file exchange
cell2csv([filepath '/' filename '.txt'], d, '\t')
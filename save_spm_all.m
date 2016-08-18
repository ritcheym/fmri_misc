% This script saves: 1) a png file showing the image overlay for whatever SPM
% results file is currently loaded, 2) the corresponding peak table, and 3)
% the thresholded SPM image.
% The output filename is automatically generated to include information
% about the current contrast and threshold. Tested with SPM8.
%
% USAGE: call directly from command line while SPM results are loaded
%
% Requires: 
%   - SPM8
%   - cell2csv: https://www.mathworks.com/matlabcentral/fileexchange/47055-cell-array-to-csv-file--improved-cell2csv-m-
%
% Author: Maureen Ritchey, original code: 05-2012, updated 03-2014; merged
% into a single script 01-2015

% update with your SPM directory
spmdir = [fileparts(which('spm')) filesep];
emptyflag = 0; % flag for noting if results are empty

% generate filename
filepath = xSPM.swd;
filename = [xSPM.title '_' xSPM.STAT '_' xSPM.thresDesc '_k' num2str(xSPM.k)];

% clean up filename
filename = strrep(filename,' ','_');
filename = strrep(filename,'0.','0-');
removechars = {'.nii' '.img' '.' ',' '(' ')' '[' ']' '<' '/' ':'};
for i=1:length(removechars)
    filename = strrep(filename,removechars{i},'');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate SPM table
TabDat = spm_list('List',xSPM,hReg);

% get the table information and clean up
d   = [TabDat.hdr;TabDat.dat];
xyz = d(4:end,end);
xyz2 = num2cell([xyz{:}]');

% check whether there are clusters and if so, write out the results
if isempty(xyz2)
    cell2csv([filepath '/' filename '_EMPTY.txt'],d,'\t');
    emptyflag = 1;
    
else
    d(4:end,end:end+2) = xyz2;
    d(3,:)=[];
    
    % cell2csv from matlab file exchange
    cell2csv([filepath '/' filename '.txt'], d, '\t');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~emptyflag % run the rest only for non-empty results
    
    % draw the overlay image
    image = slover([spmdir 'canonical/single_subj_T1.nii']);
    image = add_spm(image);
    image.slices = [-48:4:84]; % these slices work for the above T1; otherwise adjust
    paint(image)
    
    % print image to file
    style = hgexport('factorystyle');
    style.Background = 'black';
    style.Format = 'png';
    hgexport(gcf, [filepath '/' filename '_slices.png'], style);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % save out the full image
    spm_write_filtered(xSPM.Z,xSPM.XYZ,SPM.xVol.DIM,SPM.xVol.M,'SPM-filtered',[filename]);
    
end
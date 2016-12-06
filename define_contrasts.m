function [contrast_vec] = define_contrasts(SPM,poslabel,neglabel)
% Creates a contrast vector given SPM.mat model file and regressor labels
% FORMAT contrast_vec = define_contrasts(SPM,poslabel,neglabel)
%
% Inputs
%
% SPM        - SPM.mat file specifying the model for an individual subject
% poslabel   - cell array of regressor names to be positively weighted in
%              the contrast. Names are matched to design matrix column
%              labels using partial matching, e.g., {'Emo'} would find
%              columns labeled 'EmoR' and 'EmoF'. Multiple names can be
%              used to label multiple sets of regressors, e.g., {'Emo'
%              'Neu'}
% neglabel   - cell array of regressor names to be negatively weighted in
%              the contrast. (optional)
%
% Outputs
% 
% contrast_vec  - a row vector corresponding to the desired contrast of
%               interest
%
% Author: Maureen Ritchey, December 2017

if nargin<3
    neglabel = {};
end

colnames = SPM.xX.name;

% Find columns that are labeled one of the positive conditions
poscols = [];
for c=1:length(poslabel)
    curcols = find(cellfun(@(IDX) ~isempty(IDX), strfind(colnames, poslabel{c})));
    poscols = [poscols curcols];
end
fprintf('Found %i columns with positive label.\n',length(unique(poscols)));

% Construct contrast vector
contrast_vec = zeros(1,size(colnames,2));

% Add positive values to contrast vector, scaling by number of columns
contrast_vec(poscols) = 1./length(poscols);

if ~isempty(neglabel)
    % Find columns that are labeled one of the negative conditions
    negcols = [];
    for c=1:length(neglabel)
        curcols = find(cellfun(@(IDX) ~isempty(IDX), strfind(colnames, neglabel{c})));
        negcols = [negcols curcols];
    end
    fprintf('Found %i columns with negative label.\n',length(unique(negcols)));
    
    % Error checking
    if max(ismember(poscols,negcols))>0
        error('Attempting to label column as both positive and negative.');
    end
    
    % Add negative values to contrast vector, scaling by number of columns
    contrast_vec(negcols) = -1./length(negcols);
end

% Error checking
if max(abs(contrast_vec))==0
    error('No columns labeled in contrast.');
end

end
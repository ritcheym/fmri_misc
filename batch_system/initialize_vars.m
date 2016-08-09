function [b] = initialize_vars(subjects,i)

% SPM info
b.spmDir = fileparts(which('spm'));         % path to SPM installation

% Directory information
dataDir = '/path/to/MRI/data/';
b.curSubj = subjects{i};
b.dataDir = strcat(dataDir,b.curSubj,'/');  % make data directory subject-specific
b.funcRuns = {'epi_0001' 'epi_0002'};       % folders containing functional images
b.anatT1 = 'mprage';                        % folder containing T1 structural

% Call sub-function to run exceptions
b = run_exceptions(b);

end


% Subject-specific exceptions (e.g., deviations from naming convention)
function b = run_exceptions(b)

if strcmp(b.curSubj,'s01')
    if isfield(b,'funcRuns')
        b.funcRuns = {'epi_0002' 'epi_0003'}; % e.g., if s01 had different run numbers
    end
end

end

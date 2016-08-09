clear all;

% get and set paths
scriptdir = pwd;
addpath('/path/to/initialize_vars/fun'); % add any necessary paths (e.g., to initialize_vars)

% Specify variables
outLabel = 'basic_pp'; %output label
subjects = {'s01' 's02' 's03' 's04'};
batch_functions = {'job_realign' 'job_segment'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize error log
errorlog = {}; ctr=1;

% loop over batch functions
for m=1:length(batch_functions)
    fprintf('\nFunction: %s\n',batch_functions{m});

    % loop over subjects
    for i=1:length(subjects)
        fprintf('\nWorking on %s...\n',subjects{i});

        % get subject-specific variables
        b = initialize_vars(subjects,i);

        % move to subject data folder
        cd(b.dataDir);

        %run matlabbatch job
        try

            %run current job function, passing along subject-specific inputs
            batch_output = eval(strcat(batch_functions{m},'(b)'));

            %save output (e.g., matlabbatch) for future reference
            outName = strcat(outLabel,'_',date,'_',batch_functions{m});
            save(outName, 'batch_output');

        catch err % if there's an error, take notes & move on
            errorlog{ctr,1} = subjects{i};
            errorlog{ctr,2} = batch_functions{m};
            errorlog{ctr,3} = err;
            ctr = ctr + 1;
            cd(scriptdir);
            continue;
        end

        cd(scriptdir);
    end

end

if ~isempty(errorlog)
    disp(errorlog) % print error log at end
else
    disp('No errors detected.');
end

function [] = generate_spm_singletrial()

% This script takes an existing SPM.mat file and converts it to a
% single-trial SPM.mat file, where each trial is modeled as a separate
% regressor. All other parameters (explicit mask, covariates, etc) are
% pulled in identically from the original SPM.mat file.
%
% Setting the 'estimate' flag to a non-zero value will automatically
% estimate the newly-generated SPM.mat file.
%
% A beta_info.mat file is generated, specifying condition information for
% each of the resulting betas.
%
% This script has two modes: multi-regressor and multi-model. The multi-
% regressor approach estimates a single model with all trials represented
% by individual regressors. The multi-model approach estimates a model for
% each individual trial, setting the first regressor to the individual
% trial and the second to all other trials. Beta images are then moved and
% renamed in a single betas directory (with the option to get rid of all of
% the extra files). The multi-regressor approach is similar to that
% described in Rissman et al. 2004 NI, and the multi-model approach is
% similar to the LS-S approach described in Mumford et al. 2012 NI. Note
% that the multi-model approach is takes a long time to run in this
% implementation, so there's a lot of room for improvement.
%
% Requires SPM8.
%
% To-do list: contrast vectors for original conditions (for comparison
% against conventional model), option to estimate contrasts for each trial
% so that t-images can be used instead of betas, option to use
% files with a different prefix than original model (e.g., unsmoothed data)
%
% Note: The multi-regressor approach, as implemented here, has been
% debugged with my own data, but not the multi-model approach. I include
% the multi-model code here for completeness, but if you use it, debug and
% use with caution.
%
%
% Author: Maureen Ritchey, 10-2012


%% USER INFORMATION

% Directory for the new model. If it does not exist, it will be created.
stdir = '/Users/YourName/Project/Analysis/SingleTrialModel/';

% Directory for the existing model
modeldir = '/Users/YourName/Project/Analysis/ConventionalModel/';

% Subjects to run
subjects = {'s01' 's02' 's03' 's04' 's05' 's06' 's07' 's08' 's09' 's10'};

% Flag for estimating model (0=no estimation, 1=estimation)
estimate = 1;

% If desired, specify a condition name to lump together (no indiv trial
% regressors). This is useful if the original SPM.mat model included a
% 'catch-all' condition of no interest. Set to 'NONE' if not desired.
lump_conditions = 'NONE'; % 'OTHERS'

% Type of model to run (1=multi-regressor approach, 2=multi-model approach)
modeltype = 1;

% Option to discard extra files in multi-model approach to save space
% (1=discard, 0=leave them). Always keeps regs and covs files.
discard_mm_files = 1;


%% MAIN CODE

for iSub = 1:length(subjects)
    
    %load pre-existing SPM file containing model information
    fprintf('\nLoading previous model for %s:\n%s\n',subjects{iSub},[modeldir,subjects{iSub},'/SPM.mat']);
    if exist([modeldir,subjects{iSub},'/SPM.mat'],'file')
        load([modeldir,subjects{iSub},'/SPM.mat'])
    else
        error('Cannot find SPM.mat file.');
    end
    
    %find or create the output directory for the single-trial model
    outputdir = [stdir subjects{iSub} '/'];
    if ~exist(outputdir,'dir')
        fprintf('\nCreating directory:\n%s\n',outputdir);
        mkdir(outputdir)
    end
    
    %get model information from SPM file
    fprintf('\nGetting model information...\n');
    files = SPM.xY.P;
    fprintf('Modeling %i timepoints across %i sessions.\n',size(files,1),length(SPM.Sess));
    
    
    % MULTI-REGRESSOR APPROACH
    if modeltype == 1
        
        %set up beta information
        trialinfo = {'beta_number' 'session' 'condition' 'condition_rep' 'number_onsets' 'first_onset' 'beta_name'};
        counter = 1;
        
        %loop across sessions
        for iSess=1:length(SPM.Sess)
            rows = SPM.Sess(iSess).row;
            sess_files = files(rows',:);
            sess_files = cellstr(sess_files);
            covariates = SPM.Sess(iSess).C.C;
            
            onsets = {};
            durations = {};
            names = {};
            
            for j=1:length(SPM.Sess(iSess).U)
                %check for special condition names to lump together
                if strfind(SPM.Sess(iSess).U(j).name{1},lump_conditions)
                    onsets = [onsets SPM.Sess(iSess).U(j).ons'];
                    durations = [durations SPM.Sess(iSess).U(j).dur'];
                    cur_name = [SPM.Sess(iSess).U(j).name{1}];
                    names = [names cur_name];
                    curinfo = {counter iSess SPM.Sess(iSess).U(j).name{1} [1] length(SPM.Sess(iSess).U(j).ons) SPM.Sess(iSess).U(j).ons(1) cur_name};
                    trialinfo = [trialinfo; curinfo];
                    counter = counter + 1;
                    %otherwise set up a regressor for each individual trial
                else
                    for k=1:length(SPM.Sess(iSess).U(j).ons)
                        onsets = [onsets SPM.Sess(iSess).U(j).ons(k)];
                        durations = [durations SPM.Sess(iSess).U(j).dur(k)];
                        cur_name = [SPM.Sess(iSess).U(j).name{1} '_' num2str(k)];
                        names = [names cur_name];
                        curinfo = {counter iSess SPM.Sess(iSess).U(j).name{1} k length(SPM.Sess(iSess).U(j).ons(k)) SPM.Sess(iSess).U(j).ons(k) cur_name};
                        trialinfo = [trialinfo; curinfo];
                        counter = counter + 1;
                    end
                end
            end
            
            %save regressor onset files
            fprintf('Saving regressor onset files for Session %i: %i trials included\n',iSess,length(names));
            regfile = [outputdir 'st_regs_run' num2str(iSess) '.mat'];
            save(regfile,'names','onsets','durations');
            
            %save covariates (e.g., motion parameters) that were specified
            %in the original model
            covfile = [outputdir 'st_covs_run' num2str(iSess) '.txt'];
            dlmwrite(covfile,covariates,'\t');
            if ~isempty(covariates)
                for icov = 1:size(covariates,2)
                    curinfo = {counter iSess 'covariate' icov 1 0 strcat('covariate',num2str(icov))};
                    trialinfo = [trialinfo; curinfo];
                    counter = counter + 1;
                end
            end
            
            %create matlabbatch for creating new SPM.mat file
            if iSess==1
                matlabbatch = create_spm_init(outputdir,SPM);
            end
            matlabbatch = create_spm_sess(matlabbatch,iSess,sess_files,regfile,covfile,SPM);
            
        end
        
        %run matlabbatch to create new SPM.mat file using SPM batch tools
        fprintf('\nCreating SPM.mat file:\n%s\n',[outputdir 'SPM.mat']);
        spm_jobman('initcfg')
        spm('defaults', 'FMRI');
        spm_jobman('serial', matlabbatch);
        
        
        if estimate > 0 %optional: estimate SPM model
            fprintf('\nEstimating model from SPM.mat file.\n');
            spmfile = [outputdir 'SPM.mat'];
            matlabbatch = estimate_spm(spmfile);
            spm_jobman('serial', matlabbatch);
        end
        
                
        %save beta information
        infofile = [outputdir 'beta_info.mat'];
        save(infofile,'trialinfo');
        
        clear SPM matlabbatch
        
        % MULTI-MODEL APPROACH - use with caution! may require debugging
    elseif modeltype == 2
        
        %make trial directory
        betadir = [outputdir 'betas/'];
        if ~exist(betadir,'dir')
            mkdir(betadir)
        end
        
        %set up beta information
        trialinfo = {'beta_number' 'session' 'condition' 'condition_rep' 'number_onsets' 'beta_name' 'trial_dir' 'beta_name'};
        counter = 1;
        
        %loop across sessions
        for iSess=1:length(SPM.Sess)
            rows = SPM.Sess(iSess).row;
            sess_files = files(rows',:);
            sess_files = cellstr(sess_files);
            covariates = SPM.Sess(iSess).C.C;
            
            
            for j=1:length(SPM.Sess(iSess).U)
                %check for special condition names to ignore
                if strfind(SPM.Sess(iSess).U(j).name{1},lump_conditions)
                    if strcmp(lump_conditions,'NONE')
                    else
                        fprintf('\nIgnoring condition: %s\n',lump_conditions);
                    end
                    %otherwise set up a model for each individual trial
                else
                    for k=1:length(SPM.Sess(iSess).U(j).ons)
                        
                        % individual trial
                        onsets = {};
                        durations = {};
                        names = {};
                        onsets = [onsets SPM.Sess(iSess).U(j).ons(k)];
                        durations = [durations SPM.Sess(iSess).U(j).dur(k)];
                        cur_name = [SPM.Sess(iSess).U(j).name{1} '_' num2str(k)];
                        names = [names cur_name];
                        
                        % all other trials
                        otheronsets = [];
                        otherdurations = [];
                        othernames = {};
                        for jj=1:length(SPM.Sess(iSess).U)
                            for kk=1:length(SPM.Sess(iSess).U(jj).ons)
                                if j~=jj & k~=kk
                                    otheronsets = [otheronsets SPM.Sess(iSess).U(jj).ons(kk)];
                                    otherdurations = [otherdurations SPM.Sess(iSess).U(jj).dur(kk)];
                                    othernames = ['OTHERTRIALS'];
                                end
                            end
                        end
                        
                        % group into single set of regs files
                        onsets = [onsets otheronsets];
                        durations = [durations otherdurations];
                        names = [names othernames];
                        
                        %make trial directory
                        trialdir = [outputdir 'Sess' num2str(iSess) '/' cur_name '/'];
                        if ~exist(trialdir,'dir')
                            mkdir(trialdir)
                        end
                        
                        %add trial information
                        curinfo = {counter iSess SPM.Sess(iSess).U(j).name{1} k length(SPM.Sess(iSess).U(j).ons(k)) cur_name trialdir ['Sess' num2str(iSess) '_' cur_name '.img']};
                        trialinfo = [trialinfo; curinfo];
                        counter = counter + 1;
                        
                        %save regressor onset files
                        regfile = [trialdir 'st_regs.mat'];
                        save(regfile,'names','onsets','durations');
                        
                        covfile = [trialdir 'st_covs.txt'];
                        dlmwrite(covfile,covariates,'\t');
                        
                        %create matlabbatch for creating new SPM.mat file
                        matlabbatch = create_spm_init(trialdir,SPM);
                        matlabbatch = create_spm_sess(matlabbatch,1,sess_files,regfile,covfile,SPM);
                        
                        %run matlabbatch to create new SPM.mat file using SPM batch tools
                        fprintf('\nCreating SPM.mat file:\n%s\n\n',[trialdir 'SPM.mat']);
                        if counter == 1
                            spm_jobman('initcfg')
                            spm('defaults', 'FMRI');
                        end
                        spm_jobman('serial', matlabbatch);
                        
                        if estimate %optional: estimate SPM model
                            fprintf('\nEstimating model from SPM.mat file.\n');
                            spmfile = [trialdir 'SPM.mat'];
                            matlabbatch = estimate_spm(spmfile);
                            spm_jobman('serial', matlabbatch);
                            clear matlabbatch
                            
                            % copy first beta image to beta directory
                            copyfile([trialdir 'beta_0001.img'],[betadir 'Sess' num2str(iSess) '_' cur_name '.img']);
                            copyfile([trialdir 'beta_0001.hdr'],[betadir 'Sess' num2str(iSess) '_' cur_name '.hdr']);
                            
                            % discard extra files, if desired
                            if discard_mm_files
                                prevdir = pwd;
                                cd(trialdir);
                                delete SPM*; delete *.hdr; delete *.img;
                                cd(prevdir);
                            end
                            
                        end
                    end
                    
                end
            end
        end
        
        %save beta information
        infofile = [betadir subjects{iSub} '_beta_info.mat'];
        save(infofile,'trialinfo');
        
    else
        error('Specify model type as 1 or 2');
    end
    
    clear SPM
end

end

%% SUBFUNCTIONS

function [matlabbatch] = create_spm_init(outputdir,SPM)
% subfunction for initializing the matlabbatch structure to create the SPM
matlabbatch{1}.spm.stats.fmri_spec.dir = {outputdir};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = SPM.xBF.UNITS;
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = SPM.xY.RT;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = SPM.xBF.T;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = SPM.xBF.T0;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = SPM.xBF.Volterra;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
if isempty(SPM.xM.VM)
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
else
    matlabbatch{1}.spm.stats.fmri_spec.mask = {SPM.xM.VM.fname};
end
matlabbatch{1}.spm.stats.fmri_spec.cvi = SPM.xVi.form;

end

function [matlabbatch] = create_spm_sess(matlabbatch,iSess,sess_files,regfile,covfile,SPM)
% subfunction for adding sessions to the matlabbatch structure
matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).scans = sess_files; %fix this
matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).multi = {regfile};
matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).multi_reg = {covfile};
matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).hpf = SPM.xX.K(iSess).HParam;

end

function [matlabbatch] = estimate_spm(spmfile)
% subfunction for creating a matlabbatch structure to estimate the SPM
matlabbatch{1}.spm.stats.fmri_est.spmmat = {spmfile};
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
end

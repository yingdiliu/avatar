%%
% this script shows how to use the microsaccade detection method
% published in Otero-Millan et al. Journal of Vision 2014

% clear the variables
clear all; clc; 
close all; 

cd '/Users/yingdiliu/Drive/mygit/avatar'

% import nessasry functions for dummy author who forget to add this
% function 
addpath( 'Utils' )


% Set up variables --------------------------------------------------------
folder = fileparts(mfilename('fullpath'));
if ( isempty( folder) )
    folder = pwd;
end


% % make sure that the pwd is avatar, not the +ClusterDetection..to avoid
% % warning about non-existent data folder 
% if strcmp(folder(end-5:end),'avatar') == 0
%    error('warning: make sure your current directory is correct')
% end


folder = [folder '/data'];
subjNames = {'monica','charlotte',}; %%%% TODO %%%%: to be added
for subjnum = 1:length(subjNames)
    session = subjNames{subjnum};

    %ONLY LOAD USEFUL DATA
    format long g
    data_file = [ session '_data'];
    data_variables = {'eyedata' , 'sr' , 'trialSamples' , 'fixationTrials'};
    load(data_file , data_variables{:})
    
    
    %% to make things easier, only look at the fixation trials first. 
    
    fixdata = eyedata(eyedata(:,2)==1,:); 
    trials = fixdata(:,1); 
    [trialStartSamples]= findFirstUnique(trials);
    trialEndSamples=[trialStartSamples(2:end)-1; length(trials)];
    trialSamples=[trialStartSamples trialEndSamples];
        
    rawData =  fixdata(:,[9 3 4 5 6]);
    
    samplerate = mean(sr(fixationTrials));
    
     % data for this participant (all trials)
    DPP = visAngPerPixel(52.2457, 70, 1920);
    rawData(:,2:5) = rawData(:,2:5) * DPP; % x, y position data, in degrees.
    
    
    %Detect blinks (Utils function)
    pupils = fixdata(:,[7 8]);
    left_blinks = getBlinks( pupils(:,1) , samplerate );
    right_blinks = getBlinks( pupils(:,2) , samplerate ); 
    blinks = left_blinks | right_blinks;
    % figure; plot(blinks); ylim([-1,2]); title('blinks: 1=blink sample')
    
    % remove false data (Utils function)
    % false data: Either blinks or where pupil size change very abruptly.
    % Probably partial blinks. 
    falseIdx = cleanFalseData( rawData , samplerate );
    falseIdx = blinks | falseIdx;
    % figure; plot(falseIdx); ylim([-1,2]); 
    
    
    % Create recording And Save It
    % Create( folder, session, samples, blinkYesNo, samplerate, trials, importInfo )
    recording = ClusterDetection.EyeMovRecording.Create(folder, session , rawData , falseIdx ,samplerate, trialSamples);
    
    % Runs the saccade detection
    [saccades stats] = recording.FindSaccades();
%     enum = ClusterDetection.SaccadeDetector.GetEnum;
%     
%     % Plots a main sequence
%     plot(saccades(:,enum.amplitude),saccades(:,enum.peakVelocity),'o')
%     %set(gca,'xlim',[0 1],'ylim',[0 100]);
%     xlabel('Saccade amplitude (deg)');
%     ylabel('Saccade peak velocity (deg/s)');
%     hold on;
    
    
    
    numSaccades = size(saccades,1);
    startIndex = saccades(:,1);
    
    % visualise the saccades, trial by trial
    for tr = 1 : size(trialSamples,1) 
        
        samples = trialSamples(tr,1): trialSamples(tr,2);
        
        
        
        
    


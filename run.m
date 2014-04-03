%%
% this script shows how to use the microsaccade detection method
% published in Otero-Millan et al. Journal of Vision 2014

% clear the variables
clear all; clc; 
close all; 

% import nessasry functions for dummy author who forget to add this
% function 
addpath( 'Utils' )


% Set up variables --------------------------------------------------------
folder = fileparts(mfilename('fullpath'));
if ( isempty( folder) )
    folder = pwd;
end

folder = [folder '/data'];
session = 'charlotte';



%ONLY LOAD USEFUL DATA
format long g 
data_file = [ session '_data'];
data_variables = {'eyedata' , 'sr' , 'trialSamples' , 'fixationTrials'};
load(data_file , data_variables{:})% or charlotte_data 
samplerate = sr(1);
rawData =  eyedata(:,[9 3 4 5 6]);
DPP = visAngPerPixel(52.2457, 70, 1920);
rawData = rawData * DPP;


%Detect blinks
pupils = eyedata(:,[7 8]);
left_blinks = getBlinks( pupils(:,1) , samplerate );
right_blinks = getBlinks( pupils(:,2) , samplerate );
%blinks(pupils(:,1)==0)=1; 
blinks = left_blinks | right_blinks;

% remove false data 
falseIdx = cleanFalseData( rawData , samplerate );

falseIdx = blinks | falseIdx;

%Get Real Trials 
realTrials = trialSamples( fixationTrials , :)


% Create recording And Save It
%Create( folder, session, samples, blinkYesNo, samplerate, trials, importInfo )
recording = ClusterDetection.EyeMovRecording.Create(folder, session , rawData , falseIdx ,samplerate, trialSamples);

% Runs the saccade detection
[saccades stats] = recording.FindSaccades();

% Plots a main sequence
enum = ClusterDetection.SaccadeDetector.GetEnum;
figure
plot(saccades(:,enum.amplitude),saccades(:,enum.peakVelocity),'o')
%set(gca,'xlim',[0 1],'ylim',[0 100]);
xlabel('Saccade amplitude (deg)');
ylabel('Saccade peak velocity (deg/s)');
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
data_variables = {'eyedata' , 'sr' , 'trialSamples'};
load(data_file , data_variables{:})% or charlotte_data 

%Detect blinks in a simple way
pupils = eyedata(:,[7 8]);
blinks = zeros(length(eyedata),1); 
blinks(pupils(:,1)==0)=1;


% Create recording And Save It
%Create( folder, session, samples, blinkYesNo, samplerate, trials, importInfo )
recording = ClusterDetection.EyeMovRecording.Create(folder, session , eyedata(:,[9 3 4 5 6]) , blinks , sr(1), trialSamples);

% Runs the saccade detection
[saccades stats] = recording.FindSaccades();

% Plots a main sequence
enum = ClusterDetection.SaccadeDetector.GetEnum;
figure
plot(saccades(:,enum.amplitude),saccades(:,enum.peakVelocity),'o')
%set(gca,'xlim',[0 1],'ylim',[0 100]);
xlabel('Saccade amplitude (deg)');
ylabel('Saccade peak velocity (deg/s)');
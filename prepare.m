% clear the variables
clear all; clc; 
close all; 


% Set up variables --------------------------------------------------------


% set folder
folder = fileparts(mfilename('fullpath'));
if ( isempty( folder) )
    folder = pwd;
end

folder = [folder '/data'];
session = 'monica';


%load data
format long g 

load monica_data  % or charlotte_data 

%create DataDB instance
db = ClusterDetection.DataDB;
db.InitDB( folder,session);


% get info of data
info.nSamples = size(eyedata,1);
info.samplerate	=  sr(1); 
info.trials = trialSamples;
info.hasLeftEye = 1;
info.hasRightEye = 1;


%detect blinks 
pupils = eyedata(:,[7 8]);
blinks = zeros(length(eyedata),1); 
blinks(pupils(:,1)==0)=1;


%write info to data db
db.WriteVariable( info , 'info' );
db.WriteVariable( blinks , 'blinkYesNo' );
db.WriteVariable( eyedata(:,[9 3 4 5 6]) , 'samples');


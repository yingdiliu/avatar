function blinks = getBlinks( pupil, samplerate)
%REMOVEBLINKS Summary of this function goes here
%   Detailed explanation goes here
    blinks = zeros(size(pupil,1),1); 
    blinks(pupil==0)=1;
    % remove samples +-200ms around blinks. 
    cutBlink = round(samplerate/1000*200); % number of samples 
    % starting and ending sample of each blink 
    col1 = find(diff(blinks)==1)+1;
    col2 = find(diff(blinks)==-1)+1;
    if length(col1) > length(col2) 
        col2 = [col2;size(blinks,1)];
    end
    blinkStartEnd = [col1 col2];
    for bb = 1: size(blinkStartEnd,1)
        % before blinks 
        blinks(blinkStartEnd(bb,1)-cutBlink:blinkStartEnd(bb,1))=1;
        % after blinks, be careful of exceeds matrix demensions
        if blinkStartEnd(bb,2)+cutBlink <  size(blinkStartEnd,1)
            blinks(blinkStartEnd(bb,2):blinkStartEnd(bb,2)+cutBlink)=1;
        end
    end


end

 
function falseIdx = cleanFalseData( rawData ,samplerate )
%CLEANFALSEDATA Summary of this function goes here
%   Detailed explanation goes here
    falseIdx = zeros( length(rawData(:,1)) , 1);
    % remove samples +-200ms around blinks. 
    falseData = find( diff( rawData(:,2) ) >  20 | diff( rawData(:,3) ) > 20 |  diff( rawData(:,4) ) > 20 | diff( rawData(:,5) ) > 20);
    cutBlink = round(samplerate/1000*200); % number of samples 
    % starting and ending sample of each blink     
    for bb = 1: size(falseData)
        startIdx = falseData(bb) - cutBlink;
        endIdx = falseData(bb) + cutBlink;
        if startIdx < 0  
            startIdx  = 1;
        end
        if endIdx > size(falseIdx)
            endIdx = size(falseIdx);
        end
        
        falseIdx(startIdx: endIdx) = 1;
        % before blinks 
        % after blinks, be careful of exceeds matrix demensions
    end


end


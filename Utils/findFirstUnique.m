function indexVector=findFirstUnique(trials)

uniqueTrials=unique(trials);

indexVector=zeros(length(uniqueTrials),1);

for ii=1:length(uniqueTrials)
    
    uu=uniqueTrials(ii);
    
    indexVector(ii)=find(trials==uu,1);
    
end
    







end
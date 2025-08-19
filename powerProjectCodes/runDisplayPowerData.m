%subjectName = 'dona'; cutoffVals = [1 1.2 0 0.3];
subjectName = 'jojo'; cutoffVals = [1 1.5 0 1];

folderData = 'N:\Projects\ProjectVajra\tESSingleStimMicroelectrode'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also
session = 'single'; % It can be 'single','dual','dual60'

protocolLists = getAllProtocolLists(subjectName);

% Choose two protocolLists to compare
group1 = 7; %[1 3 5];
group2 = 8; %[2 4 6];
protocolListsToUse{1} = protocolLists(group1);
protocolListsToUse{2} = protocolLists(group2);


removeStimProtocolFlag = 1;
displayPowerData(protocolListsToUse,removeStimProtocolFlag,session,cutoffVals);
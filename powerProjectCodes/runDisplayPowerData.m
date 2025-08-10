subjectName = 'jojo';
folderData = 'Z:\Projects\ProjectVajra\tESSingleStimMicroelectrode'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also
session='single';% It can be 'single','dual','dual60'

protocolLists = getAllProtocolLists(subjectName);

% Choose two protocolLists to compare
group1 = 1;
group2 = 2;
protocolListsToUse{1} = protocolLists(group1);
protocolListsToUse{2} = protocolLists(group2);


removeStimProtocolFlag = 1;
displayPowerData2(protocolListsToUse,removeStimProtocolFlag,session);
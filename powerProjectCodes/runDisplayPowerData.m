subjectName = 'dona';
folderData = 'N:\Projects\Niloy_tES-StimulationProject'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also

protocolLists = getAllProtocolLists(subjectName);

% Choose two protocolLists to compare
group1 = [1 3 5];
group2 = [2 4 6];
protocolListsToUse{1} = protocolLists(group1);
protocolListsToUse{2} = protocolLists(group2);

removeStimProtocolFlag = 1;
displayPowerData(protocolListsToUse,removeStimProtocolFlag);
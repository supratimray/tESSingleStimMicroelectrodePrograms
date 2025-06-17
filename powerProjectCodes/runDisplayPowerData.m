subjectName = 'dona';
folderData = 'N:\Projects\Niloy_tES-StimulationProject'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also

protocolLists = getAllProtocolLists(subjectName);

% Choose two protocolLists to compare
protocolListsToUse = protocolLists(7:8);
removeStimProtocolFlag = 1;
displayPowerData(protocolListsToUse,removeStimProtocolFlag);
subjectName = 'dona';
folderData = 'N:\Projects\Niloy_tES-StimulationProject'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also

% Fixed variables
gridType = 'Microelectrode';
gridLayout = 2;
sideChoice = [];
badTrialNameStr = 'V4';
useCommonBadTrialsFlag = 1;

% Free variables
f = 5; o = 5; c = 4; removeERPFlag = 0;

protocolLists = getAllProtocolLists(subjectName);
protocolsToSave = 1:8;

for p = 1:length(protocolsToSave)
    
    % Choose a protocolList
    protocolList = protocolLists{protocolsToSave(p)}; % Choose one
    [expDatesAll,protocolNamesAll] = getProtocolListDetails(protocolList);

    uniqueExpDates = unique(expDatesAll,'stable');

    for i=1:length(uniqueExpDates)
        expDate = uniqueExpDates{i}; % Choose one
        protocolNames = protocolNamesAll(strcmp(expDate,expDatesAll));
        goodLFPElectrodes = getGoodLFPElectrodes(subjectName,expDate,folderData,gridType);
        savePowerData(subjectName,expDate,protocolNames,folderData,gridType,goodLFPElectrodes,protocolList,f,o,c,removeERPFlag);
    end
end
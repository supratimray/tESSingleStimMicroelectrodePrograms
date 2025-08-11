subjectName = 'jojo';
folderData = 'D:\tESSingleStimMicroelectrode'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also
session='single';

% Fixed variables
gridType = 'Microelectrode';
gridLayout = 2;
sideChoice = [];
badTrialNameStr = 'V4'; % In case of dona its 'V1'
useCommonBadTrialsFlag = 1;
commonUnitFlag=1; % In case of dona its 0

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
        savePowerData(subjectName,expDate,protocolNames,folderData,gridType,goodLFPElectrodes,protocolList,f,o,c,removeERPFlag,badTrialNameStr,useCommonBadTrialsFlag);
    end
end
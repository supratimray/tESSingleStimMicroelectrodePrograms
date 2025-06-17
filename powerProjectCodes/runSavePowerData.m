subjectName = 'dona';
folderData = 'N:\Projects\Niloy_tES-StimulationProject'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also

% Fixed variables
gridType = 'Microelectrode';
gridLayout = 2;
sideChoice = [];
badTrialNameStr = 'V4';
useCommonBadTrialsFlag = 1;

protocolLists = getAllProtocolLists(subjectName);

% Choose a protocolList
protocolList = protocolLists{8}; % Choose one
[expDatesAll,protocolNamesAll] = getProtocolListDetails(protocolList);

uniqueExpDates = unique(expDatesAll,'stable');

expDate = uniqueExpDates{3}; % Choose one
protocolNames = protocolNamesAll(strcmp(expDate,expDatesAll));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
goodLFPElectrodes = getGoodLFPElectrodes(subjectName,expDate,folderData,gridType);

f = 5;
o = 5;
c = 4;
removeERPFlag = 1;
savePowerData(subjectName,expDate,protocolNames,folderData,gridType,goodLFPElectrodes,protocolList,f,o,c,removeERPFlag);
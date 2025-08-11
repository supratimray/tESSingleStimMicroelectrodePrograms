subjectName = 'dona';
folderData = 'Z:\Projects\ProjectVajra\tESSingleStimMicroelectrode'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also
session='single';

% Fixed variables
gridType = 'Microelectrode';
badTrialNameStr = 'V1'; % In case of dona its 'V1'
commonUnitFlag=0; % In case of dona its 0

% Free variables
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
        saveSpikeInfo(subjectName,expDate,protocolNames,folderData,badTrialNameStr,session,gridType,protocolList,commonUnitFlag);
    end
end
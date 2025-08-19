subjectName = 'dona';
badTrialNameStr = 'V1'; % In case of dona its 'V1'
commonUnitFlag = 0; % In case of dona its 0
cutoffVals = [1 1.2 0 1];

% subjectName = 'jojo';
% badTrialNameStr = 'V4';
% commonUnitFlag = 1;
% cutoffVals = [1 1.5 0 1];

folderData = 'N:\Projects\ProjectVajra\tESSingleStimMicroelectrode'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also
session='single';

% Fixed variables
gridType = 'Microelectrode';

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
        saveSpikeInfo(subjectName,expDate,protocolNames,folderData,badTrialNameStr,session,gridType,protocolList,commonUnitFlag,cutoffVals);
    end
end
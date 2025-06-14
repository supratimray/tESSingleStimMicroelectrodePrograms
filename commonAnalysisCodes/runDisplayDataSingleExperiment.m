subjectName = 'dona';
folderData = 'N:\Projects\Niloy_tES-StimulationProject'; % This is the folder where the folder 'data' with segmented data is kept. We assume that badTrials are available also

% Fixed variables
gridType = 'Microelectrode';
gridLayout = 2;
sideChoice = [];
badTrialNameStr = 'V4';
useCommonBadTrialsFlag = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hard code the experiment date and protocol information if it is not
% available yet in protocolLists

% Option 1
% expDate = '060923';
% protocolNames{1} = 'GRF_007'; % Pre-Stim, SFOriCon,4x4x3
% % protocolNames{2} = 'GRF_008'; stimType{index} = 4; % Stim, -3mA, SFOriCon,4x4x3
% protocolNames{2} = 'GRF_009'; % Post-Stim, SFOriCon,4x4x3
% protocolNames{3} = 'GRF_010'; % Post-Stim, SFOriCon,4x4x3
% protocolNames{4} = 'GRF_011'; % Post-Stim, SFOriCon,4x4x3
% protocolNames{5} = 'GRF_012'; % Post-Stim, SFOriCon,4x4x3

% Option 2 - get information from protocolLists
protocolLists = getAllProtocolLists(subjectName);

% Choose a protocolList
protocolList = protocolLists{7}; % Choose one
[expDatesAll,protocolNamesAll] = getProtocolListDetails(protocolList);

uniqueExpDates = unique(expDatesAll,'stable');

expDate = uniqueExpDates{2}; % Choose one
protocolNames = protocolNamesAll(strcmp(expDate,expDatesAll));
protocolNames(2)=[]; % Remove the protocol where stimulation was applied

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

goodLFPElectrodes = getGoodLFPElectrodes(subjectName,expDate,folderData,gridType);
displaySingleChannelGRFs(subjectName,expDate,protocolNames,folderData,gridType,gridLayout,sideChoice,badTrialNameStr,useCommonBadTrialsFlag,goodLFPElectrodes);
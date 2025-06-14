function [expDates,protocolNames] = getProtocolListDetails(protocolList)

informationDirectory = fileparts(which('getProtocolListDetails.m'));
fileName = fullfile(informationDirectory,'protocolLists',[protocolList '.m']);

expDates =[]; protocolNames = [];
if exist(fileName,'file')
    eval(['[expDates,protocolNames,stimType] = ' protocolList ';']); %#ok<*EVLEQ>
    disp([protocolList ': ' num2str(length(unique(expDates))) ' unique experiments.']);
else
    disp([fileName ' does not exist']);
end
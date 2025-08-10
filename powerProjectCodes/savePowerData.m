% Saves power and spike data for a given experiment. To maintain
% compatibility, we save data in a format that is used in the program
% displaySingleChannelGRFs which is available in CommonPrograms.

function savePowerData(subjectName,expDate,protocolNames,folderSourceString,gridType,goodLFPElectrodes,goodSpikeElecs,protocolList,f,o,c,removeERPFlag,badTrialNameStr,useCommonBadTrialsFlag)

% These are hardcoded options. If these are changed, data needs to be saved again
referenceChannelString = '';
sideChoice = [];
a = 1; e = 1; s = 1; t = 1;
blRange = [-0.5 0];
stRange = [0.25 0.75];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folderOut = 'savedData';
makeDirectory(folderOut);

numProtocols = length(protocolNames);
numGoodLFPElectrodes = length(goodLFPElectrodes);
% numGoodSpikeElectrodes = length(goodSpikeElecs);

fileSave = fullfile(folderOut,[protocolList '_' expDate '_f' num2str(f) 'o' num2str(o) 'c' num2str(c) '_removeERP' num2str(removeERPFlag) '.mat']);

if exist(fileSave,'file')
    disp([fileSave ' exists. Quitting...']);
else
    dataOutTMP1 = cell(1,numGoodLFPElectrodes);
    dataOutShort = cell(numGoodLFPElectrodes,numProtocols); % Saves some additional data

    for i=1:numGoodLFPElectrodes
        channelString = ['elec' num2str(goodLFPElectrodes(i))];
        disp(['Working on ' channelString ', ' num2str(i) '/' num2str(numGoodLFPElectrodes)]);

        dataOutTMP2 = cell(1,numProtocols);
        for j=1:numProtocols
            dataIn = getSpikeLFPDataSingleChannel(subjectName,expDate,protocolNames{j},folderSourceString,channelString,0,gridType,sideChoice,referenceChannelString,badTrialNameStr,useCommonBadTrialsFlag);
            tmp = getDataGRF(dataIn,a,e,s,f,o,c,t,blRange,stRange,removeERPFlag);
            dataOutTMP2{j} = tmp;

            % Same some additional data for individual protocols and electrodes
            tmp2.SBL = tmp.SBL;
            tmp2.SST = tmp.SST;
            tmp2.frVals = tmp.frVals;
            dataOutShort{i,j} = tmp2;
        end
        dataOutTMP1{i} = dataOutTMP2;
    end
    dataOut = combineDataGRF(dataOutTMP1);

    save(fileSave,'dataOut','dataOutShort','goodLFPElectrodes','goodSpikeElecs');
end
end

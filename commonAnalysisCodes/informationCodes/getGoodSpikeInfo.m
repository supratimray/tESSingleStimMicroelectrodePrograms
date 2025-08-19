% Objective of the code is to pull information on good spiking units
% Already analysed information is stored in GoodUnitsV1/V4.mat
% cutoffs: a 4-D array with cutoffs for firingRate, snr, total spikes and absolute change in firing rate.

function goodSpikeElectrodes = getGoodSpikeInfo(subjectName, expDate, protocolNames, folderData, badTrialNameStr, session, gridType, commonUnitFlag, cutoffVals)
if ~exist('gridType','var');            gridType = 'Microelectrode';    end
if ~exist('commonUnitFlag','var');      commonUnitFlag = 0;             end

if strcmp(session,'single')
    stimBlock=2;
elseif strcmp(session,'dual')
    stimBlock=[2 4];
end

nProtocols = length(protocolNames);
goodSpkGrid = cell(nProtocols, 1);

% Locate GoodUnits file
if commonUnitFlag
    for i = 1:nProtocols
        fileStr = ['Cutoff_fr' num2str(cutoffVals(1)) 'snr' num2str(cutoffVals(2)) 'tspk' num2str(cutoffVals(3)) 'absfr' num2str(cutoffVals(4))];

        fileName = fullfile(folderData, 'data', subjectName, gridType, expDate, protocolNames{i}, 'segmentedData', append('GoodUnits', badTrialNameStr, fileStr, '.mat'));
        if exist(fileName,'file')
            temp = load(fileName, 'goodSpikeElectrodes');
            goodSpkGrid{i} = temp.goodSpikeElectrodes;
        else
            goodSpikeElectrodes = getGoodSpikeElectrodes; % Write the command to get good spiking electrodes
            save(fileName, 'goodSpikeElectrodes');
            goodSpkGrid{i} = goodSpikeElectrodes;
        end
    end 

    % Identify and exclude the stimulation block
    nonStimIndices = setdiff(1:nProtocols, stimBlock);

    % Compute common good electrodes across non-stim protocols
    commonGood = goodSpkGrid{nonStimIndices(1)};
    for k = nonStimIndices(2:end)
        commonGood = intersect(commonGood, goodSpkGrid{k});
    end
    goodSpikeElectrodes = commonGood;

else
    fileStr = ['Cutoff_fr' num2str(cutoffVals(1)) 'snr' num2str(cutoffVals(2)) 'tspk' num2str(cutoffVals(3)) 'absfr' num2str(cutoffVals(4))];
    fileName=fullfile(folderData,'data',subjectName,gridType,expDate,'GRF_001','segmentedData',append('GoodUnits', badTrialNameStr, fileStr, '.mat'));

    if exist(fileName,'file')
        temp = load(fileName, 'goodSpikeElectrodes');
        goodSpikeElectrodes =temp.goodSpikeElectrodes;
    else
        goodSpikeElectrodes = getGoodSpikeElectrodes; % Write the command to get good spiking electrodes
        save(fileName, 'goodSpikeElectrodes');
    end
end
end
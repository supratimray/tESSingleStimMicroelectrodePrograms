% Objective of the code is to pull information on good spiking units
% Already analysed information is stored in GoodUnitsV1/V4.mat
% cutoffs: a 4-D array with cutoffs for firingRate, snr, total spikes and absolute change in firing rate.

function [goodSpikeElectrodes, cutoffVals] = getGoodSpikeInfo(subjectName, expDate, protocolNames, folderData, badTrialNameStr, session, gridType, commonUnitFlag)
if ~exist('gridType','var');            gridType = 'Microelectrode';    end
if ~exist('commonUnitFlag','var');           commonUnitFlag = 0;    end

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
        fileName = fullfile(folderData, 'data', subjectName, gridType, expDate, protocolNames{i}, 'segmentedData', append('GoodUnits', badTrialNameStr, '.mat'));
        temp = load(fileName, 'goodSpikeElectrodes','cutoffs');
        goodSpkGrid{i} = temp.goodSpikeElectrodes;
    end 

    % Identify and exclude the stimulation block
    nonStimIndices = setdiff(1:nProtocols, stimBlock);

    % Compute common good electrodes across non-stim protocols
    commonGood = goodSpkGrid{nonStimIndices(1)};
    for k = nonStimIndices(2:end)
        commonGood = intersect(commonGood, goodSpkGrid{k});
    end
    goodSpikeElectrodes = commonGood;
    cutoffVals=temp.cutoffs;
else
    fileName=fullfile(folderData,'data',subjectName,gridType,expDate,'GRF_001','segmentedData',append('GoodUnits', badTrialNameStr, '.mat'));
    temp = load(fileName, 'goodSpikeElectrodes','cutoffs');
    goodSpikeElectrodes =temp.goodSpikeElectrodes;
    cutoffVals=temp.cutoffs;
end
end
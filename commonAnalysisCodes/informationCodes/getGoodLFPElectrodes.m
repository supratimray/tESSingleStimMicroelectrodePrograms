function goodLFPElectrodes = getGoodLFPElectrodes(subjectName,expDate,folderData,gridType)
if ~exist('gridType','var');            gridType = 'Microelectrode';    end

% Get Good LFP electrodes
x = load(fullfile([subjectName gridType 'RFData.mat']));
goodLFPElectrodes = x.highRMSElectrodes;

if strcmp(subjectName,'dona')
    goodLFPElectrodes = goodLFPElectrodes(goodLFPElectrodes<=48); % only V1 electrodes
end

% If expDate is provided, removing the electrodes with bad impedance values
impedanceCutoff = [100 3000]; % kOhm

if exist('expDate','var')
    impedanceFile = fullfile(folderData,'data',subjectName,gridType,expDate,'impedanceValues.mat');
    if exist(impedanceFile,'file')
        tmp = load(impedanceFile);
        badElectrodes = union(find(tmp.impedanceValues<impedanceCutoff(1)),find(tmp.impedanceValues>impedanceCutoff(2)));
    else
        badElectrodes = [];
    end

    goodLFPElectrodes = setdiff(goodLFPElectrodes,badElectrodes);
end
end
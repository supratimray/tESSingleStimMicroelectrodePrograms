% cutoffs: a 4-D array with cutoffs for firingRate, snr, total spikes and absolute change in firing rate.
% In case of dona, its [1 1.2 0 0.3], on analog days [1 1 0 0.3], for jojo its [1 1.5 0 1]

function saveSpikeInfo(subjectName, expDate, protocolNames, folderData, badTrialNameStr, session, gridType, protocolList, commonUnitFlag, cutoffVals)

folderOut = 'savedSpikeInfo';
makeDirectory(folderOut);

goodSpikeElectrodes = getGoodSpikeInfo(subjectName, expDate, protocolNames, folderData, badTrialNameStr, session, gridType, commonUnitFlag, cutoffVals);

fileSave = fullfile(folderOut, ...
    [protocolList '_' expDate ...
    'Cutoff--fr' num2str(cutoffVals(1)) ...
    'snr' num2str(cutoffVals(2)) ...
    'tspk' num2str(cutoffVals(3)) ...
    'absfr' num2str(cutoffVals(4)) '.mat']);
if exist(fileSave,'file')
    disp([fileSave ' exists. Quitting...']);
else
    save(fileSave, "goodSpikeElectrodes")
end

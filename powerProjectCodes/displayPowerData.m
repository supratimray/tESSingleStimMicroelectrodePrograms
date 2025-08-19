% Modified from displaySingleChannelGRFs

function displayPowerData(protocolListsToUse,removeStimProtocolFlag,session,cutoffVals)

% Hardcoded for simplicity
fValsUnique = [0.5 1 2 4]; % Spatial Frequency
oValsUnique = [0 45 90 135];  % Orientation
cValsUnique = [25 50 100]; % Contrast
stimulusPeriod = [0.25 0.75]; % For calculation of average firing rate

[colCode,titleString,stimblockID] = pickIDs(session);
protocolNameString = titleString; % Name of protocols
numProtocols = length(protocolNameString); % Total number of protocols
stimPos = stimblockID; % Protocol position(s) of stimulation

if removeStimProtocolFlag
    protocolNameString(stimPos) = [];
    colCode(stimPos) = [];
    numProtocols = length(protocolNameString);
end
colorNames = colCode;
colormap jet;

numLists = length(protocolListsToUse);

% Get fileNames
savedFileNames = getSavedDataFilenames(protocolListsToUse);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPlots       = numProtocols+1;
hSpikePlots    = getPlotHandles(numLists,numPlots,[0.025 0.670 0.75 0.15],0.002);
hTFPlots       = getPlotHandles(numLists,numPlots,[0.025 0.455 0.75 0.19],0.002);
hDeltaPSDPlots1 = getPlotHandles(numLists,numPlots,[0.025 0.24 0.75 0.19],0.002);
hDeltaPSDPlots2 = getPlotHandles(numLists,numPlots,[0.025 0.02 0.75 0.19],0.002);
hDeltaSpike    = getPlotHandles(1,1,[0.81 0.670 0.18 0.15],0.002,0.035,0);
hDeltaPower    = getPlotHandles(numLists+1,1,[0.81 0.025 0.18 0.62],0.03,0.035,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display main options
% fonts
fontSizeSmall = 10; fontSizeMedium = 12; fontSizeLarge = 16;

% Make Panels
panelHeight = 0.15; panelStartHeight = 0.85;
protocolPanelWidth = 0.25; protocolStartPos = 0.025;
ParameterPanelWidth = 0.25; parameterStartPos = 0.275;
rangesPanelWidth = 0.25; rangesStartPos = 0.525;
plotOptionsPanelWidth = 0.2; plotOptionsStartPos = 0.775;
backgroundColor = 'w';

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Protocol panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hProtocolPanel = uipanel('Title','Protocols','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[protocolStartPos panelStartHeight protocolPanelWidth panelHeight]);

hProtocolPanelList = cell(1,numLists);
for l=1:numLists
    hProtocolPanelList{l} = uicontrol('Parent',hProtocolPanel,'Unit','Normalized', ...
        'BackgroundColor', backgroundColor, 'Position', [0 (1 - l/numLists) 1 1/numLists], ...
        'Style','popup','String',savedFileNames{l},'FontSize',fontSizeSmall);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hParameterPanel = uipanel('Title','Parameters','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[parameterStartPos panelStartHeight ParameterPanelWidth panelHeight]);

% Spatial Frequency
spatialFreqString = getStringFromValues(fValsUnique,1);
uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'Position',[0 0.75 0.6 0.25], ...
    'Style','text','String','Spatial Freq (CPD)','FontSize',fontSizeMedium);
hSpatialFreq = uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', [0.6 0.75 0.4 0.25], ...
    'Style','popup','String',spatialFreqString,'FontSize',fontSizeSmall);

% Orientation
orientationString = getStringFromValues(oValsUnique,1);
uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'Position',[0 0.5 0.6 0.25], ...
    'Style','text','String','Orientation (Deg)','FontSize',fontSizeMedium);
hOrientation = uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', [0.6 0.5 0.4 0.25], ...
    'Style','popup','String',orientationString,'FontSize',fontSizeSmall);

% Contrast
contrastString = getStringFromValues(cValsUnique,1);
uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'Position',[0 0.25 0.6 0.25], ...
    'Style','text','String','Contrast (%)','FontSize',fontSizeMedium);
hContrast = uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', [0.6 0.25 0.4 0.25], ...
    'Style','popup','String',contrastString,'FontSize',fontSizeSmall);

hRemoveERP = uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position',[0 0 1/3 0.25], ...
    'Style','togglebutton','String','remove ERP','FontSize',fontSizeMedium);

hNormalize = uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[1/3 0 1/3 0.25], ...
    'Style','togglebutton','String','Normalize','FontSize',fontSizeMedium);

hDiffMode = uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[2/3 0 1/3 0.25], ...
    'Style','togglebutton','String','DiffMode','FontSize',fontSizeMedium);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ranges panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rangesHeight = 0.25; rangesTextWidth = 0.5; rangesBoxWidth = 0.25;
hRangesPanel = uipanel('Title','Ranges','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[rangesStartPos panelStartHeight rangesPanelWidth panelHeight]);

stimRange = [-0.2 1];
fftRange = [0 100];

% Stim Range
uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'Position',[0 1-rangesHeight rangesTextWidth rangesHeight], ...
    'Style','text','String','Stim Range (s)','FontSize',fontSizeSmall);
hStimMin = uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[rangesTextWidth 1-rangesHeight rangesBoxWidth rangesHeight], ...
    'Style','edit','String',num2str(stimRange(1)),'FontSize',fontSizeSmall);
hStimMax = uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[rangesTextWidth+rangesBoxWidth 1-rangesHeight rangesBoxWidth rangesHeight], ...
    'Style','edit','String',num2str(stimRange(2)),'FontSize',fontSizeSmall);

% FFT Range
uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'Position',[0 1-2*rangesHeight rangesTextWidth rangesHeight], ...
    'Style','text','String','FFT Range (Hz)','FontSize',fontSizeSmall);
hFFTMin = uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[rangesTextWidth 1-2*rangesHeight rangesBoxWidth rangesHeight], ...
    'Style','edit','String',num2str(fftRange(1)),'FontSize',fontSizeSmall);
hFFTMax = uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[rangesTextWidth+rangesBoxWidth 1-2*rangesHeight rangesBoxWidth rangesHeight], ...
    'Style','edit','String',num2str(fftRange(2)),'FontSize',fontSizeSmall);

% Z Range
uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'Position',[0 1-3*rangesHeight rangesTextWidth rangesHeight], ...
    'Style','text','String','Z Range','FontSize',fontSizeSmall);
hZMin = uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[rangesTextWidth 1-3*rangesHeight rangesBoxWidth rangesHeight], ...
    'Style','edit','String','0','FontSize',fontSizeSmall);
hZMax = uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[rangesTextWidth+rangesBoxWidth 1-3*rangesHeight rangesBoxWidth rangesHeight], ...
    'Style','edit','String','1','FontSize',fontSizeSmall);

% Power Range
uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'Position',[0 1-4*rangesHeight rangesTextWidth rangesHeight], ...
    'Style','text','String','Power Range (Hz)','FontSize',fontSizeSmall);
hPowerMin = uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[rangesTextWidth 1-4*rangesHeight rangesBoxWidth rangesHeight], ...
    'Style','edit','String','20','FontSize',fontSizeSmall);
hPowerMax = uicontrol('Parent',hRangesPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[rangesTextWidth+rangesBoxWidth 1-4*rangesHeight rangesBoxWidth rangesHeight], ...
    'Style','edit','String','35','FontSize',fontSizeSmall);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotOptionsHeight = 0.25;
hPlotOptionsPanel = uipanel('Title','Plotting Options','fontSize', fontSizeLarge, ...
    'Unit','Normalized','Position',[plotOptionsStartPos panelStartHeight plotOptionsPanelWidth panelHeight]);

uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 3*plotOptionsHeight 1 plotOptionsHeight], ...
    'Style','pushbutton','String','cla','FontSize',fontSizeMedium, ...
    'Callback',{@cla_Callback});

uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 2*plotOptionsHeight 1 plotOptionsHeight], ...
    'Style','pushbutton','String','rescale Z','FontSize',fontSizeMedium, ...
    'Callback',{@rescaleZ_Callback});

uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 1*plotOptionsHeight 1 plotOptionsHeight], ...
    'Style','pushbutton','String','Rescale','FontSize',fontSizeMedium, ...
    'Callback',{@rescaleData_Callback});

uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
    'Position',[0 0 1 plotOptionsHeight], ...
    'Style','pushbutton','String','plot','FontSize',fontSizeMedium, ...
    'Callback',{@plotData_Callback});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functions
    function plotData_Callback(~,~)

        % Get protocol details
        savedFileName = cell(1,numLists);
        for i=1:numLists
            savedFileName{i}=savedFileNames{i}{get(hProtocolPanelList{i},'val')};
        end

        f=get(hSpatialFreq,'val');
        o=get(hOrientation,'val');
        c=get(hContrast,'val');
        removeERPFlag = get(hRemoveERP,'val');
        normalizeFlag = get(hNormalize,'val');
        diffModeFlag = get(hDiffMode,'val');

        stimRange = [str2double(get(hStimMin,'String')) str2double(get(hStimMax,'String'))];
        fftRange = [str2double(get(hFFTMin,'String')) str2double(get(hFFTMax,'String'))];
        powerRange = [str2double(get(hPowerMin,'String')) str2double(get(hPowerMax,'String'))];

        % Get Data
        data = getSavedData(savedFileName,f,o,c,removeERPFlag,powerRange,stimulusPeriod,removeStimProtocolFlag,stimPos,savedFileNames,cutoffVals);

        if normalizeFlag
            data = normalizeData(data); % Option to normalize the firing rates
        end

        % Plot Data
        powerDataToPlot = cell(1,numLists);

        for ii=1:numLists
            dataOut = data{ii}.dataOut;
            
            for i=1:numProtocols
                plotColor = colorNames{1,i}{1,1};

                % Spikes
                plot(hSpikePlots(ii,i),dataOut{i}.frTimeVals,squeeze(mean(data{ii}.goodFRVals(:,i,:),1)),'color',plotColor);
                plot(hSpikePlots(ii,numPlots),dataOut{i}.frTimeVals,squeeze(mean(data{ii}.goodFRVals(:,i,:),1)),'color',plotColor);
                hold(hSpikePlots(ii,numPlots),'on');

                % deltaTF
                if diffModeFlag
                    pcolor(hTFPlots(ii,i),dataOut{i}.timeTF,dataOut{i}.freqTF,dataOut{i}.deltaTF' - dataOut{1}.deltaTF');
                else
                    pcolor(hTFPlots(ii,i),dataOut{i}.timeTF,dataOut{i}.freqTF,dataOut{i}.deltaTF');
                end
                shading(hTFPlots(ii,i),'interp');

                % DeltaPSD1
                plot(hDeltaPSDPlots1(ii,i),dataOut{i}.freqBL,dataOut{i}.deltaPSD,'color',plotColor);
                hold(hDeltaPSDPlots1(ii,i),'on');
                plot(hDeltaPSDPlots1(ii,i),dataOut{i}.freqBL,zeros(1,length(dataOut{i}.freqBL)),'color','k','linestyle','--');

                plot(hDeltaPSDPlots1(ii,numPlots),dataOut{i}.freqBL,dataOut{i}.deltaPSD,'color',plotColor);
                hold(hDeltaPSDPlots1(ii,numPlots),'on');

                % DeltaPSD2
                dataToPlot = squeeze(data{ii}.logDeltaPSD(:,i,:) - data{ii}.logDeltaPSD(:,1,:)); % Change in deltaPSD from the first one

                displayMeanSEMSignificance(hDeltaPSDPlots2(ii,i),dataToPlot,dataOut{i}.freqBL,plotColor,1,[-2.5 2.5]); % Plot mean and SEM
                plot(hDeltaPSDPlots2(ii,i),dataOut{i}.freqBL,zeros(1,length(dataOut{i}.freqBL)),'color','k','linestyle','--');

                displayMeanSEMSignificance(hDeltaPSDPlots2(ii,numPlots),dataToPlot,dataOut{i}.freqBL,plotColor,0); % Plot mean and SEM
            end
            ylabel(hSpikePlots(1,1),'Firing Rate',FontWeight='bold',FontSize=7.5);
            ylabel(hTFPlots(1,1),'Hz',FontWeight='bold',FontSize=7.5);
            ylabel(hDeltaPSDPlots1(1,1),'dB',FontWeight='bold',FontSize=7.5);
            ylabel(hDeltaPSDPlots2(1,1),'dB',FontWeight='bold',FontSize=7.5);

            plot(hDeltaPSDPlots1(ii,numPlots),dataOut{i}.freqBL,zeros(1,length(dataOut{i}.freqBL)),'color','k','linestyle','--');
            plot(hDeltaPSDPlots2(ii,numPlots),dataOut{i}.freqBL,zeros(1,length(dataOut{i}.freqBL)),'color','k','linestyle','--');

            % Power plot and spike data collection
            tmp = data{ii}.logDeltaPower; % Change in power for all protocols
            if diffModeFlag
                powerDataToPlot{ii} = tmp - repmat(tmp(:,1),1,numProtocols); % Change in power relative to the first condition
                yRange = [-4 4];
            else
                powerDataToPlot{ii} = tmp;
                yRange = [-2 14];
            end
            displayViolins(hDeltaPower(ii),powerDataToPlot{ii},colorNames,10,yRange);% Plots Violins
        end
        displayMeanSEMSignificance2(hDeltaSpike(1),data{1}.meanSpikeCount,data{2}.meanSpikeCount,1:numProtocols,1,protocolNameString);% Plots delta line plots for Spikes
        displayMeanSEMSignificance2(hDeltaPower(numLists+1),powerDataToPlot{1},powerDataToPlot{2},1:numProtocols,1,protocolNameString);% Plots delta line plots for Power

        % Rescale
        rescaleData(hSpikePlots,stimRange,getYLims(hSpikePlots));
        rescaleData(hTFPlots,stimRange,fftRange);
        zRange = getZLims(hTFPlots);
        set(hZMin,'String',num2str(zRange(1))); set(hZMax,'String',num2str(zRange(2)));
        rescaleZPlots(hTFPlots,zRange);
        rescaleData(hDeltaPSDPlots1,fftRange,getYLims(hDeltaPSDPlots1));
        rescaleData(hDeltaPSDPlots2,fftRange,getYLims(hDeltaPSDPlots2));

        for i=1:numProtocols
            title(hSpikePlots(1,i),protocolNameString{i});
            for cnd=1:2
                subplot(hTFPlots(cnd,i))
                yline(powerRange,LineWidth=1.5,LineStyle="--",FontWeight="bold")
            end
        end
        for cnd =1:2
            subplot(hDeltaPSDPlots1(cnd,numProtocols+1))
            xline(powerRange,LineWidth=1.5,LineStyle="--",FontWeight="bold")
            subplot(hDeltaPSDPlots2(cnd,numProtocols+1))
            xline(powerRange,LineWidth=1.5,LineStyle="--",FontWeight="bold")
        end
    end
    function rescaleZ_Callback(~,~)
        zRange = [str2double(get(hZMin,'String')) str2double(get(hZMax,'String'))];
        rescaleZPlots(hTFPlots,zRange);
    end
    function rescaleData_Callback(~,~)

        stimRange = [str2double(get(hStimMin,'String')) str2double(get(hStimMax,'String'))];
        fftRange = [str2double(get(hFFTMin,'String')) str2double(get(hFFTMax,'String'))];

        rescaleData(hSpikePlots,stimRange,getYLims(hSpikePlots));
        rescaleData(hTFPlots,stimRange,fftRange);
        rescaleData(hDeltaPSDPlots1,fftRange,getYLims(hDeltaPSDPlots));
        rescaleData(hDeltaPSDPlots2,fftRange,getYLims(hDeltaPSDPlots));
    end
    function cla_Callback(~,~)
        claGivenPlotHandle(hSpikePlots);
        claGivenPlotHandle(hTFPlots);
        claGivenPlotHandle(hDeltaPSDPlots1);
        claGivenPlotHandle(hDeltaPSDPlots2);
        claGivenPlotHandle(hDeltaPower);
        claGivenPlotHandle(hDeltaSpike);
        delete(findall(gcf,'type','text'));

        function claGivenPlotHandle(plotHandles)
            [numRows,numCols] = size(plotHandles);
            for i=1:numRows
                for j=1:numCols
                    cla(plotHandles(i,j));
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yLims = getYLims(plotHandles)

[numRows,numCols] = size(plotHandles);
% Initialize
yMin = inf;
yMax = -inf;

for row=1:numRows
    for column=1:numCols
        % get positions
        axis(plotHandles(row,column),'tight');
        tmpAxisVals = axis(plotHandles(row,column));
        if tmpAxisVals(3) < yMin
            yMin = tmpAxisVals(3);
        end
        if tmpAxisVals(4) > yMax
            yMax = tmpAxisVals(4);
        end
    end
end

yLims=[yMin yMax];
end
function zLims = getZLims(plotHandles)

[numRows,numCols] = size(plotHandles);
% Initialize
zMin = inf;
zMax = -inf;

for row=1:numRows
    for column=1:numCols
        % get positions
        tmpAxisVals = clim(plotHandles(row,column));
        if tmpAxisVals(1) < zMin
            zMin = tmpAxisVals(1);
        end
        if tmpAxisVals(2) > zMax
            zMax = tmpAxisVals(2);
        end
    end
end

zLims=[zMin zMax];
end
function rescaleData(plotHandles,xLims,yLims)

[numRows,numCols] = size(plotHandles);
labelSize=7.5;
for i=1:numRows
    for j=1:numCols
        axis(plotHandles(i,j),[xLims yLims]);
        set(plotHandles(i,j),'FontWeight','bold')
        if i==numRows
            if j~=1
                set(plotHandles(i,j),'YTickLabel',[],'fontSize',labelSize);
            end
        else
            set(plotHandles(i,j),'XTickLabel',[],'YTickLabel',[],'fontSize',labelSize);
        end
    end
end
end
function rescaleZPlots(plotHandles,zLims)
[numRow,numCol] = size(plotHandles);

for i=1:numRow
    for j=1:numCol
        clim(plotHandles(i,j),zLims);
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outString = getStringFromValues(valsUnique,decimationFactor)

if length(valsUnique)==1
    outString = convertNumToStr(valsUnique(1),decimationFactor);
else
    outString='';
    for i=1:length(valsUnique)
        outString = cat(2,outString,[convertNumToStr(valsUnique(i),decimationFactor) '|']);
    end
    outString = [outString 'all'];
end

    function str = convertNumToStr(num,f)
        if num > 16384
            num=num-32768;
        end
        str = num2str(num/f);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%c%%%%%%%%%
% load or Get Data
function combinedData = combineData(dataIn)
numExperiments = length(dataIn);

% Average across experiments (these are already averaged across electrodes)
numProtocols = length(dataIn{1}.dataOut);

% Assumed to be the same for all
tmpDataOut.timeVals = dataIn{1}.dataOut{1}.timeVals;
tmpDataOut.frTimeVals = dataIn{1}.dataOut{1}.frTimeVals;
tmpDataOut.timeTF = dataIn{1}.dataOut{1}.timeTF;
tmpDataOut.freqTF = dataIn{1}.dataOut{1}.freqTF;
tmpDataOut.freqBL = dataIn{1}.dataOut{1}.freqBL;
tmpDataOut.freqST = dataIn{1}.dataOut{1}.freqST;

for i=1:numProtocols
    frVals = []; deltaTF = []; SBL = []; SST = []; deltaPSD = []; totalE = 0;
    for j=1:numExperiments
        numE = length(dataIn{j}.goodLFPElectrodes);
        tmp = dataIn{j}.dataOut{i};
        frVals = cat(1,frVals,numE*tmp.frVals);
        deltaTF = cat(3,deltaTF,numE*tmp.deltaTF);
        SBL = cat(1,SBL,numE*tmp.SBL);
        SST = cat(1,SST,numE*tmp.SST);
        deltaPSD = cat(1,deltaPSD,numE*tmp.deltaPSD);
        totalE = totalE + numE;
    end

    tmpDataOut.frVals = sum(frVals,1)/totalE;
    tmpDataOut.deltaTF = sum(deltaTF,3)/totalE;
    tmpDataOut.SBL = sum(SBL,1)/totalE;
    tmpDataOut.SST = sum(SST,1)/totalE;
    tmpDataOut.deltaPSD = sum(deltaPSD,1)/totalE;

    combinedData.dataOut{i} = tmpDataOut;
end

% Concatenate across experiments (these are not averaged across electrodes)
combinedData.goodLFPElectrodes = [];
combinedData.goodSpikeElectrodes = [];
combinedData.logDeltaPSD = [];
combinedData.logDeltaPower = [];
combinedData.meanSpikeCount = [];
combinedData.goodFRVals = [];

for i=1:numExperiments
    combinedData.goodLFPElectrodes = cat(2,combinedData.goodLFPElectrodes,dataIn{i}.goodLFPElectrodes);
    combinedData.logDeltaPSD = cat(1,combinedData.logDeltaPSD,dataIn{i}.logDeltaPSD);
    combinedData.logDeltaPower = cat(1,combinedData.logDeltaPower,dataIn{i}.logDeltaPower);

    combinedData.goodSpikeElectrodes = cat(2,combinedData.goodSpikeElectrodes,dataIn{i}.goodSpikeElectrodes);
    combinedData.meanSpikeCount = cat(1,combinedData.meanSpikeCount,dataIn{i}.meanSpikeCount);
    combinedData.goodFRVals = cat(1,combinedData.goodFRVals,dataIn{i}.goodFRVals);
end

end
function dataOut = getSavedData(savedFileName,f,o,c,removeERPFlag,powerRange,stimulusPeriod,removeStimProtocolFlag,stimPos,savedFileNames,cutoffVals)
numLists = length(savedFileName);

dataOut = cell(1,numLists);
for i=1:numLists
    if strcmp(savedFileName{i},'all')
        tmp = getSavedDataSingleProtocol(savedFileNames{i}(1:end-1),f,o,c,removeERPFlag,powerRange,stimulusPeriod,removeStimProtocolFlag,stimPos,cutoffVals); % get data from all except the last one which is 'all'
        dataOut{i} = combineData(tmp);
    else
        tmp = getSavedDataSingleProtocol(savedFileName(i),f,o,c,removeERPFlag,powerRange,stimulusPeriod,removeStimProtocolFlag,stimPos,cutoffVals);
        dataOut{i} = tmp{1};
    end
end
end
function dataOut = getSavedDataSingleProtocol(savedFileName,f,o,c,removeERPFlag,powerRange,stimulusPeriod,removeStimProtocolFlag,stimPos,cutoffVals)
numLists = length(savedFileName);
folderOut = 'savedData';
folderOutSpike = 'savedSpikeInfo';

dataOut = cell(1,numLists);
for i=1:numLists
    fileSave = fullfile(folderOut,[savedFileName{i} '_f' num2str(f) 'o' num2str(o) 'c' num2str(c) '_removeERP' num2str(removeERPFlag) '.mat']);
    fileSaveSpikeInfo = fullfile(folderOutSpike, [savedFileName{i} 'Cutoff--fr' num2str(cutoffVals(1)) 'snr' num2str(cutoffVals(2)) 'tspk' num2str(cutoffVals(3)) 'absfr' num2str(cutoffVals(4)) '.mat']);
    if exist(fileSave,'file')
        data = load(fileSave);
        if removeStimProtocolFlag
            data.dataOut(stimPos) = [];
            data.dataOutShort(:,stimPos) = [];
        end
    else
        disp([fileSave ' does not exist']);
        data = [];
    end
    if exist(fileSaveSpikeInfo,'file')
        spikeInfo=load(fileSaveSpikeInfo);
        data.goodSpikeElectrodes = intersect(spikeInfo.goodSpikeElectrodes,data.goodLFPElectrodes);
    else
        disp([fileSaveSpikeInfo ' does not exist. Taking all LFP electrodes for spike analysis']);
        data.goodSpikeElectrodes = data.goodLFPElectrodes;
    end

    dataOut{i} = data;

    % Get relevant values for individual electrodes
    freqVals = data.dataOut{1}.freqST;
    goodFreqPos = getGoodFreqPos(freqVals,powerRange);
    timePos = data.dataOut{1}.frTimeVals;
    goodTimePosFR = find(timePos>=stimulusPeriod(1) & timePos<=stimulusPeriod(2));

    numFreqPos = length(freqVals);
    [numElectrodes,numProtocols] = size(data.dataOutShort);

    logDeltaPSD = zeros(numElectrodes,numProtocols,numFreqPos);
    logDeltaPower = zeros(numElectrodes,numProtocols);

    for j=1:numElectrodes
        for k=1:numProtocols
            tmp = data.dataOutShort{j,k};
            logDeltaPSD(j,k,:) = 10*(log10(tmp.SST) - log10(tmp.SBL));
            logDeltaPower(j,k) = 10*(log10(mean(tmp.SST(goodFreqPos))) - log10(mean(tmp.SBL(goodFreqPos))));
        end
    end

    numSpikeElectrodes = length(data.goodSpikeElectrodes);
    meanSpikeCount = zeros(numSpikeElectrodes,numProtocols);
    goodFRVals = zeros(numSpikeElectrodes,numProtocols,length(tmp.frVals));

    for j=1:numSpikeElectrodes
        for k=1:numProtocols
            tmp = data.dataOutShort{data.goodSpikeElectrodes(j)==data.goodLFPElectrodes,k};
            meanSpikeCount(j,k) = mean(tmp.frVals(goodTimePosFR),2)/diff(stimulusPeriod);
            goodFRVals(j,k,:) = tmp.frVals;
        end
    end

    dataOut{i}.logDeltaPSD = logDeltaPSD;
    dataOut{i}.logDeltaPower = logDeltaPower;
    dataOut{i}.meanSpikeCount = meanSpikeCount;
    dataOut{i}.goodFRVals = goodFRVals;
end
end
function goodFreqPos = getGoodFreqPos(freqVals,powerRange)
lineNoiseRange = [48 52];
badFreqPos = intersect(find(freqVals>=lineNoiseRange(1)),find(freqVals<=lineNoiseRange(2)));
goodFreqPos = setdiff(intersect(find(freqVals>=powerRange(1)),find(freqVals<=powerRange(2))),badFreqPos);
end
function savedFileNames = getSavedDataFilenames(protocolListsToUse)

numLists = length(protocolListsToUse);
savedFileNames = cell(1,numLists);

for i=1:numLists
    tmpProtocolListsToUse = protocolListsToUse{i};

    fileNameList = [];
    for j=1:length(tmpProtocolListsToUse)

        expDatesAll = getProtocolListDetails(tmpProtocolListsToUse{j});
        uniqueExpDates = unique(expDatesAll,'stable');
        numUniqueExpDates = length(uniqueExpDates);

        for k=1:numUniqueExpDates
            fileNameList = cat(2,fileNameList,{[tmpProtocolListsToUse{j} '_' uniqueExpDates{k}]});
        end
    end
    fileNameList = cat(2,fileNameList,{'all'});
    savedFileNames{i} = fileNameList;
end
end
function dataOut = normalizeData(dataIn)

numLists = length(dataIn);
dataOut = cell(1,numLists);

for i=1:numLists
    tmpDataOut = dataIn{i};

    meanSpikeCount = zeros(size(dataIn{i}.meanSpikeCount));
    goodFRVals = zeros(size(dataIn{i}.goodFRVals));
    numSpikeElectrodes = size(dataIn{i}.meanSpikeCount,1);

    for j=1:numSpikeElectrodes
        tmpSpikeCount = squeeze(dataIn{i}.meanSpikeCount(j,:));
        maxSpikeCount = max(1,max(tmpSpikeCount)); % no normalization if max value is less than 1
        meanSpikeCount(j,:) = tmpSpikeCount/maxSpikeCount;

        tmpFRVals = squeeze(dataIn{i}.goodFRVals(j,:,:));
        maxFRVal = max(1,max(tmpFRVals(:))); % no normalization if max firing rate is less than 1
        goodFRVals(j,:,:) = tmpFRVals/maxFRVal;
    end

    tmpDataOut.meanSpikeCount = meanSpikeCount;
    tmpDataOut.goodFRVals = goodFRVals;

    dataOut{i} = tmpDataOut;
end
end
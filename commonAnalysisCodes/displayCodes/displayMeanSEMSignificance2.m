function displayMeanSEMSignificance2(hPlot,data1,data2,xs,displaySignificanceFlag,protocolNameString)
% This function has pre-condition subtracted power as inputs
% data1: Stim protocol data
% data2: Sham protocol data
% xs: protocol numbers

if ~exist('displaySignificanceFlag','var'); displaySignificanceFlag=0; end

% First, subtract the first column (pre-stim condition) to account for
% absolute differences in firing rate/power
numProtocols = size(data1,2);
data1 = data1 - repmat(data1(:,1),1,numProtocols);
data2 = data2 - repmat(data2(:,1),1,numProtocols);

% Means and standard errors
mStim = mean(data1,1); sStim = std(data1,[],1)/sqrt(size(data1,1));
mSham = mean(data2,1); sSham = std(data2,[],1)/sqrt(size(data2,1));
mDiff = mStim - mSham; sDiff = (sStim + sSham)/2; % Take the average of the standard errors

pValues = zeros(1,numProtocols); 
hStats = zeros(1,numProtocols); 

for iProt = 1:numProtocols
    stimSet = data1(:,iProt);
    shamSet = data2(:,iProt);

    % Perform a two-sample independent t-test.
    % 'Vartype','unequal' handles cases with unequal variances.
    % The test checks if the mean of stimSet is different from the mean of shamSet.
    [h,p] = ttest2(stimSet, shamSet, 'Vartype', 'unequal');
    hStats(iProt) = h;
    pValues(iProt) = p;
end

% Plotting Mean and SEM %
subplot(hPlot);
hold(hPlot,'on');
errorbar(xs, mStim, sStim,'CapSize', 4, 'LineWidth', 0.5, 'Color', 'r');
errorbar(xs, mSham, sSham,'CapSize', 4, 'LineWidth', 0.5, 'Color', 'b');
errorbar(xs, mDiff, sDiff,'CapSize', 4, 'LineWidth', 2, 'Color', 'g');
axis tight;
xlim(hPlot,[0 length(xs)+1]);
set(hPlot,'XTick',1:length(xs));
xticklabels(protocolNameString);
Xax=gca().XAxis;
Yax=gca().YAxis;
yMin = min(-1.2,Yax.Limits(1)); yMax = max(1.2,Yax.Limits(2));
ylim([yMin yMax]);
set(gca,'FontWeight','bold');
set(Xax,'FontSize',9);
set(Yax,'FontSize',9);

% Put number of units/electrodes
text(0,1,append('n=',num2str(size(data1,1))),'color','r','fontWeight','bold',HandleVisibility='off'); hold on
text(0,0,append('n=',num2str(size(data2,1))),'color','b','fontWeight','bold',HandleVisibility='off'); hold on

% Plotting Significance Stars %
if displaySignificanceFlag
    Xcentres = 1:length(xs);
    
    for d = 1:length(xs)
        % Plot stars based on the corrected independent t-test on raw data
        if hStats(d) == 1
            subplot(hPlot);
            ypoint = mDiff(d);
            
            % Plot stars based on p-values from the ttest2.
            if pValues(d) < 0.0005
                text(Xcentres(:,d)-0.3, ypoint+0.8,'\ast\ast\ast','fontWeight','bold',HandleVisibility='off'); hold on
            elseif pValues(d) < 0.005
                text(Xcentres(:,d)-0.2, ypoint+0.8,'\ast\ast','fontWeight','bold',HandleVisibility='off'); hold on
            elseif pValues(d) < 0.05
                text(Xcentres(:,d)-0.1, ypoint+0.8,'\ast','fontWeight','bold',HandleVisibility='off'); hold on
            end
        end
    end
    grid on
    box on
    title(hPlot,'Stim - Sham','FontSize',9,'FontWeight','bold');
end
end
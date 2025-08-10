function displayMeanSEMSignificance2(hPlot,data1,data2,xs,displaySignificanceFlag,protocolNameString)
% This function has pre-condition subtracted power as inputs
% data1: Stim protocol data
% data2: Sham protocol data
% xs: protocol numbers

if ~exist('displaySignificanceFlag','var'); displaySignificanceFlag=0; end
yLims=[-1.2 1.2]; % Hardcoded y-axis limits

% Statistical Calculation & Data Preparation %
mData = cell(1,length(xs));
sData = cell(1,length(xs));
pValues = zeros(1,length(xs)); 
hStats = zeros(1,length(xs)); 

for iProt = 1:length(xs)
    stimSet = data1(:,iProt);
    shamSet = data2(:,iProt);
    
    % Get difference in means
    mData{iProt} = mean(stimSet) - mean(shamSet);
    
    % Calculate the standard error of the mean for the difference.
    n1 = numel(stimSet);
    n2 = numel(shamSet);
    s1 = var(stimSet);
    s2 = var(shamSet);
    sData{iProt} = sqrt(s1/n1 + s2/n2);
    
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
errorbar(xs, [mData{:}], [sData{:}],'CapSize', 4, 'LineWidth', 1.2, 'Color', 'r');
axis(hPlot,[[0 length(xs)+1]  yLims]);
set(hPlot,'XTick',1:length(xs));
xticklabels(protocolNameString);
Xax=gca().XAxis;
Yax=gca().YAxis;
set(gca,'FontWeight','bold');
set(Xax,'FontSize',9);
set(Yax,'FontSize',9);

% Put number of units/electrodes
ypoint=mData{end};
text(length(xs)-0.5,ypoint+1.0,append('n=',num2str(n1)),'fontWeight','bold',HandleVisibility='off'); hold on


% Plotting Significance Stars %
if displaySignificanceFlag
    Xcentres = 1:length(xs);
    
    for d = 1:length(xs)
        % Plot stars based on the corrected independent t-test on raw data
        if hStats(d) == 1
            subplot(hPlot);
            ypoint = mData{d};
            
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
    title(hPlot,'Stim - Sham','FontSize',9,'FontWeight','bold')
end
end

function displayMeanSEMSignificance(hPlot,data,xs,colorName,displaySignificanceFlag,yLims)

if ~exist('displaySignificanceFlag','var'); displaySignificanceFlag=0;  end
if ~exist('yLims','var');                   yLims=[];                   end

mData = mean(data,1); % Mean
sData = std(data,[],1)/sqrt(size(data,1)); % SEM

% Plot Mean and SEM
patch([xs';flipud(xs')],[mData'- sData';flipud(mData'+sData')],colorName,'linestyle','none','FaceAlpha',0.4,'Parent',hPlot);
hold(hPlot,'on');
plot(hPlot,xs, mData, 'color', colorName, 'linewidth', 1);

if displaySignificanceFlag
    if isempty(yLims)
        yLims = ylim(hPlot);
    end

    % Significance testing
    numPoints = size(data,2);
    for i=1:numPoints
        [~,p] = ttest(data(:,i));

        % Get patch coordinates
        yVals = yLims(1)+[0 0 diff(yLims)/20 diff(yLims)/20];

        clear xMidPos xBegPos xEndPos
        xMidPos = xs(i);
        if i==1
            xBegPos = xMidPos;
        else
            xBegPos = xMidPos-(xs(i)-xs(i-1))/2;
        end
        if i==length(xs)
            xEndPos = xMidPos;
        else
            xEndPos = xMidPos+(xs(i+1)-xs(i))/2;
        end
        clear xVals; xVals = [xBegPos xEndPos xEndPos xBegPos]';

        if (p<0.01) % 0.01 but uncorrected
            patch(xVals,yVals,[0.5 0.5 0.5],'linestyle','none','Parent',hPlot);
        end
        if (p<0.05/numPoints) % Bonferroni corrected
            patch(xVals,yVals,'k','linestyle','none','Parent',hPlot);
        end
    end
end
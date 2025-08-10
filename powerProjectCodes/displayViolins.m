function displayViolins(hPlot, data, colors)
% displayViolins - Violin + swarm + electrode trend lines, protocol colors, mean points + error bars
%
% Inputs:
%   hPlot   - subplot axes handle
%   data    - [nElecs x nProtocols] matrix
%   colors  - [nProtocols x 3] RGB and HEX colors per protocol

[nElecs, nProtocols] = size(data);
subplot(hPlot);
vp = violinplot(data);
hold on;

% Set violin face colors
for i = 1:nProtocols
    vp(i).FaceColor = colors{1,i}{1,1};
end

xPositions=cell(1,5);
% Swarmchart plots and color
for prot = 1:nProtocols
    hold on
    s = swarmchart(ones(nElecs, 1) * prot, data(:, prot),1.5,colors{1,prot}{1,1},'filled','MarkerFaceAlpha',0.3);
    pause(0.01)
    ss=struct(s);
    xPositions{prot} = ss.XYZJittered(:,[1 2]);  % Save actual jittered positions
end

% Connect each electrode's data points
lineColor = [0 0 0.2];
lineAlpha = 0.1;
for elec = 1:nElecs
    xVals = zeros(1, nProtocols);
    yVals = zeros(1, nProtocols);
    for prot = 1:nProtocols
        xVals(prot) = xPositions{prot}(elec, 1);
        yVals(prot) = xPositions{prot}(elec, 2);
    end
    plot(xVals, yVals, '-', 'Color', [lineColor, lineAlpha]);
end

%Plot mean & error bars for each protocol%
meanVals = mean(data, 1);
stderrVals = std(data, 0, 1) ./ sqrt(nElecs);  % standard error
meanColor = [0 0 0];  % black
% Connect mean values with a line
line(1:nProtocols, meanVals,'linewidth',1.5,'color','r');

% Plot error bars and mean points
for prot = 1:nProtocols
    % Center X coordinate (same as violin)
    x = prot;
    y = meanVals(prot);
    err = stderrVals(prot);
    % Error bar
    errorbar(x, y, err, 'k', 'CapSize', 6, 'LineWidth', 1.2, 'Color', meanColor);
    %Mean point
    plot(x, y, 'ko', 'MarkerFaceColor', meanColor, 'MarkerSize', 1.5);
end

% Aesthetics
ylim([-2 14])
set(hPlot,'YTick',[0 4 8 12]);
xticklabels([]);
Xax=gca().XAxis;
Yax=gca().YAxis;
set(gca,'FontWeight','bold');
set(Xax,'FontSize',10);
set(Yax,'FontSize',10);

ypoint=max(vp(nProtocols).EvaluationPoints);
text(nProtocols-0.5,ypoint+2.3,append('n=',num2str(nElecs)),'fontWeight','bold',HandleVisibility='off'); hold on

dStat=zeros(1,nProtocols-1);
% Stat test
for ProtN=2:nProtocols
    x1=data(:,1);% Post-Pre
    y1=data(:,ProtN);
    [h1,p1]=ttest(y1,x1); %This checks if gamma power in a protocol is significantly different than the pre-stim/sham protocol
    % [p1,h1]=ranksum(y1,x1); %This checks if gamma power in a protocol is significantly different than the pre-stim/sham protocol
    dStat(1,ProtN)=double(h1);
    dStat(2,ProtN)=p1;
end

% Plotting the significance star
Xcentres=1:nProtocols;
hold on
stat1=dStat(1,:);
stat2=dStat(2,:);
for d=1:nProtocols
    if stat1(1,d)==1
        hold on
        subplot(hPlot)
        ypoint=max(vp(d).EvaluationPoints);
        if ypoint<0
            if stat2(1,d)<0.0005
                text(Xcentres(:,d)-0.3,ypoint-0.15,'\ast\ast\ast','fontWeight','bold',HandleVisibility='off'); hold on
            elseif stat2(1,d)<0.005
                text(Xcentres(:,d)-0.2,ypoint-0.15,'\ast\ast','fontWeight','bold',HandleVisibility='off'); hold on
            elseif stat2(1,d)<0.05
                text(Xcentres(:,d)-0.1,ypoint-0.15,'\ast','fontWeight','bold',HandleVisibility='off'); hold on
            end
        elseif ypoint>0
            if stat2(1,d)<0.0005
                text(Xcentres(:,d)-0.3,ypoint+1.0,'\ast\ast\ast','fontWeight','bold',HandleVisibility='off'); hold on
            elseif stat2(1,d)<0.005
                text(Xcentres(:,d)-0.2,ypoint+1.0,'\ast\ast','fontWeight','bold',HandleVisibility='off'); hold on
            elseif stat2(1,d)<0.05
                text(Xcentres(:,d)-0.1,ypoint+1.0,'\ast','fontWeight','bold',HandleVisibility='off'); hold on
            end
        end
    end
end
grid on
box on
ylabel('dB','FontSize',10,'FontWeight','bold')
end

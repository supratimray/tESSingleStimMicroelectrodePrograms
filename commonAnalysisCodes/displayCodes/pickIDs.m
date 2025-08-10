%% This small code provides right color ID for different protocol, associated protocol type/title, and stimulation block ids

function [colCode,titleString,stimblockID]=pickIDs(session)

%% RGB codes
preStimCol{1,1} = [151 28 81]./255; %Wine Grape
stimCol1{1,1} = [255, 165, 0]./255;%orange-ish
postStimCol1{1,1} = [210 19 18]./255;%Red
postStimCol2{1,1} = [176 74 90]./255;%Carmine Pink
StimCol2{1,1}= [241, 196, 15]./255;%ButterCup
postStimCol3{1,1} = [8 48 35]./255;%Cyprus
check1Col{1,1} = [45 93 78]./255;%brunswick green
check2Col{1,1} = [94 141 37]./255;%Vida loca
check3Col{1,1} = [156 176 23]./255;%Stipule Green

%% HEX codes
preStimCol{1,2}="#971C51";% Wine Grape 151,28, 81
stimCol1{1,2}="#FFA500";%Orange-ish 255, 165, 0
postStimCol1{1,2}="#D21312";%Red 210, 19, 18
postStimCol2{1,2}="#B04A5A";%Carmine pink 176, 74, 90
StimCol2{1,2}="#F1C40F";%Buttercup 241, 196, 15
postStimCol3{1,2}="#083023";%Cyprus 8, 48, 35
check1Col{1,2}="#2D5D4E"; %brunswick green 45, 93, 78
check2Col{1,2}="#5E8D25";%Vida loca 94, 141, 37
check3Col{1,2}="#9CB017";%Stipule Green 156, 176, 23

if strcmp(session,'single')
    colCode={preStimCol stimCol1 postStimCol3 check1Col check2Col check3Col};
    titleString={'Pre' 'Stim/Sham' 'Post' 'Post+30' 'Post+60' 'Post+90'};
    stimblockID=2;
elseif strcmp(session,'dual')
    colCode={preStimCol stimCol1 postStimCol1 StimCol2 postStimCol3 check1Col check2Col check3Col};
    titleString={'Pre' 'Stim/Sham' 'Post1' 'Stim/Sham' 'Post2' 'Post+30' 'Post+60' 'Post+90'};
    stimblockID=[2 4];
elseif strcmp(session,'dual60')
    colCode={preStimCol stimCol1 postStimCol1 postStimCol2 StimCol2 postStimCol3 check1Col check2Col check3Col};
    titleString={'Pre' 'Stim/Sham' 'Post1' 'Post2' 'Stim/Sham' 'Post' 'Post+30' 'Post+60' 'Post+90'};
    stimblockID=[2 5];
end



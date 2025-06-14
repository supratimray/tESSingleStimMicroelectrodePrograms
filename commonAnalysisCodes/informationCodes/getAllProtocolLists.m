function protocolLists = getAllProtocolLists(monkeyName)

protocolListBaseName{1} = 'tACS_Alpha';
protocolListBaseName{2} = 'tACS_SG';
protocolListBaseName{3} = 'tACS_FG';

protocolListBaseName{4} = 'tDCS_Cathodal';
protocolListBaseName{5} = 'tDCS_Anodal';

numBaseProtocols = length(protocolListBaseName);
protocolLists = cell(1,2*numBaseProtocols);

for i=1:numBaseProtocols
    protocolLists{2*i-1} = ['allProtocols' monkeyName protocolListBaseName{i} '_Stim_single'];
    protocolLists{2*i} = ['allProtocols' monkeyName protocolListBaseName{i} '_Sham_single'];
end
end
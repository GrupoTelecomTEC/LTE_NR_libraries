function [y, yPg] = MIMOFadingChan(in, prmNR, prmMdl)
% The function takes as input the generated OFDM signal (in)
% the structure containing the parameters of the PDSCH (prmLTE)
% and another structure containing parameters of the channel model (prmMdl)
% The output of the channel model (y) is the signal that arrives at the receiver.
% The second output (yPg) is a matrix containing the channel-path gains of the underlying fading process.
% MIMOFadingChan
%% codegen
% Get simulation params
persistent numTx numRx chanMdl chanSRate corrLvl
numTx = prmNR.numTx;
numRx = prmNR.numRx;
chanMdl = prmMdl.chanMdl;
chanSRate = prmNR.chanSRate;
corrLvl = prmMdl.corrLevel;
switch chanMdl
    case 'flat-low-mobility' 
        PathDelays = 0*(1/chanSRate); 
        PathGains = 0;
        Doppler=0;
        ChannelType =1;
    case 'flat-high-mobility' 
        PathDelays = 0*(1/chanSRate); 
        PathGains = 0;
        Doppler=70;
        ChannelType =1;
    case 'frequency-selective-low-mobility' 
        PathDelays = [0 10 20 30 100]*(1/chanSRate); 
        PathGains = [0 -3 -6 -8 -17.2];
        Doppler=0;
        ChannelType =1;
    case 'frequency-selective-high-mobility' 
        PathDelays = [0 10 20 30 100]*(1/chanSRate); 
        PathGains = [0 -3 -6 -8 -17.2];
        Doppler=70;
        ChannelType =1;
    case 'EPA 0Hz'
        PathDelays = [0 30 70 90 110 190 410]*1e-9; 
        PathGains = [0 -1 -2 -3 -8 -17.2 -20.8]; 
        Doppler=0;
        ChannelType =1;
    otherwise
        ChannelType =2;
        AntConfig=char([48+numTx,'x',48+numRx]); 
end
% Initialize objects
persistent chanObj; 
if isempty(chanObj)
    if ChannelType ==1
        chanObj = comm.MIMOChannel('SampleRate', chanSRate, ... 
            'MaximumDopplerShift', Doppler, ...
            'PathDelays', PathDelays,...
            'AveragePathGains', PathGains,...
            'RandomStream', 'mt19937ar with seed','Seed', 100,...
            'NumTransmitAntennas', numTx,... 
            'TransmitCorrelationMatrix', eye(numTx),... 
            'NumReceiveAntennas', numRx,... 
            'ReceiveCorrelationMatrix', eye(numRx),... 
            'PathGainsOutputPort', true,... 
            'NormalizePathGains', true,... 
            'NormalizeChannelOutputs', true);
    else
        chanObj = comm.LTEMIMOChannel('SampleRate', chanSRate, ...
            'Profile', chanMdl, ... 
            'AntennaConfiguration', AntConfig, ... 
            'CorrelationLevel', corrLvl,... 
            'RandomStream', 'mt19937ar with seed',... 
            'Seed', 100,...
            'PathGainsOutputPort', true);
    end
end
[y, yPg] = step(chanObj, in);
%% 5G New Radio Massive MIMO Channel estimation
% Downlink channel estimation

% New Radio (NR) frame parameters
% NR specifies minimum 20 RBs and maximum 275 RBs 
prmNR = struct('N', 512, 'cpLen0', 40, 'cpLenR', 36, ...
    'Nrb', 25, 'Nrb_sc', 12, 'Ndl_symb', 7, ...
    'numTx', 8, 'numRx', 8, 'chanSRate', (30.72e6/2048)*512);

%% Resource Grid configuration
K = prmNR.Nrb_sc*prmNR.Nrb; % Number of subcarriers
L = 14;                     % Number of OFDM symbols in one subframe
P = 1;                      % Number of transmit antenna ports
gridsize = [K, L, P];

% Number of bits needed is size of resource grid (K*L*P) * number of bits
% per symbol (2 for QPSK, 4 for QAM16, 6 for QAM64 and 8 for QAM256)
numberOfBits = K*L*P*2;

%% Downlink Demodulation Reference Symbols
% Pilot or resource symbols  over the channel will be QPSK modulated 
% symbols. A subframe worth of symbols is created so a symbol can be mapped 
% to every resource element.
source = [0; 0; 1; 0; 1; 1; 0; 1];
B = repmat(source, [300,1]);
dmrs = Modulator(B, 1);

%% Generate Resource block
% Create random bit stream
inputBits = randi([0 1], numberOfBits, 1);
bits = Modulator(inputBits, 1);
txGrid = reshape(bits, gridsize);

% 8 layer downlink resource elements
[x1_dl,x2_dl,x3_dl,x4_dl,x5_dl,x6_dl,x7_dl,x8_dl] = mapping(K, txGrid, dmrs);

%% CP-OFDM for 15 KHz spacing
txWaveform1 = OFDMTx(x1_dl, prmNR);
txWaveform2 = OFDMTx(x2_dl, prmNR);
txWaveform3 = OFDMTx(x3_dl, prmNR);
txWaveform4 = OFDMTx(x4_dl, prmNR);
txWaveform5 = OFDMTx(x5_dl, prmNR);
txWaveform6 = OFDMTx(x6_dl, prmNR);
txWaveform7 = OFDMTx(x7_dl, prmNR);
txWaveform8 = OFDMTx(x8_dl, prmNR);

avgTxPower1 =  (txWaveform1' * txWaveform1) / length(txWaveform1);
txWaveform1 = txWaveform1 / sqrt(avgTxPower1);
avgTxPower2 =  (txWaveform2' * txWaveform2) / length(txWaveform2);
txWaveform2 = txWaveform2 / sqrt(avgTxPower2);
avgTxPower3 =  (txWaveform3' * txWaveform3) / length(txWaveform3);
txWaveform3 = txWaveform3 / sqrt(avgTxPower3);
avgTxPower4 =  (txWaveform4' * txWaveform4) / length(txWaveform4);
txWaveform4 = txWaveform4 / sqrt(avgTxPower4);
avgTxPower5 =  (txWaveform5' * txWaveform5) / length(txWaveform5);
txWaveform5 = txWaveform5 / sqrt(avgTxPower5);
avgTxPower6 =  (txWaveform6' * txWaveform6) / length(txWaveform6);
txWaveform6 = txWaveform6 / sqrt(avgTxPower6);
avgTxPower7 =  (txWaveform7' * txWaveform7) / length(txWaveform7);
txWaveform7 = txWaveform7 / sqrt(avgTxPower7);
avgTxPower8 =  (txWaveform8' * txWaveform8) / length(txWaveform8);
txWaveform8 = txWaveform8 / sqrt(avgTxPower8);

SamplingRate = (30.72e6/2048)*prmNR.N;       % Sampling rate  

txWaveform = [txWaveform1 txWaveform2 txWaveform3 txWaveform4 ...
    txWaveform5 txWaveform6 txWaveform7 txWaveform8];

%% Massive MIMO channel settings 
prmMdl = struct('corrLevel', 'Medium', 'chanMdl', ...
    'frequency-selective-low-mobility');
[rxWaveformDL, rxWaveformDLPg] = MIMOFadingChan(txWaveform, prmNR, prmMdl);

%% SNR Configuration
% The operating SNR is configured in decibels by the value |SNRdB| which is
% also converted into a linear SINR.
sigPow = 10*log10(var(rxWaveformDL));
Eb_dB = mean(sigPow);      % Energy of received signal

SNRdB = 42;              % UE signal to noise ratio (dB) - Desired SNR in dB
SNR = 10^(SNRdB/20);    % Linear SNR 

nVarDL = 10.^(.1.*(sigPow - SNRdB));        % Noise variance
N0 = mean(nVarDL);                          % Noise power
N0_dB = pow2db(N0);                         % Noise power in dB

rxWaveform = AWGNChannel(rxWaveformDL, N0); 

avgRxPower = mean(abs(rxWaveform).^2);

y_dl = OFDMRx(rxWaveform,prmNR);

% Reshape received vectors
y1dl = y_dl(:,:,1); 
y2dl = y_dl(:,:,2); 
y3dl = y_dl(:,:,3); 
y4dl = y_dl(:,:,4); 
y5dl = y_dl(:,:,5);  
y6dl = y_dl(:,:,6); 
y7dl = y_dl(:,:,7); 
y8dl = y_dl(:,:,8); 

[hls11,hmmse11,hk11] = estimationI(y1dl(2:2:end,3), x1_dl(2:2:end,3), nVarDL(1,1));
[hls12,hmmse12,hk12] = estimationI(y1dl(2:2:end,12), x1_dl(2:2:end,3), nVarDL(1,1));
[hls21,hmmse21,hk21] = estimationI(y2dl(2:2:end,3), x2_dl(2:2:end,3), nVarDL(1,2));
[hls22,hmmse22,hk22] = estimationI(y2dl(2:2:end,12), x2_dl(2:2:end,3), nVarDL(1,2));
[hls31,hmmse31,hk31] = estimationI(y3dl(1:2:end,3), x3_dl(1:2:end,3), nVarDL(1,3));
[hls32,hmmse32,hk32] = estimationI(y3dl(1:2:end,12), x3_dl(1:2:end,3), nVarDL(1,3));
[hls41,hmmse41,hk41] = estimationI(y4dl(1:2:end,3), y4dl(1:2:end,3), nVarDL(1,4));
[hls42,hmmse42,hk42] = estimationI(y4dl(1:2:end,12), y4dl(1:2:end,3), nVarDL(1,4));
[hls51,hmmse51,hk51] = estimationI(y5dl(2:2:end,3), x5_dl(2:2:end,3), nVarDL(1,5));
[hls52,hmmse52,hk52] = estimationI(y5dl(2:2:end,12), x5_dl(2:2:end,3), nVarDL(1,5));
[hls61,hmmse61,hk61] = estimationI(y6dl(2:2:end,3), x6_dl(2:2:end,3), nVarDL(1,6));
[hls62,hmmse62,hk62] = estimationI(y6dl(2:2:end,12), x6_dl(2:2:end,3), nVarDL(1,6));
[hls71,hmmse71,hk71] = estimationI(y7dl(1:2:end,3), x7_dl(1:2:end,3), nVarDL(1,7));
[hls72,hmmse72,hk72] = estimationI(y7dl(1:2:end,12), x7_dl(1:2:end,3), nVarDL(1,7));
[hls81,hmmse81,hk81] = estimationI(y8dl(1:2:end,3), x8_dl(1:2:end,3), nVarDL(1,8));
[hls82,hmmse82,hk82] = estimationI(y8dl(1:2:end,12), x8_dl(1:2:end,3), nVarDL(1,8));

%% Channel equalization
[~, EqLS] = Equalizer(y1dl, [repmat(hls11, [1,7]) repmat(hls12, [1,7])], N0, 2);
[~, EqMMSE] = Equalizer(y1dl, [repmat(hmmse11, [1,7]) repmat(hmmse12, [1,7])], N0, 2);
[~, EqKF] = Equalizer(y1dl, [repmat(hk11, [1,7]) repmat(hk12, [1,7])], N0, 2);

lsPower = mean(abs(EqLS).^2);
mmsePower = mean(abs(EqMMSE).^2);
kfPower = mean(abs(EqKF).^2);

rxMMSE = zeros(size(EqLS,1), size(EqLS,2));
rxLS = rxMMSE; rxKF = rxMMSE;

for i=1:size(EqLS,2)
    rxMMSE(:,i) = EqMMSE(:,i) / sqrt(mmsePower(1,i));
    rxLS(:,i) = EqLS(:,i) / sqrt(lsPower(1,i));
    rxKF(:,i) = EqKF(:,i) / sqrt(kfPower(1,i));
end  



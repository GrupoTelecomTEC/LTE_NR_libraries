function [out, Kplus, C] = TbChannelCoding(in, prmLTE) 
% Transport block channel coding
%% codegen
inLen = size(in, 1);
[C, ~, Kplus] = CblkSegParams(inLen-24);
intrlvrIndices = lteIntrlvrIndices(Kplus);
G=prmLTE.maxG;
E_CB=CbBitSelection(C, G, prmLTE.NumLayers, prmLTE.Qm); 
% Initialize output
out = false(G, 1);
% Channel coding the TB
if (C==1) % single CB, no CB CRC used
    % Turbo encode
    tEncCbData = TurboEncoder( in, intrlvrIndices);
    % Rate matching, with bit selection
    rmCbData = RateMatcher(tEncCbData, Kplus, G);
    % unify code paths
    out = logical(rmCbData);
else % multiple CBs in TB
    startIdx = 0; 
    for cbIdx = 1:C
        % Code-block segmentation
        cbData = in((1:(Kplus-24)) + (cbIdx-1)*(Kplus-24));
        % Append checksum to each CB
        crcCbData = CbCRCGenerator( cbData);
        % Turbo encode each CB
        tEncCbData = TurboEncoder(crcCbData, intrlvrIndices);
        % Rate matching with bit selection
        E=E_CB(cbIdx);
        rmCbData = RateMatcher(tEncCbData, Kplus, E); 
        % Code-block concatenation
        out((1:E) + startIdx) = logical(rmCbData);
        startIdx = startIdx + E;
    end
end

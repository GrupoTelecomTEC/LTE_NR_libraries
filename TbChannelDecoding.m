function [decTbData, crcCbFlags, iters] = TbChannelDecoding( in, Kplus, C, prmLTE) 
% Transport block channel decoding.
%% codegen
intrlvrIndices = lteIntrlvrIndices(Kplus);
% Make fixed size
G=prmLTE.maxG;
E_CB=CbBitSelection(C, G, prmLTE.NumLayers, prmLTE.Qm); 
% Channel decoding the TB
if (C==1) % single CB, no CB CRC used
    % Rate dematching, with bit insertion
    deRMCbData = RateDematcher(-in, Kplus)
    % Turbo decode the single CB
    tDecCbData =TurboDecoder(deRMCbData, intrlvrIndices, prmLTE.maxIter) 
    % Unify code paths
    decTbData = logical(tDecCbData);
else % multiple CBs in TB
    decTbData = false((Kplus-24)*C,1); % Account for CB CRC bits 
    startIdx = 0;
    for cbIdx = 1:C
        % Code-block segmentation
        E=E_CB(cbIdx);
        rxCbData = in(dtIdx(1:E) + startIdx);
        startIdx = startIdx + E;
        % Rate dematching, with bit insertion
        % Flip input polarity to match decoder output bit mapping 
        deRMCbData = lteCbRateDematching(-rxCbData, Kplus, C, E);   
        % Turbo decode each CB with CRC detection
        % - uses early decoder termination at the CB level 
        [crcDetCbData, crcCbFlags(cbIdx), iters(cbIdx)] = ...
                TurboDecoder_crc(deRMCbData, intrlvrIndices);
        % Check the crcCBFlag per CB. If still in error, abort further TB
        % processing for remaining CBs in the TB, as the HARQ process will 
        % request retransmission for the whole TB.
        if (̃prmLTE.fullDecode)
            if (crcCbFlags(cbIdx)==1) % error 
                break;
            end
        end
        % Code-block concatention
        decTbData((1:(Kplus-24)) + (cbIdx-1)*(Kplus-24)) = logical(crcDetCbData);
    end
end

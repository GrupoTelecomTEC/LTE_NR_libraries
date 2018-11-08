function [y, flag, iters]=TurboDecoder_crc(u, intrlvrIndices) 
% The TurboDecoder_crc function operates on its first input signal (u),
% we need to specify the trellis structure of the constituent encoders 
% and the turbo code internal interleaver.
%% codegen
MAXITER=6;
persistent Turbo
if isempty(Turbo)
    Turbo = commLTETurboDecoder('InterleaverIndicesSource', 'Input port', ...
        'MaximumIterations', MAXITER);
end
[y, flag, iters] = step(Turbo, u, intrlvrIndices);

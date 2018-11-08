function y=TurboDecoder(u, intrlvrIndices, maxIter) 
% The TurboDecoder function operates on its first input signal (u),
% The function also takes as inputs the interleaving indices (intrlvrIndices)
% and the maximum number of iterations used in the decoder (maxIter).
%% codegen
persistent Turbo
if isempty(Turbo)
Turbo = comm.TurboDecoder('TrellisStructure', poly2trellis(4, [13 15], 13),... 'InterleaverIndicesSource','Input port', ...
'NumIterations', maxIter);
end
y=step(Turbo, u, intrlvrIndices);

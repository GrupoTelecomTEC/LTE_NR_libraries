function y=TurboEncoder(u, intrlvrIndices) 
% The TurboEncoder function operates on its first input signal (u),
% we need to specify the trellis structure of the constituent encoders 
% and the turbo code internal interleaver.
%% codegen
persistent Turbo
if isempty(Turbo)
    Turbo = comm.TurboEncoder('TrellisStructure', poly2trellis(4, [13 15], 13), ... 
        'InterleaverIndicesSource','Input port');
end
y=step(Turbo, u, intrlvrIndices);
function y = AWGNChannel(u, noiseVar ) 
% It applies an AWGN to its first input signal (u)
% based on the value of the noise power (noiseVar) 
%% Initialization
persistent AWGN
if isempty(AWGN)
    AWGN = comm.AWGNChannel('NoiseMethod', 'Variance', ...
    'VarianceSource', 'Input port'); 
end
y = step(AWGN, u, noiseVar);
end


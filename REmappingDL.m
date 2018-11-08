function txGrid = REmappingDL(txGrid,dmrs,K)
% This function maps the dmrs symbols into the the transmited grid (txGrid)
% demodulation reference symbols (dmrs) 
% number of subcarriers (K)
%% Resource element mapping
for i = 2:2:K
    txGrid(i,3) = dmrs(i/2,1);
end

for i = 1:2:K
    % Spectral Nulls
    txGrid(i,3) = 0;
end

end

function txGrid = REmappingUL(txGrid,dmrs,K)
% This function maps the dmrs symbols into the the transmited grid (txGrid)
% demodulation reference symbols (dmrs) 
% number of subcarriers (K)
%% Resource element mapping
% for i = 2:2:K
%     txGrid(i,3) = dmrs(i/2,1);
% end
for i = 1:K
    txGrid(i,3) = dmrs(i,1);
end

% for i = 1:K
%     txGrid(i,4) = dmrs(i,1);
%     txGrid(i,11) = dmrs(i,1);
% end


end


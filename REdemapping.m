function rx_dmrs = REdemapping(y)
% This function demaps the dmrs symbols from the received grid (rxGrid)
% CP-OFDM demodulated symbols (y) 
%% Resource element demmping
% persistent y_dmrs
% y_dmrs = zeros(size(y,1), size(y,3));
% 
% for j = 1:size(y,1)
%     for i = 1:size(y,3)
%         y_dmrs(j,i) = y(j,3,i);
%     end    
% end
% 
% rx_dmrs = zeros(size(y,1)/2, size(y,3));
% 
% for j = 1:size(y,1)/2
%     for i = 1:size(y,3)
%     rx_dmrs(j,i) = y_dmrs(j*2,i);
%     end
% end
% end

% persistent y_dmrs
rx_dmrs = zeros(size(y,1), size(y,3));

for j = 1:size(y,1)
    for i = 1:size(y,3)
        rx_dmrs(j,i) = y(j,3,i);
    end    
end
end
% rx_dmrs = zeros(size(y,1), size(y,3));
% 
% for j = 1:size(y,1)
%     for i = 1:size(y,3)
%     rx_dmrs(j,i) = y_dmrs(j,i);
%     end
% end
% end


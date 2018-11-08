function [hlsI,hmmseI,hkI] = Interpolate(rx_dmrs,hls,hmmse,hk)
% This function interpolates by a factor of 2 the channel estimates based 
% on LS, MMSE and KF
% received and demapped demodulation reference symbols (rx_dmrs)
% least squares channel estimation (hls)
% minimum mean sqared error channel estimation (hmmse)
% vector Kalman filtering channel estimation (hk)
%% Interpolation 
hlsI = zeros(size(rx_dmrs,1)*2, size(rx_dmrs,2));
hmmseI = hlsI;
hkI = hlsI;

for i = 1:size(rx_dmrs,2)
    hlsI(:,i) = interp(hls(:,i)',2)';
    hmmseI(:,i) = interp(hmmse(:,i)',2)';
    hkI(:,i) = interp(hk(:,i)',2)';
end

end


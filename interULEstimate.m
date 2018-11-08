function [hls, hmmse, hk] = interULEstimate(dmrs,rx_dmrs,SNRdB)
% The massive MIMO uplink estimation function has three input arguments: 
% the original demodulation reference symbols (dmrs) 
% the received and demapped demodulation reference symbols (rx_dmrs)
% and noise variance of the reciver (nVarUL)
%% Channel Estimation
% Least squares estimate of firts channel tap
hls1 = rx_dmrs(1,:)./dmrs(1,1);

% Least squares estimate of channel taps -> for comparison
hls = zeros(size(rx_dmrs,1), size(rx_dmrs,2));      
for i = 1:size(rx_dmrs,1)
    hls(i,:) = rx_dmrs(i,:)/dmrs(i,1);
end    

% Noise estimation
hlsMeans = mean(hls, 2); % Least squares noise estimation      
N = hls - hlsMeans;      % Noise matrix
Nvar = 1.0000e-03; 
% Nvar = var(N')';         % Noise variance   

hmmse = zeros(size(rx_dmrs,1), size(rx_dmrs,2));    
% for i = 1:size(rx_dmrs,1)
%     hmmse(i,:) = var(hls(i,:))*dmrs(i,1)'*inv(var(hls(i,:)) + mean(nVarUL))*(rx_dmrs(i,:) - mean(rx_dmrs(i,:))) + mean(hls(i,:));
% end    

for i = 1:size(rx_dmrs,1)
    hmmse(i,:) = (((dmrs(i,1)'*rx_dmrs(i,:))/(dmrs(i,1)'*dmrs(i,1)))/(Nvar/(dmrs(i,1)'*dmrs(i,1))) + mean(hls(i,:))/var(hls(i,:)))/((1/(Nvar/(dmrs(i,1)'*dmrs(i,1)))) + 1/var(hls(i,:)));
%     hmmse(i,:) = (((dmrs(i,1)'*rx_dmrs(i,:))/(dmrs(i,1)'*dmrs(i,1)))/(Nvar(i,1)/(dmrs(i,1)'*dmrs(i,1))) + mean(hls(i,:))/var(hls(i,:)))/((1/(Nvar(i,1)/(dmrs(i,1)'*dmrs(i,1)))) + 1/var(hls(i,:))); 
%     hmmse(i,:) = (((dmrs(i,1)'*rx_dmrs(i,:))/(dmrs(i,1)'*dmrs(i,1)))/(mean(nVarUL)/(dmrs(i,1)'*dmrs(i,1))) + mean(hls(i,:))/var(hls(i,:)))/((1/(mean(nVarUL)/(dmrs(i,1)'*dmrs(i,1)))) + 1/var(hls(i,:)));
end    

%% Vector Kalman Filtering
P1 = var(hls1(1,:));         % Initial process variance

% % complex-Gaussian random variables with zero mean and unit variance
% Bvar = 1; % Unit variance
% Q = sqrt(Bvar/2)*(randn(size(dmrs,1),size(dmrs,2)) + ...
%     1i*randn(size(dmrs,1),size(dmrs,2)));

% Recursion initialized 
% K2 = P1*dmrs(2,1)'*inv(dmrs(2,1)*P1*dmrs(2,1)' + mean(nVarUL));
K2 = P1*dmrs(2,1)'*inv(dmrs(2,1)*P1*dmrs(2,1)' + Nvar);
% K2 = P1*dmrs(2,1)'*inv(dmrs(2,1)*P1*dmrs(2,1)' + Nvar(2,1));
h2 = mean(hls1) + K2*(rx_dmrs(2,:) - dmrs(2,1)*mean(hls1));
Q2 = var(h2 - hls1);
% Q2 = Q(2,1);
P2 = (1 - K2*dmrs(2,1))*P1 + Q2;

% Vector Kalman filtering iterative process
Kn = zeros(size(rx_dmrs,1), 1);
Kn(2,1) = K2;
hk = zeros(size(rx_dmrs,1), size(rx_dmrs,2));
hk(1,:) = hls1(1,:);
hk(2,:) = h2;
Qn = zeros(size(rx_dmrs,1), 1);
Qn(2,:) = Q2;
Pn = zeros(size(rx_dmrs,1), 1);
Pn(1,1) = P1;
Pn(2,1) = P2;

% var = nVarUL';

for i = 3:size(rx_dmrs,1)
%     Kn(i,1) = Pn(i-1,1)*dmrs(i,1)'*inv(dmrs(i,1)*Pn(i-1,1)*dmrs(i,1)' + mean(nVarUL));
    Kn(i,1) = Pn(i-1,1)*dmrs(i,1)'*inv(dmrs(i,1)*Pn(i-1,1)*dmrs(i,1)' + Nvar);
%     Kn(i,1) = Pn(i-1,1)*dmrs(i,1)'*inv(dmrs(i,1)*Pn(i-1,1)*dmrs(i,1)' + Nvar(i,1));
    hk(i,:) = hk(i-1,:) + Kn(i,1)*(rx_dmrs(i,:) - dmrs(i,1)*hk(i-1,:));
    Qn(i,:) = var(hk(i,:) - hk(i-1,:));
    Pn(i,1) = (1 - Kn(i,1)*dmrs(i,1))*Pn(i-1,1) + Qn(i,1);
%     Pn(i,1) = (1 - Kn(i,1)*dmrs(i,1))*Pn(i-1,1) + Q(i,1);
end

end

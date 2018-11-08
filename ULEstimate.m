function [hls, hmmse, hk] = ULEstimate(x,y,nVarUL)
% The massive MIMO uplink estimation function has three input arguments: 
% the original demodulation reference symbols (dmrs) 
% the received and demapped demodulation reference symbols (rx_dmrs)
% and noise variance of the reciver (nVarUL)
%% Channel Estimation
% Least squares estimate of firts channel tap
hls1 = y(1,:)./x(1,1);

% Least squares estimate of channel taps -> for comparison
hls = zeros(size(y,1), size(y,2));      
for i = 1:size(y,1)
    hls(i,:) = y(i,:)/x(i,1);
end    

R = mean(hls*hls')';    % Least squares channel variance

hmmse = zeros(size(y,1), size(y,2));    
for i = 1:size(y,1)
%     hmmse(i,:) = var(hls(i,:))*x(i,1)'*inv(var(hls(i,:)) + mean(nVarUL))*(y(i,:) - mean(y(i,:)));
%     + mean(hls(i,:)); 
hmmse(i,:) = var(hls(i,:))*x(i,1)'*inv(var(hls(i,:)) + mean(nVarUL))*(y(i,:) - mean(y(i,:))); 
end    

%% Vector Kalman Filtering
% P1 = var(hls1(1,:));         % Initial process variance
P1 = R(1,1);                        % Initial process variance

% Recursion initialized 
K2 = P1*x(2,1)'*inv(x(2,1)*P1*x(2,1)' + mean(nVarUL));
h2 = mean(hls1) + K2*(y(2,:) - x(2,1)*mean(hls1));
Q2 = var(h2 - hls1);
P2 = (1 - K2*x(2,1))*P1 + Q2;

% Vector Kalman filtering iterative process
Kn = zeros(size(y,1), 1);
Kn(2,1) = K2;
hk = zeros(size(y,1), size(y,2));
hk(1,:) = hls1(1,:);
hk(2,:) = h2;
Qn = zeros(size(y,1), 1);
Qn(2,:) = Q2;
Pn = zeros(size(y,1), 1);
Pn(1,1) = P1;
Pn(2,1) = P2;

for i = 3:size(y,1)
    Kn(i,1) = Pn(i-1,1)*x(i,1)'*inv(x(i,1)*Pn(i-1,1)*x(i,1)' + mean(nVarUL));
    hk(i,:) = hk(i-1,:) + Kn(i,1)*(y(i,:) - x(i,1)*hk(i-1,:));
    Qn(i,:) = var(hk(i,:) - hk(i-1,:));
    Pn(i,1) = (1 - Kn(i,1)*x(i,1))*Pn(i-1,1) + Qn(i,1);
end

end
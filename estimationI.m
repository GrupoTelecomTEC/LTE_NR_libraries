function [hlsI,hmmseI,hkI] = estimationI(y,x,nVar)

% Least squares estimate of channel taps -> for comparison
% hls1 = y(1,:)./x(1,1);
hls = zeros(size(y,1), size(y,2));      
for i = 1:size(y,1)
    hls(i,:) = y(i,:)/x(i,1);
end

R = mean(hls*hls')';    % Least squares channel variance

% MMSE channel estimation of firts channel tap
hmmse = zeros(size(y,1), size(y,2));   
for i = 1:size(y,1)
    hmmse(i,:) = R(i,1)*x(i,1)'*inv(R(i,1) + nVar)*(y(i,:) - mean(y));
%    hmmse(i,:) = hls(i,1)*x(i,1)'*inv(hls(i,1) + nVar)*(y(i,:) - mean(y));
end    

%% Vector Kalman Filtering
P1 = R(1,1);                        % Initial process variance
hk = zeros(size(y,1), size(y,2));
hk(1,:) = y(1,:)./x(1,1);

% Recursion initialized 
K2 = P1*x(2,1)'*inv(x(2,1)*P1*x(2,1)' + nVar);
h2 = hk(1,1) + K2*(y(2,:) - x(2,1)*hk(1,1));
P2 = (1 - K2*x(2,1))*P1 + var(R);
% P2 = mean((h2-hk(1,1))*(h2-hk(1,1))');

% Vector Kalman filtering iterative process
Kn = zeros(size(y,1), 1);
Kn(2,1) = K2;

hk(2,:) = h2;
Pn = zeros(size(y,1), 1);
Pn(1,1) = P1;
Pn(2,1) = P2;

for i = 3:size(y,1)
    Kn(i,1) = Pn(i-1,1)*x(i,1)'*inv(x(i,1)*Pn(i-1,1)*x(i,1)' + nVar);
    hk(i,:) = hk(i-1,:) + Kn(i,1)*(y(i,:) - x(i,1)*hk(i-1,:));
%     Pn(i-1,1) = mean((hk(i,1)-hk(i-1,1))*(hk(i,1)-hk(i-1,1))'); 
    Pn(i,1) = (1 - Kn(i,1)*x(i,1))*Pn(i-1,1) + var(R);    
end

%% Interpolation
hlsI = zeros(size(y,1)*2, size(y,2)); hmmseI = hlsI; hkI = hlsI;  

for i = 1:size(y,2)
    hlsI(:,i) = interp(hls(:,i)',2)';
    hmmseI(:,i) = interp(hmmse(:,i)',2)';
    hkI(:,i) = interp(hk(:,i)',2)';
end

end


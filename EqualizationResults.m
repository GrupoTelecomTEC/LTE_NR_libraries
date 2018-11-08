function EqualizationResults(rx_dmrs, gridsize, EqLS, EqMMSE, EqKF)

% Plot received grid error on logarithmic scale
figure
surf(20*log10(abs(rx_dmrs)));
title('Received resource grid');
ylabel('Subcarrier');
xlabel('Symbol');
zlabel('absolute value (dB)');
% axis([1 gridsize(2) 1 gridsize(1)/2 -40 10]);

% Plot equalized grid error on logarithmic scale - Least Squares
figure
surf(20*log10(abs(EqLS)));
title('Equalized resource grid LS');
ylabel('Subcarrier');
xlabel('Symbol');
zlabel('absolute value (dB)');
axis([1 gridsize(2) 1 gridsize(1) -40 10]);

% Plot equalized grid error on logarithmic scale - MMSE
figure
surf(20*log10(abs(EqMMSE)));
title('Equalized resource grid MMSE');
ylabel('Subcarrier');
xlabel('Symbol');
zlabel('absolute value (dB)');
axis([1 gridsize(2) 1 gridsize(1) -40 10]);

% Plot equalized grid error on logarithmic scale - Kalman Filtering
figure
surf(20*log10(abs(EqKF)));
title('Equalized resource grid KF');
ylabel('Subcarrier');
xlabel('Symbol');
zlabel('absolute value (dB)');
axis([1 gridsize(2) 1 gridsize(1) -40 10]);
end


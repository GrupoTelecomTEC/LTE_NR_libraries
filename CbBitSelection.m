function E = CbBitSelection(C, G, Nl, Qm) 
%% codegen
% Bit selection parameters
% G = total number of output bits
% Nl Number of layers a TB is mapped to (Rel10) 
% Qm modulation bits
Gprime = G/(Nl*Qm);
gamma = mod(Gprime, C);
E=zeros(C,1);
% Rate matching with bit selection
for cbIdx=1:C
    if ((cbIdx-1) <= (C-1-gamma))
        E(cbIdx) = Nl*Qm*floor(Gprime/C);
    else
        E(cbIdx) = Nl*Qm*ceil(Gprime/C);
    end
end
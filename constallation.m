function c = constallation(in, M)

if M == 16
    Mode = 2;
elseif M == 64
    Mode = 3;
elseif M == 256
    Mode = 4;    
else
    Mode = 1;
end

x = randi([0 M-1],1000,1);

y = qammod(x,M,'UnitAveragePower',true);

constDiagram = comm.ConstellationDiagram('ReferenceConstellation',y)

constDiagram(in)
end


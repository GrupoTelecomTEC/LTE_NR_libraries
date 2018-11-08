function  constDiagram = constellation(eqGrid,M)
persistent c c1
c = randi([0 M-1],1000,1);
c1 = qammod(c,M,'UnitAveragePower',true);
constDiagram = comm.ConstellationDiagram('ReferenceConstellation',c1);
% Constallation Diagram
constDiagram(eqGrid)
end


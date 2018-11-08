function indices = IntrlvrIndices(blkLen) 
%% codegen
[f1, f2] = getf1f2(blkLen);
Idx = (0:blkLen-1).';
indices = mod(f1*Idx + f2*Idx.^2, blkLen) + 1;

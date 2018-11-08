%% Helper function
function csr_flat = packCsr(csr, m, numTx)
    if ((numTx==4)&&(m>2))              % Handle special case of 4Tx
        csr_flat = csr(:,[1,3],m);       % Extract pilots in this antenna
    else
        csr_flat = csr(:,:,m);
    end
end

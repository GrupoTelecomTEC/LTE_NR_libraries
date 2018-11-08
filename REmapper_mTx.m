function y = REmapper_mTx(in, csr, nS, prmLTE, varargin)
% The function is composed of three sections. 
% In the first, depending on the number of transmit antennas (numTx), 
% we initialize the indices for the user data (idx_data), 
% the CSR signals (idx_csr), and the DCI (idx_ pdcch).
% In the second section, we exclude from the user data and DCI indices the
% locations of the PSS, SSS, and PBCH, according to the value of the 
% subframe index (nS). Finally, in the third section, we initialize the 
% output buffer. 
%% codegen
switch nargin
    case 4, pdcch=[]; pss=[]; sss=[]; bch=[];
    case 5, pdcch=varargin{1}; pss=[]; sss=[]; bch=[];
    case 6, pdcch=varargin{1}; pss=varargin{2}; sss=[]; bch=[];
    case 7, pdcch=varargin{1}; pss=varargin{2}; sss=varargin{3}; bch=[];
    case 8, pdcch=varargin{1}; pss=varargin{2}; sss=varargin{3}; bch=varargin{4}; 
    otherwise
        error('REMapper has 4 to 8 arguments!'); 
end
% NcellID = 0;              % One of possible 504 values
% Get input parameters
numTx = prmLTE.numTx;           % Number of transmit antennas
Nrb = prmLTE.Nrb;               % Number of resource blocks
Nrb_sc = prmLTE.Nrb_sc;         % 12 for normal mode
Ndl_symb = prmLTE.Ndl_symb;     % 7 for normal mode
numContSymb = prmLTE.contReg;   % either {1, 2, 3}
%% Specify resource grid location indices for CSR, PDCCH, PDSCH, PBCH, PSS, SSS 
coder.varsize('idx_data');
lenOFDM = Nrb*Nrb_sc; 
ContREs = numContSymb*lenOFDM; 
idx_dci = 1:ContREs;
lenGrid = lenOFDM * Ndl_symb*2;
idx_data = ContREs+1:lenGrid;
%% 1st: Indices for CSR pilot symbols
idx_csr0 = 1:6:lenOFDM; % More general starting point = 1+mod(NcellID, 6);
idx_csr4 = 4:6:lenOFDM; % More general starting point = 1+mod(3+NcellID, 6); 
% Depends on number of transmit antennas
switch numTx 
    case 1
        idx_csr = [idx_csr0, 4*lenOFDM+idx_csr4, 7*lenOFDM+idx_csr0, ... 
            11*lenOFDM +idx_csr4];
        idx_data = ExpungeFrom(idx_data,idx_csr); 
        idx_pdcch = ExpungeFrom(idx_dci,idx_csr0); 
        idx_ex = 7.5*lenOFDM - 36 + (1:6:72); 
        a = numel(idx_csr); IDX=[1, a];
    case 2
        idx_csr1 = [idx_csr0, 4*lenOFDM+idx_csr4, 7*lenOFDM+idx_csr0, ...
            11*lenOFDM + idx_csr4];
        idx_csr2 = [idx_csr4, 4*lenOFDM+idx_csr0, 7*lenOFDM+idx_csr4, ...
            11*lenOFDM +idx_csr0];
        idx_csr = [idx_csr1, idx_csr2];
        % Exclude pilots and NULLs
        idx_data = ExpungeFrom(idx_data,idx_csr1); 
        idx_data = ExpungeFrom(idx_data,idx_csr2); 
        idx_pdcch = ExpungeFrom(idx_dci,idx_csr0); 
        idx_pdcch = ExpungeFrom(idx_pdcch,idx_csr4); 
        idx_ex = 7.5* lenOFDM - 36 + (1:3:72);
        % Point to pilots only
        a = numel(idx_csr1); IDX = [1, a; a+1, 2*a];
    case 4
        idx_csr1 = [idx_csr0, 4*lenOFDM+idx_csr4, 7*lenOFDM+idx_csr0, ...
            11*lenOFDM+idx_csr4];
        idx_csr2 = [idx_csr4, 4*lenOFDM+idx_csr0, 7*lenOFDM+idx_csr4, ...
            11*lenOFDM +idx_csr0];
        idx_csr33 = [lenOFDM+idx_csr0, 8*lenOFDM+idx_csr4];
        idx_csr44 = [lenOFDM+idx_csr4, 8*lenOFDM+idx_csr0];
        idx_csr = [idx_csr1, idx_csr2, idx_csr33, idx_csr44];
        % Exclude pilots and NULLs
        idx_data = ExpungeFrom(idx_data,idx_csr1); 
        idx_data = ExpungeFrom(idx_data,idx_csr2);
        idx_data = ExpungeFrom(idx_data,idx_csr33); 
        idx_data = ExpungeFrom(idx_data,idx_csr44);
        % From pdcch
        idx_pdcch = ExpungeFrom(idx_dci,idx_csr0);
        idx_pdcch = ExpungeFrom(idx_pdcch,idx_csr4);
        idx_pdcch = ExpungeFrom(idx_pdcch,lenOFDM+idx_csr0);
        idx_pdcch = ExpungeFrom(idx_pdcch,lenOFDM+idx_csr4);
        idx_ex = [7.5* lenOFDM - 36 + (1:3:72), 8.5*lenOFDM - 36 + (1:3:72)];
        % Point to pilots only
        a = numel(idx_csr1); b=numel(idx_csr33);  
        IDX = [1, a; a+1, 2*a; 2*a+1, 2*a+b; 2*a+b+1, 2*a+2*b];
    otherwise
        error('Number of transmit antennas must be {1, 2, or 4}'); 
end
%% 3rd: Indices for PDSCH and PDSCH data in OFDM symbols where pilots are present 
%% Handle 3 types of subframes differently
switch nS
    %% 4th: Indices for BCH, PSS, SSS are only found in specific subframes 0 and 5 
    % These symbols share the same 6 center sub-carrier locations (idx_ctr)
    % and differ in OFDM symbol number.
    case 0 % Subframe 0
        % PBCH, PSS, SSS are available + CSR, PDCCH, PDSCH
        idx_ctr = 0.5*lenOFDM - 36 + (1:72);
        idx_SSS = 5*lenOFDM + idx_ctr;
        idx_PSS = 6*lenOFDM + idx_ctr;
        idx_bch0 = [7*lenOFDM + idx_ctr, 8*lenOFDM + idx_ctr, 9*lenOFDM ...
            + idx_ctr,10*lenOFDM + idx_ctr];
        idx_bch = ExpungeFrom(idx_bch0,idx_ex);
        idx_data = ExpungeFrom(idx_data,[idx_SSS, idx_PSS, idx_bch]);
    case 10 % Subframe 5
        % PSS, SSS are available + CSR, PDCCH, PDSCH
        % Primary and Secondary synchronization signals in OFDM symbols 5 and 6 
        idx_ctr = 0.5*lenOFDM - 36 + (1:72) ;
        idx_SSS = 5*lenOFDM + idx_ctr;
        idx_PSS = 6*lenOFDM + idx_ctr;
        idx_data = ExpungeFrom(idx_data,[idx_SSS, idx_PSS]);
    otherwise % other subframes 
        % Nothing to do
end
% Initialize output buffer
y = complex(zeros(Nrb*Nrb_sc, Ndl_symb*2, numTx)); 

for m = 1:numTx
    grid = complex(zeros(Nrb*Nrb_sc, Ndl_symb*2)); 
    grid(idx_data.') = in(:,m);             % Insert user data
    Range = idx_csr(IDX(m,1):IDX(m,2)).';   % How many pilots in this antenna
    csr_flat = packCsr(csr, m, numTx);      % Pack correct number of CSR values  
    grid(Range) = csr_flat(:);              % Insert CSR pilot symbols  
    % Insert Physical Downlink Control Channel (PDCCH)
    if ~isempty(pdcch)
        grid(idx_pdcch) = pdcch(:,m); 
    end
    % Insert Primary Synchronization Signal (PSS)
    if ~isempty(pss)
        grid(idx_PSS) = pss(:,m); 
    end
    % Insert Secondary Synchronization Signal (SSS)
    if ~isempty(sss)
        grid(idx_SSS) = sss(:,m); 
    end    
    % Insert Broadcast Channel data (BCH)
    if ~isempty(bch)
        grid(idx_bch) = bch(:,m); 
    end   
    y(:,:,m)=grid;
end

end

        

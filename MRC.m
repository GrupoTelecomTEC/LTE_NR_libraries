function [hmmseTotal,rxGridmmse,rxGrid7,hlsTotal,rxGridls,rxGridls7,hkTotal,rxGridk,rxGridk7] = MRC(y,hmmse,hmmseI,hls,hlsI,hk,hkI)
% function [rxGridmmse,rxGridls,rxGridk] = MRC(y,hmmse,hmmseI,hls,hlsI,hk,hkI)

% Reshape received vectors
yn = zeros(size(y,1), size(y,3));
y1 = yn; y2 = yn; y3 = yn; y4 = yn; y5 = yn; y6 = yn; y7 = yn; 
y8 = yn; y9 = yn; y10 = yn; y11 = yn; y12 = yn; y13 = yn; y14 = yn;

for j = 1:size(y,1)
    for i = 1:size(y,3)
        y1(j,i) = y(j,1,i);
        y2(j,i) = y(j,2,i);
        y3(j,i) = y(j,3,i);
        y4(j,i) = y(j,4,i);
        y5(j,i) = y(j,5,i);
        y6(j,i) = y(j,6,i);
        y7(j,i) = y(j,7,i);
        y8(j,i) = y(j,8,i);
        y9(j,i) = y(j,9,i);
        y10(j,i) = y(j,10,i);
        y11(j,i) = y(j,11,i);
        y12(j,i) = y(j,12,i);
        y13(j,i) = y(j,13,i);
        y14(j,i) = y(j,14,i);
    end    
end

p = hmmseI/norm(hmmseI);
p2 = conj(p);

w1 = p2.*y1;
w2 = p2.*y2;
w3 = p2.*y3;
w4 = p2.*y4;
w5 = p2.*y5;
w6 = p2.*y6;
w7 = p2.*y7;
w8 = p2.*y8;
w9 = p2.*y9;
w10 = p2.*y10;
w11 = p2.*y11;
w12 = p2.*y12;
w13 = p2.*y13;
w14 = p2.*y14;

rxGrid1  = sum(w1,2);    
rxGrid2  = sum(w2,2);    
rxGrid3  = sum(w3,2);    
rxGrid4  = sum(w4,2);    
rxGrid5  = sum(w5,2);    
rxGrid6  = sum(w6,2);    
rxGrid7  = sum(w7,2);    
rxGrid8  = sum(w8,2);  
rxGrid9  = sum(w9,2);  
rxGrid10  = sum(w10,2);    
rxGrid11  = sum(w11,2);    
rxGrid12  = sum(w12,2);    
rxGrid13  = sum(w13,2);  
rxGrid14  = sum(w14,2);    
 
rxGridmmse = [rxGrid1 rxGrid2 rxGrid3 rxGrid4 rxGrid5 rxGrid6 rxGrid7 ...
    rxGrid8 rxGrid9 rxGrid10 rxGrid11 rxGrid12 rxGrid13 rxGrid14];

hmmseRE  = sum(hmmseI,2);   
hmmseTotal = [hmmseRE hmmseRE hmmseRE hmmseRE hmmseRE hmmseRE hmmseRE ...
    hmmseRE hmmseRE hmmseRE hmmseRE hmmseRE hmmseRE hmmseRE];

% Least squares MRC
b = hlsI/norm(hlsI);
b2 = conj(b);

t1 = b2.*y1;
t2 = b2.*y2;
t3 = b2.*y3;
t4 = b2.*y4;
t5 = b2.*y5;
t6 = b2.*y6;
t7 = b2.*y7;
t8 = b2.*y8;
t9 = b2.*y9;
t10 = b2.*y10;
t11 = b2.*y11;
t12 = b2.*y12;
t13 = b2.*y13;
t14 = b2.*y14;

rxGridls1  = sum(t1,2);    
rxGridls2  = sum(t2,2);    
rxGridls3  = sum(t3,2);    
rxGridls4  = sum(t4,2);    
rxGridls5  = sum(t5,2);    
rxGridls6  = sum(t6,2);    
rxGridls7  = sum(t7,2);    
rxGridls8  = sum(t8,2);  
rxGridls9  = sum(t9,2);  
rxGridls10  = sum(t10,2);    
rxGridls11  = sum(t11,2);    
rxGridls12  = sum(t12,2);    
rxGridls13  = sum(t13,2);  
rxGridls14  = sum(t14,2);    
 
rxGridls = [rxGridls1 rxGridls2 rxGridls3 rxGridls4 rxGridls5 rxGridls6 ... 
    rxGridls7 rxGridls8 rxGridls9 rxGridls10 rxGridls11 rxGridls12 ...
    rxGridls13 rxGridls14];

hlsRE  = sum(hlsI,2);   
hlsTotal = [hlsRE hlsRE hlsRE hlsRE hlsRE hlsRE hlsRE hlsRE hlsRE hlsRE ...
    hlsRE hlsRE hlsRE hlsRE];

% Vector Kalman Filtering MRC
c = hkI/norm(hkI);
c2 = conj(c);

q1 = c2.*y1;
q2 = c2.*y2;
q3 = c2.*y3;
q4 = c2.*y4;
q5 = c2.*y5;
q6 = c2.*y6;
q7 = c2.*y7;
q8 = c2.*y8;
q9 = c2.*y9;
q10 = c2.*y10;
q11 = c2.*y11;
q12 = c2.*y12;
q13 = c2.*y13;
q14 = c2.*y14;

rxGridk1  = sum(q1,2);    
rxGridk2  = sum(q2,2);    
rxGridk3  = sum(q3,2);    
rxGridk4  = sum(q4,2);    
rxGridk5  = sum(q5,2);    
rxGridk6  = sum(q6,2);    
rxGridk7  = sum(q7,2);    
rxGridk8  = sum(q8,2);  
rxGridk9  = sum(q9,2);  
rxGridk10  = sum(q10,2);    
rxGridk11  = sum(q11,2);    
rxGridk12  = sum(q12,2);    
rxGridk13  = sum(q13,2);  
rxGridk14  = sum(q14,2);    
 
rxGridk = [rxGridk1 rxGridk2 rxGridk3 rxGridk4 rxGridk5 rxGridk6 ... 
    rxGridk7 rxGridk8 rxGridk9 rxGridk10 rxGridk11 rxGridk12 ...
    rxGridk13 rxGridk14];

hkRE  = sum(hkI,2);    
hkTotal = [hkRE hkRE hkRE hkRE hkRE hkRE hkRE hkRE hkRE hkRE hkRE ...
    hkRE hkRE hkRE];

end


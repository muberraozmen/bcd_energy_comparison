function e = compare_scans(M1, M2, windowing)

num_signals = size(M1, 2);
e = zeros(1, num_signals);

S = windowing.start;
L = windowing.length;

for i = 1:size(M1, 2)
    sig1 = M1(:,i);
    sig2 = M2(:,i);
    
    % alignment
    [sig1, sig2] = alignsignals(sig1, sig2); 
    
    % windowing
    sig1 = sig1(S:(S+L-1));
    sig2 = sig2(S:(S+L-1));
    
    % calculate the energy of difference 
    e(i) = sum((sig1-sig2).^2);
    
    clear sig1 sig2 

end

end

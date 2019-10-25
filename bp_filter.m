function filtered_matrix = bp_filter(scan_matrix, filtering)
if filtering.on
    filtered_matrix = zeros(size(scan_matrix));
    for i = 1:size(scan_matrix,2)
        filtered_matrix(:,i) = bandpass(scan_matrix(:,i), filtering.fpass, filtering.fs);
    end
end
end

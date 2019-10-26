function select_signals (reference_folder, windowing, filtering)

reference_folder = '/home/muberra/Documents/MATLAB/bcd_energy_comparison/data/reference_scans';
% Info: Reference folder contains a number of Baseline and Tumour scans 

%% Generate scan pools (filtered) 

temp_folders = dir(reference_folder);
num_baseline = 0;
num_tumour = 0;
for i = 1:length(temp_folders)
    scan_dir = [temp_folders(i).folder,'/',temp_folders(i).name];
    if startsWith(temp_folders(i).name, 'Baseline') 
        num_baseline = num_baseline + 1;
        M = read_scan(scan_dir);
        M = bp_filter(M, filtering);
        pool_baseline{num_baseline} = M;
        clear M;
    end
    if startsWith(temp_folders(i).name, 'Tumor') % CAUTION TUMOUR
        num_tumour = num_tumour + 1;
        M = read_scan(scan_dir);
        M = bp_filter(M, filtering);
        pool_tumour{num_tumour} = M;
        clear M;
    end
    clear scan_dir;
end
clear temp_folders i ;

%% Compare scans 
% Note: we use a matrix this time instead of cell (different than
% population generation)

num_signals = size(pool_baseline{1},2);

% pairwise comparisons between baseline scans 
B2B = zeros((num_baseline-2)*(num_baseline-1), num_signals);
counter = 1;
for i = 1:num_baseline
    for j = (i+1):num_baseline
        B2B(counter,:) = compare_scans(pool_baseline{i}, pool_baseline{j}, windowing); 
        counter = counter +1;
    end
end

% pairwise comparisons between baseline scans and tumour scans 
B2T = zeros(num_baseline*num_tumour, num_signals);
counter = 1;
for i = 1:num_baseline
    for j = 1:num_tumour
        B2T(counter,:) = compare_scans(pool_baseline{i}, pool_tumour{j}, windowing); 
        counter = counter +1;
    end
end

clear i j counter;

%% Sort signals to have high B2T difference but low B2B difference
% Note: we may use scaling and weights
evaluated_criteria = sum(B2T,1) - sum(B2B,1);


end
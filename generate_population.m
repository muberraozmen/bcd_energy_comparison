%% Inputs 

data_folder = '/Users/mob/Documents/MATLAB/bcd_energy_comparison/merged_populations/ExperimentA';

windowing.start = 1400; % starting point of signal (requires calculation)
windowing.length = 1000; % total length of signal (requires calculation)
windowing.limit = 10; % maximum shift that can be observed (set by earlier observations) 

filtering.on = 1; % binary parameter to indicate whether to filter or not
filtering.fpass = [1.7e9 4e9]; % passband frequency range of the filter in hertz
filtering.fs = 160e9; % sampling rate in hertz

output_directory = strcat(data_folder, '/Outputs');
save_output = 1; % binary parameter for saving workspace

%% Generate scan pools (filtered) 

temp_folders = dir(data_folder);
num_baseline = 0;
num_tumour = 0;
for i = 1:length(temp_folders)
    scan_dir = [temp_folders(i).folder,'/',temp_folders(i).name];
    if startsWith(temp_folders(i).name, 'Baseline') 
        num_baseline = num_baseline + 1;
        M = read_scan(scan_dir);
        M = bp_filter(M, filtering);
        pool_baseline{num_baseline} = M;
        % pool_baseline_indices{num_baseline} = temp_folders(i).name;
        clear M;
    end
    if startsWith(temp_folders(i).name, 'Tumor') % CAUTION TUMOUR
        num_tumour = num_tumour + 1;
        M = read_scan(scan_dir);
        M = bp_filter(M, filtering);
        pool_tumour{num_tumour} = M;
        % pool_tumour_indices{num_tumour} = temp_folders(i).name;
        clear M;
    end
    clear scan_dir;
end
clear temp_folders i ;

%% Compare scans 

% pairwise comparisons between baseline scans 
B2B = cell(num_baseline, num_baseline);
for i = 1:num_baseline
    for j = (i+1):num_baseline
        B2B{i,j} = compare_scans(pool_baseline{i}, pool_baseline{j}, windowing); 
    end
end

% pairwise comparisons between tumour scans 
T2T = cell(num_tumour, num_tumour);
for i = 1:num_tumour
    for j = (i+1):num_tumour
        T2T{i,j} = compare_scans(pool_tumour{i}, pool_tumour{j}, windowing); 
    end
end

% pairwise comparisons between baseline scans and tumour scans 
B2T = cell(num_baseline, num_tumour);
for i = 1:num_baseline
    for j = 1:num_tumour
        B2T{i,j} = compare_scans(pool_baseline{i}, pool_tumour{j}, windowing); 
    end
end

clear i j;

%% Save the output as population 
if save_output
    mkdir (output_directory) % create output folder 
    save(strcat(output_directory,'/population'));
end
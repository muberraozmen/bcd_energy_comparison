%% Inputs 

data_folder = '/home/muberra/Documents/MATLAB/bcd_energy_comparison/data/ExperimentC/Initialization_Ex_C/No_LNA';
% Note: There should be 4 scans named as; Baseline1, Baseline2, Tumour1, Tumour2

windowing.start = 1400; % starting point of signal (requires calculation)
windowing.length = 1000; % total length of signal (requires calculation)
windowing.limit = 10; % maximum shift that can be observed (set by earlier observations) 

filtering.on = 1; % binary parameter to indicate whether to filter or not
filtering.fpass = [1.7e9 4e9]; % passband frequency range of the filter in hertz
filtering.fs = 160e9; % sampling rate in hertz

output_directory = strcat(data_folder, '/Outputs');
save_output = 1; % binary parameter for saving workspace

%% Read data and calculate pairsiwe energy of differences between scans

scan{1} = read_scan((strcat(data_folder, '/Baseline1')));
scan{2} = read_scan((strcat(data_folder, '/Baseline2')));
scan{3} = read_scan((strcat(data_folder, '/Tumor1')));
scan{4} = read_scan((strcat(data_folder, '/Tumor2')));

for i = 1:4
    if filtering.on
        scan{i} = bp_filter(scan{i}, filtering);
    end
end

combinations_dict = [1 2; 3 4; 1 3; 1 4; 2 3; 2 4];
for i =1:6
    index1 = combinations_dict(i,1);
    index2 = combinations_dict(i,2);
    e{i} = compare_scans(scan{index1},scan{index2},windowing);
end

scan_pairs = strsplit('Baseline1-Baseline2,Tumour1-Tumour2,Baseline1-Tumour1,Baseline1-Tumour2,Baseline2-Tumour1,Baseline2-Tumour2',',');
fun_format_1 = @(x)  sprintf('%0.4f',x);
fun_format_2 = @(x)  mat2str(round(x,4));

%% Mean over all antennna pairs 

for i = 1:6
    [mu{i},sigma{i},ci{i}] = normfit(e{i},0.05);
end
mu = cellfun(fun_format_1,mu,'UniformOutput',false);
sigma = cellfun(fun_format_1,sigma,'UniformOutput',false);
ci = cellfun(fun_format_2,ci,'UniformOutput',false);

results_all = table(scan_pairs',mu', sigma',ci');
results_all.Properties.VariableNames = {'Scans' 'Mean' 'StdDev' 'CI'};
disp('Pairwise comparisons - mean over all antenna pairs')
results_all

if save_output
    mkdir (output_directory) % create output folder 
    table2latex(results_all,strcat(output_directory,'/mean_all'));
    save(strcat(output_directory,'/workspace'));
end


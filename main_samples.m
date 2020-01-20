%% Inputs:

data_folder = '/home/muberra/Documents/MATLAB/bcd_energy_comparison/merged_populations/ExperimentA';
output_directory = strcat(data_folder, '/Outputs');
load(strcat(output_directory,'/population'), 'B2B','T2T','B2T','windowing','filtering');

reference_folder = strcat(data_folder,'/References');

% B2B: cell Baseline to Baseline energy of differences between signals 
% T2T: cell Tumour to Tumour energy of differences between signals 
% B2T: cell Baseline to Tumour energy of differences between signals

output_directory = strcat(data_folder, '/Outputs');
save_output = 1; % binary parameter for saving workspace

global IND
IND = select_signals (reference_folder, 20, windowing, filtering);

%% Population Analysis

%% Mean over all antenna pairs 
data_B2B = cellfun(@mean,B2B); data_B2B = data_B2B(:); data_B2B = data_B2B(~isnan(data_B2B));
data_B2T = cellfun(@mean,B2T); data_B2T = data_B2T(:); data_B2T = data_B2T(~isnan(data_B2T));
compare_means(data_B2B,data_B2T,'onetail')
if save_output
    saveas(gcf,strcat(output_directory,'/population_mean_all.png'))
end
clear data_B2B data_B2T

% Mean over selected antenna pairs 
fun_reduced_mean = @(x) mean(x(IND));

data_B2B = B2B(:); data_B2B = data_B2B(~cellfun(@isempty, data_B2B)); data_B2B = cellfun(fun_reduced_mean,data_B2B);
data_B2T = B2T(:); data_B2T = data_B2T(~cellfun(@isempty, data_B2T)); data_B2T = cellfun(fun_reduced_mean,data_B2T);
compare_means(data_B2B,data_B2T,'onetail')
if save_output
    saveas(gcf,strcat(output_directory,'/population_mean_selected.png'))
end
clear data_B2B data_B2T

%% Sample to Sample Analysis splitting with scan

% Randomly select indices of SCANS for each sample
num_baseline = size(B2B,1);
num_tumour = size(T2T,1);
sample1_B = sort(randperm(num_baseline, round(num_baseline/2))); sample2_B = setdiff([1:num_baseline],sample1_B);
sample1_T = sort(randperm(num_tumour, round(num_tumour/2))); sample2_T = setdiff([1:num_tumour],sample1_T);
%sample1_T = sample1_B; sample2_T = sample2_B;

%% Mean over all antenna pairs 
data1_B2B = cellfun(@mean,B2B(sample1_B, sample1_B)); data1_B2B = data1_B2B(:); data1_B2B = data1_B2B(~isnan(data1_B2B));
data1_B2T = cellfun(@mean,B2T(sample1_B, sample1_T)); data1_B2T = data1_B2T(:); data1_B2T = data1_B2T(~isnan(data1_B2T));
data2_B2B = cellfun(@mean,B2B(sample2_B, sample2_B)); data2_B2B = data2_B2B(:); data2_B2B = data2_B2B(~isnan(data2_B2B));

compare_means(data1_B2B,data2_B2B,'twotails')
if save_output
    saveas(gcf,strcat(output_directory,'/samples_same_mean_all.png'))
end

compare_means(data1_B2B,data1_B2T,'onetail')
if save_output
    saveas(gcf,strcat(output_directory,'/samples_diff_mean_all.png'))
end

clear data1_B2B data1_B2T data2_B2B

%% Mean over selected antenna pairs 
data1_B2B = B2B(sample1_B, sample1_B); 
data1_B2B = data1_B2B(:); data1_B2B = data1_B2B(~cellfun(@isempty, data1_B2B)); data1_B2B = cellfun(fun_reduced_mean,data1_B2B);
data1_B2T = B2T(sample1_B, sample1_T); 
data1_B2T = data1_B2T(:); data1_B2T = data1_B2T(~cellfun(@isempty, data1_B2T)); data1_B2T = cellfun(fun_reduced_mean,data1_B2T);
data2_B2B = B2B(sample2_B, sample2_B); 
data2_B2B = data2_B2B(:); data2_B2B = data2_B2B(~cellfun(@isempty, data2_B2B)); data2_B2B = cellfun(fun_reduced_mean,data2_B2B);

compare_means(data1_B2B,data2_B2B,'twotails')
if save_output
    saveas(gcf,strcat(output_directory,'/samples_same_mean_selected.png'))
end

compare_means(data1_B2B,data1_B2T,'onetail')
if save_output
    saveas(gcf,strcat(output_directory,'/samples_diff_mean_selected.png'))
end

clear data1_B2B data1_B2T data2_B2B

%% Without sample splitting based on scan

data_B2B = cellfun(@mean,B2B); data_B2B = data_B2B(:); data_B2B = data_B2B(~isnan(data_B2B));
data_B2T = cellfun(@mean,B2T); data_B2T = data_B2T(:); data_B2T = data_B2T(~isnan(data_B2T));
compare_means(data_B2B,data_B2B,'twotails')
if save_output
    saveas(gcf,strcat(output_directory,'/test_power.png'))
end
clear data_B2B data_B2T





%% Inputs:

data_folder = '/home/muberra/Documents/MATLAB/bcd_energy_comparison/data/ExperimentA';
output_directory = strcat(data_folder, '/Outputs');
load(strcat(output_directory,'/population'), 'B2B', 'T2T','B2T');

reference_folder = strcat(data_folder,'/reference_scans');

% B2B: cell Baseline to Baseline energy of differences between signals 
% T2T: cell Tumour to Tumour energy of differences between signals 
% B2T: cell Baseline to Tumour energy of differences between signals

output_directory = strcat(data_folder, '/Outputs');
save_output = 1; % binary parameter for saving workspace

%% Population Analysis

% Mean over all antenna pairs 
data_B2B = cellfun(@mean,B2B); data_B2B = data_B2B(:); data_B2B = data_B2B(~isnan(data_B2B));
data_B2T = cellfun(@mean,B2T); data_B2T = data_B2T(:); data_B2T = data_B2T(~isnan(data_B2T));
compare_means(data_B2B,data_B2T,'onetail')
if save_output
    saveas(gcf,strcat(output_directory,'/population_mean_all.png'))
end

% Mean over selected antenna pairs 
fun_reduced_mean = @(x, I) mean(x(I));
IND = select_signals (reference_folder, 20, windowing, filtering);
data_B2B = cellfun(@mean,B2B); data_B2B = data_B2B(:); data_B2B = data_B2B(~isnan(data_B2B));
data_B2T = cellfun(@mean,B2T); data_B2T = data_B2T(:); data_B2T = data_B2T(~isnan(data_B2T));
compare_means(data_B2B,data_B2T,'onetail')
if save_output
    saveas(gcf,strcat(output_directory,'/population_mean_all.png'))
end



%% Sample to Sample Analysis

num_baseline = size(B2B,1);
num_tumour = size(T2T,1);
% randomly select indices for each sample
sample1_B = sort(randperm(num_baseline, round(num_baseline/2))); sample2_B = setdiff([1:num_baseline],sample1_B);
sample1_T = sort(randperm(num_tumour, round(num_tumour/2))); sample2_T = setdiff([1:num_tumour],sample1_T);

% Mean over all antenna pairs 
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

% Mean over antenna pairs which see tumour

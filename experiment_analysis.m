%% Inputs:

dir_data = '/Users/mob/Documents/MATLAB/bcd_data/2020_02_03_Hybrid_Bra_Tests_Hospital/Progress_C1';
load(strcat(output_directory,'/population'));

% B2B: cell Baseline to Baseline energy of differences between signals 
% T2T: cell Tumour to Tumour energy of differences between signals 
% B2T: cell Baseline to Tumour energy of differences between signals

%% Population Analysis

% Mean over all antenna pairs 
data_B2B = cellfun(@mean,B2B); data_B2B = data_B2B(:); data_B2B = data_B2B(~isnan(data_B2B));
data_B2T = cellfun(@mean,B2T); data_B2T = data_B2T(:); data_B2T = data_B2T(~isnan(data_B2T));
compare_means(data_B2B,data_B2T,'onetail')
if save_output
    saveas(gcf,strcat(output_directory,'/population_mean_all.png'))
end
clear data_B2B data_B2T

%% Sample to Sample Analysis

% Randomly select indices of SCANS for each sample
num_baseline = size(B2B,1);
num_tumour = size(T2T,1);
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

clear data1_B2B data1_B2T data2_B2B

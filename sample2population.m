function sample2population(dir_population, dir_sample, windowing)

% Data loading
load(strcat(dir_population,'/Outputs/population'));
load(strcat(dir_sample,'/Outputs/sample'),'scans');
s_pool_baseline{1} = scans{1}; s_pool_baseline{2} = scans{2};
s_pool_tumour{1} = scans{3}; s_pool_tumour{2} = scans{4};
clear scans


%% Sample to population comparison pools
s_num_baseline = length(s_pool_baseline);
s_num_tumour = length(s_pool_tumour);

% pairwise comparisons between population baselines and sample baselines scans 
s_B2B = cell(num_baseline, s_num_baseline);
for i = 1:num_baseline
    for j = 1:s_num_baseline
        s_B2B{i,j} = compare_scans(pool_baseline{i}, s_pool_baseline{j}, windowing); 
    end
end

% pairwise comparisons between population baselines and sample tumours
s_B2T = cell(num_baseline, s_num_tumour);
for i = 1:num_baseline
    for j = 1:s_num_tumour
        s_B2T{i,j} = compare_scans(pool_baseline{i}, s_pool_tumour{j}, windowing); 
    end
end

clear i j;


%% Mean comparison
IND = select_signals_amplitute(pool_baseline); 

fprintf('For the data under %s: \n', dir_sample);

fprintf('- New %d Baseline and %d Tumour measurements are compared with a population of %d Baseline and %d Tumour scans \n',s_num_baseline,s_num_tumour,num_baseline,num_tumour);

cool1 = compare_means(s_B2B,s_B2T,IND,'onetail'); 

fprintf('- We compared new Tumour and Baseline scans with the Baseline scans in population: \n')
if cool1
    fprintf(' ... and Tumours show significantly higher differences :) \n')
else
    fprintf(' ... and Tumours does not show significantly higher differences :( \n')
end

cool2 = compare_means(B2B,s_B2B,IND,'twotails');
if cool2
    fprintf('- It seems safe to add new measurements to the population. \n')
else
    fprintf('- Before adding new measurements to the population, we may need more careful analysis with new sample. \n')
end

if save_output
    save(strcat(dir_sample,'/Outputs/sample2population')); 
    fprintf('- Workspace is saved under ~/dir_sample/Outputs as sample2population.mat \n');
end



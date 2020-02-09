function update_population(dir_population, dir_sample)

% Data loading
load(strcat(dir_population,'/Outputs/population'));
load(strcat(dir_sample,'/Outputs/sample'),'scans');
s_pool_baseline{1} = scans{1}; s_pool_baseline{2} = scans{2};
s_pool_tumour{1} = scans{3}; s_pool_tumour{2} = scans{4};
clear scans

num_baseline = length(pool_baseline);
num_tumour = length(pool_tumour);
s_num_baseline = length(s_pool_baseline);
s_num_tumour = length(s_pool_tumour);

% pairwise comparisons between baseline scans 
for i = 1:num_baseline
    for j = 1:s_num_baseline
        row = i;
        column = num_baseline+j;
        B2B{row,column} = compare_scans(pool_baseline{i}, s_pool_baseline{j}, windowing);
    end
end
for i = 1:s_num_baseline
    for j = (i+1):s_num_baseline
        row = i + num_baseline;
        column = j + num_baseline;
        B2B{row,column} = compare_scans(pool_baseline{i}, s_pool_baseline{j}, windowing);
    end
end
B2B{column,column} = []; 
pool_baseline = [pool_baseline s_pool_baseline]; % update pool
old_num_baseline = num_baseline;
num_baseline = length(pool_baseline);

% pairwise comparisons between baseline and tumour scans 
for i = 1:num_baseline
    for j = 1:s_num_tumour
        row = i;
        column = num_tumour+j;
        B2T{row,column} = compare_scans(pool_baseline{i}, s_pool_tumour{j}, windowing);
    end
end

for i = 1:s_num_baseline
    for j = 1:num_tumour
        row = i + old_num_baseline;
        column = j;
        B2T{row,column} = compare_scans(s_pool_baseline{i}, pool_tumour{j}, windowing);
    end
end

pool_tumour= [pool_tumour s_pool_tumour]; % update pool
num_tumour = length(pool_tumour);

clear row column i j;
clear s_num_baseline s_num_tumour old_num_baseline; 

if save_output
    mkdir (dir_outputs) % create output folder 
    save(strcat(dir_outputs,'/population')); 
    fprintf('- Workspace population.mat is updated\n');
end
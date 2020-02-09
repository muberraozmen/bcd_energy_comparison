function pairwise_comparison(dir_sample, windowing, filtering)
% Note: There should be 4 scans named as; Baseline1, Baseline2, Tumour1, Tumour2 in the directory
% Fixed settings
dir_outputs = strcat(dir_sample, '/Outputs');
save_output = 1; % binary parameter for saving workspace

%% Read data and calculate pairsiwe energy of differences between scans

scans{1} = read_scan((strcat(dir_sample, '/Baseline1')));
scans{2} = read_scan((strcat(dir_sample, '/Baseline2')));
scans{3} = read_scan((strcat(dir_sample, '/Tumor1')));
scans{4} = read_scan((strcat(dir_sample, '/Tumor2')));

for i = 1:4
    scans{i} = bp_filter(scans{i}, filtering);
end

combinations_dict = [1 2; 3 4; 1 3; 1 4; 2 3; 2 4];
for i =1:6
    index1 = combinations_dict(i,1);
    index2 = combinations_dict(i,2);
    e{i} = compare_scans(scans{index1},scans{index2},windowing);
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

%% Mean over selected subset of antenna pairs 
IND = select_signals_amplitute(scans); 
for i = 1:6
    e_reduced{i} = e{i}(IND);
    mu_reduced{i} = mean(e_reduced{i});
    ci_reduced{i} = bootci(100, @mean, e_reduced{i});
end
mu_reduced = cellfun(fun_format_1,mu_reduced,'UniformOutput',false);
ci_reduced = cellfun(fun_format_2,ci_reduced,'UniformOutput',false);

results_reduced = table(scan_pairs',mu_reduced', ci_reduced');
results_reduced.Properties.VariableNames = {'Scans' 'Mean' 'CI'};
disp('Pairwise comparisons - mean signals with highest amplitute larger tha 0.1')
results_reduced

%% Finalization
if save_output
    mkdir (dir_outputs) % create output folder 
    table2latex(results_all,strcat(dir_outputs,'/mean_all'));
    table2latex(results_reduced,strcat(dir_outputs,'/mean_reduced'));
    save(strcat(dir_outputs,'/sample'));
end

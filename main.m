%% Inputs 

dir_population = '/Users/mob/Documents/MATLAB/bcd_data/hemisphere/ExperimentA/Population_Exp';
dir_sample = '/Users/mob/Documents/MATLAB/bcd_data/hemisphere/ExperimentA/Progress_Ex_A2';

windowing.start = 1250; % starting point of signal (requires calculation)
windowing.length = 1000; % total length of signal (requires calculation)
windowing.limit = 10; % maximum shift that can be observed (set by earlier observations) 

filtering.on = 1; % binary parameter to indicate whether to filter or not
filtering.fpass = [1.7e9 4e9]; % passband frequency range of the filter in hertz
filtering.fs = 160e9; % sampling rate in hertz

%% Population analysis 

% Generation
regenerate_population = 1; % INDICATE whether you want to generate the popoulation and its comparison pools from scratch
if regenerate_population
    fprintf('GENERATING POPULATION...\n')
    generate_population(dir_population, windowing, filtering);
end

% Mean comparison
fprintf('PERFORMING MEAN COMPARISON FOR THE POPULATION...\n')
load(strcat(dir_population,'/Outputs/population'));
IND = select_signals_amplitute(pool_baseline); 
cool = compare_means(B2B,B2T,IND,'onetail'); 
if cool 
    fprintf('- Population is OK, go on!\n')
else
    fprintf('- Population does not show the property that B2B comparisons have lower mean than B2T comparisons!\n')
end

%% Pairwise comparison for new measurements (sample)
fprintf('PERFORMING PAIRWISE (WITHIN) COMPARISON FOR THE NEW SCANS...\n')
pairwise_comparison(dir_sample, windowing, filtering)

%% Population to sample comparison
fprintf('COMPARING SAMPLE TO POPULATION...\n')
sample2population(dir_population, dir_sample, windowing)

%% Population update with new measurements
update_population = 0; % INDICATE whether you would like to add sample to the population.mat 
if update_population
    fprintf('ADDING NEW MEASUREMENTS TO POPULATION...\n')
    update_population(dir_population, dir_sample); 
end


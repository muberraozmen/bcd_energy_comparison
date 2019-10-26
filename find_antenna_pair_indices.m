% This script is used to extract index- antenna pair list

scan_dir = '/home/muberra/Documents/MATLAB/bcd_energy_comparison/data/reference_scans/Baseline1';

temp_files = struct2table(dir(scan_dir));

% delete system files
to_delete = ~(contains(temp_files.name, '.txt') & startsWith(temp_files.name, 'sig'));
temp_files(to_delete,:) = [];  

scan_files = sortrows(temp_files,'name'); % sort by file name (i.e. antenna pairs as text)
clear temp_files to_delete;

antenna_pairs = strings(height(scan_files),2);
for i = 1:height(scan_files)
    temp = strsplit(char(scan_files{i,'name'}), {'A','_'});
    antenna_pairs(i,1) = temp(2);
    antenna_pairs(i,2) = temp(3);
end

save(anetnna_pair_indices)
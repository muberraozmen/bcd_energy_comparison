function scan_matrix = read_scan(scan_dir)

temp_files = struct2table(dir(scan_dir));

% delete system files
to_delete = ~(contains(temp_files.name, '.txt') & startsWith(temp_files.name, 'sig'));
temp_files(to_delete,:) = [];  

scan_files = sortrows(temp_files,'name'); % sort by file name (i.e. antenna pairs as text)
clear temp_files to_delete;

scan_matrix = zeros(4096, height(scan_files)); % lets leave it like this (meh)
for i = 1:height(scan_files)
    file_i = [char(scan_files{i,'folder'}), '/', char(scan_files{i,'name'})];
    row_i = fscanf(fopen(file_i,'r'),'%f %f',[2 Inf]);
    scan_matrix(:,i) = row_i(1, :)';
    fclose('all');
end

end

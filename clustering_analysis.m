dir_population = '/Users/mob/Documents/MATLAB/bcd_data/2020_02_03_Hybrid_Bra_Tests_Hospital/Progress_C1';
dir_outputs = strcat(dir_population, '/Outputs');

load(strcat(dir_population,'/Outputs/population'));
IND = select_signals_amplitute(pool_baseline);

fun_reduce = @(x) x(IND);

data_B2B = B2B(:); 
data_B2B = data_B2B(~cellfun(@isempty, data_B2B)); 
data_B2B = cellfun(fun_reduce,data_B2B,'UniformOutput',false);
data_B2B = cell2mat(data_B2B);

data_B2T = B2T(:); 
data_B2T = data_B2T(~cellfun(@isempty, data_B2T)); 
data_B2T = cellfun(fun_reduce,data_B2T,'UniformOutput',false);
data_B2T = cell2mat(data_B2T);

data = [data_B2B; data_B2T];
labels = cell(length(data),1);
labels(1:length(data_B2B)) = {'B2B'};
row = length(data_B2B)+1;
labels(row:end) = {'B2T'};

%% 3D reduction
figure
rng('default') % for fair comparison
Y = tsne(data,'Algorithm','exact','Distance','euclidean', 'NumDimensions', 3);
scatter3(Y(1:length(data_B2B),1),Y(1:length(data_B2B),2),Y(1:length(data_B2B),3))
hold on
row = length(data_B2B)+1;
scatter3(Y(row:end,1),Y(row:end,2),Y(row:end,3))
title('Hybrid Bra - Phantom 3 - Large Tumour - Progress 1')
legend('B2B', 'B2T')
saveas(gcf,strcat(dir_outputs,'/tsne_3D.png'))

%% 2D reduction
figure

rng('default') % for reproducibility
Y = tsne(data,'Algorithm','exact','Distance','cityblock');
subplot(2,2,1)
gscatter(Y(:,1),Y(:,2),labels)
title('Cityblock')

rng('default') % for fair comparison
Y = tsne(data,'Algorithm','exact','Distance','cosine');
subplot(2,2,2)
gscatter(Y(:,1),Y(:,2),labels)
title('Cosine')

rng('default') % for fair comparison
Y = tsne(data,'Algorithm','exact','Distance','chebychev');
subplot(2,2,3)
gscatter(Y(:,1),Y(:,2),labels)
title('Chebychev')

rng('default') % for fair comparison
Y = tsne(data,'Algorithm','exact','Distance','euclidean');
subplot(2,2,4)
gscatter(Y(:,1),Y(:,2),labels)
title('Euclidean')

sgtitle('Hybrid Bra - Phantom 3 - Large Tumour - Progress 1')
saveas(gcf,strcat(dir_outputs,'/tsne_2D.png'))

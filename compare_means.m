function cool = compare_means(comp1,comp2,IND,type)

% Calculate the average over a preferred set of signals indicated by IND

fun_reduced_mean = @(x) mean(x(IND));

data1 = comp1(:); 
data1 = data1(~cellfun(@isempty, data1)); 
data1 = cellfun(fun_reduced_mean,data1);

data2 = comp2(:); 
data2 = data2(~cellfun(@isempty, data2)); 
data2 = cellfun(fun_reduced_mean,data2);

% Bootstrapping 

nboot = 10000;
alpha = .20;

fun_delta_mean = @(x1,x2) mean(x1)-mean(x2);

n1 = size(data1,1);
n2 = size(data2,1);
sample_differences = zeros(nboot,1);
for i=1:nboot
    sample1 = data1(ceil(rand(n1,1)*n1));
    sample2 = data2(ceil(rand(n2,1)*n2));
    sample_differences(i) = fun_delta_mean(sample1,sample2);
end

if strcmp(type,'onetail')
    % Note that H0: mean(data1) >= mean(data2) H1: mean(data1) < mean(data2)
    critical_value = prctile(sample_differences,100*(1-alpha));
    observed_mean = fun_delta_mean(data1,data2);
    clf
    hist(sample_differences);
    hold on
    ylim = get(gca,'YLim');
    h1=plot(observed_mean*[1,1],ylim,'y-','LineWidth',2);
    h2=plot(critical_value*[1,1],ylim,'r-','LineWidth',2);
    h3=plot([0,0],ylim,'b-','LineWidth',2);
    xlabel('Difference between means');
    legend([h1,h2,h3],{'observed mean','critical value','tested value'},'Location','NorthEast');
    if critical_value<=0
        title('Reject H0'); 
        cool = 1;
    else
        title('Fail to reject H0'); 
        cool = 0;
    end
end
if strcmp(type,'twotails')
    % Note that H0: mean(data1) = mean(data2) H1: mean(data1) ~= mean(data2)
    critical_values = prctile(sample_differences,[100*alpha/2,100*(1-alpha/2)]);
    observed_mean = fun_delta_mean(data1,data2);
    clf
    hist(sample_differences);
    hold on
    ylim = get(gca,'YLim');
    h1=plot(observed_mean*[1,1],ylim,'y-','LineWidth',2);
    h2=plot(critical_values(1)*[1,1],ylim,'r-','LineWidth',2);
    plot(critical_values(2)*[1,1],ylim,'r-','LineWidth',2);
    h3=plot([0,0],ylim,'b-','LineWidth',2);
    xlabel('Difference between means');
    legend([h1,h2,h3],{'observed mean','critical values','tested value'},'Location','NorthEast');
    if (critical_values(1)>0 || critical_values(2)<0)
        title('Reject H0'); 
        cool = 0;
    else
        title('Fail to reject H0');
        cool = 1;
    end
end




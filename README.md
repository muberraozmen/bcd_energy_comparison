# BCD: Data Analysis based on Energy Calculation

This repository contains a debugging method for a time-domain radar-based microwave system designed for breast cancer detection. It is mainly based on statistical analysis of energy of differences between healthy (baseline) and tumorous (tumour) scans of same instance. The instances are typically breast mimicking phantoms and plugs prepared for experimental purposes. 

# Instructions

Dear Lena :) 

**Preperation:**
1. Download (or pull) repository.
2. Identify the directory of folder that contains scans you would like to use as population `dir_population`. It typically contains a number of baseline and tumour scans of **same phantom**, baseline scan folders contains the word 'baseline' in name, tumour scan folders contains the word 'tumor' in name. The numbering is not important. 
3. Identify the directory of folder that contains scans you would like to use as sample `dir_sample`. It typically contains two baseline and two tumour scans of same phantom named as 'Baseline1', 'Baseline2', 'Tumor1', 'Tumor2'. 
4. The data directories you identified can be anywhere on your local disk. 
5. The data directories should not contain a folder named as 'Outputs'. 
6. Determine your windowing and filtering parameters. 
7. Open `main.m` file.

**At the hospital:**

On the first usage you will set the parameter `regenerate_population` to 1 in order to gerenerate population from scratch. It will take some time but you have to call it only once. Then just run `main.m` and follow command window. 

1. It will first generate the population (which will take a while) and will let you know when it is done. 
2. Then, it will perform an analysis for the population, you will either get the message *Population is OK, go on!* or *Population does not show the property that B2B comparisons have lower mean than B2T comparisons!* on command window. If you get the second one, we need to reconsider if the scan pool is good enough. 
3. Thirdly, it will perform pairwise analysis for your sample scans you will get two tables as usual, one for aggregation over all antenna pairs one for aggregation over signals whose maximum amplitute is higher than `0.7`. 
4. Then it will compare the sample to population. You will get two feedbacks in this step; one to test if tumour scans are significantly different then baselines, another one to test if the sample shows the characteristics of population. 
  - For the first test you see either: *... Tumours show significantly higher differences :)* or *... Tumours does not show significantly higher differences :(* which is self-explanatory.
  - For the second test you either see *It seems safe to add new measurements to the population.* or *Before adding new measurements to the population, we may need more careful analysis with new sample.* 
5. Based on the feedback you get, may want to add new measurements to the population. If so turn `update_population` parameter in the last section to 1 and run the last section of `main.m`. It will not modify the location of your scan files but will update saved workspaces. 
6. Before proceeding make sure you set parameter `regenerate_population` to 0 to avoind long waiting times next time.  

*Note:* This version makes mean calculation based on signals whose maximum amplitute is higher than `0.7` for all population adn sample to population analysis. 

% NIJ Crime Forecasting Challenge
% Test function to obtain total # of each crime committed each month
% 
% Contributors : Nicholas Kumia
% Last Modified : 10.07.2016

function results = collect(filename)

    [~, ~, dataset] = xlsread(filename);
    
    results = dataset;

end

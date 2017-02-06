
%% Loading Data
clc;
clear all;
load('test.mat');    


%% Normalizing Data
%  A          ->  The # of CRIMES that occur per DAYd per ARE
%  test_data  ->  The specs of each crime that happened in 2012

in = test_data;
dates = [in(:,2) in(:,5)];
dates = unique(dates, 'rows');
in = dates;

for i = 1:length(dates)
    out(i) = (A(dates(i,2), dates(i,1)));
%    out(i) = (A(dates(i,2), dates(i,1))-4)/8;
end

%in(:,1) = (in(:,1)-366/2) / 366;
%in(:,2) = (in(:,2)-max(in(:,2))/2) / max(in(:,2));
in = [in out'];

%% Set Prediction Paramters
%  prediction_time -> the day ahead of the current day to predict for

prediction_time = 100;
input_x = in;
out(:, 1:prediction_time) = [];
coeff = rand(1, 1);
mu = rand(1,1);

% white_coeff = rand(prediction_time, 1);

%% training days
TrainingDays = 127000;

X = input_x;
n = 0.01;

%% Auto-Regressive Model
%figure
for i=2:TrainingDays
%     for j=1:prediction_time
%        white_coeff(j) = coeff(j).^i; 
%     end
%     wn = out(i) - out(i-prediction_time:i-1)*(white_coeff);
    coeff(i+1) = rand(1);
    estimate = coeff*out(1:i)';% + sum(wn);
%    error = ((estimate - out(i))*100)/(out(i));
 %   plot(error, i);
    est = out(i);
    for j=1:i-1
        coeff(j) = coeff(j) - (n*(out(j)-estimate)/prediction_time);
    end
end

prediction = zeros(1, size(input_x, 1)-TrainingDays+1-prediction_time);
prediction(1:prediction_time) = out(TrainingDays+1:TrainingDays+prediction_time);

for i =prediction_time+2:200            % 8 samples in training batch
    wn = prediction(i-1) - prediction(i-prediction_time-1:i-2);%*(white_coeff));
    prediction(i) = (prediction(i-prediction_time:i-1)*coeff) + sum(wn);
end
    
figure
hold on
plot(prediction);
title('prediction');


plot(out(TrainingDays+1:size(input_x, 1)-prediction_time));
title('actual');
hold off


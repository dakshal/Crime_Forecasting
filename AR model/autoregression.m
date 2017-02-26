
%% Loading Data
clc;
clear all;
load('region18807.mat');    
load('test.mat');    


%% Normalizing Data
%  A          ->  The # of CRIMES that occur per DAYd per ARE
%  test_data  ->  The specs of each crime that happened in 2012

in = region18807;
dates = [in(:,2) in(:,5)];
dates = unique(dates, 'rows');
in = dates;
out = zeros(1, length(in(:, 1)));

for i = 1:length(dates)
    out(i) = out(i) + (A(dates(i,2), dates(i,1)));
%    out(i) = (A(dates(i,2), dates(i,1))-4)/8;
end

%in(:,1) = (in(:,1)-366/2) / 366;
%in(:,2) = (in(:,2)-max(in(:,2))/2) / max(in(:,2));
%in = [in out'];

%% Set Prediction Paramters
%  prediction_time -> the day ahead of the current day to predict for

prediction_time = 7;
input_x = in;
%out(:, 1:prediction_time) = [];

mu = rand(1,1);


%% training days
TrainingDays = 220;

X = input_x;
n = 0.05;

%p = prediction_time;

t = (0:0.1:TrainingDays)';
x = sawtooth(t);
w = awgn(x,length(out(:, 1)),'measured');

random = randn(length(in(:, 1)), 1);

%n = 1000;	% number of points

iteration = 10;

training1 = zeros(iteration, TrainingDays-prediction_time);
estm1 = zeros(TrainingDays, 1);
k=1;



%% Auto-Regressive Model

X = zeros(TrainingDays-prediction_time, prediction_time+1);
% G = zeros(TrainingDays-prediction_time, prediction_time+1);

for i=prediction_time+1:TrainingDays
    X(i-prediction_time, :) = [1 out(i-prediction_time:i-1)];
%     X(i-prediction_time, :) = out(i-prediction_time:i);
%     G(i-prediction_time, :) = w(i-prediction_time:i);
end

Y = out';
Y(1:prediction_time+2) = [];

I = eye(213);
H = (X)*((X'*X)\(X'));


b = ((X'*X)\(X'*(Y(1:length(X(:,1))))));
% b = (X'*(H*Y(1:length(X(:,1))) - Y(1:length(X(:,1)))));
white_coeff = b;

e = Y(1:length(X(:,1))) - X*b;

training1(1, :) = (X*b)';

estm1 = Y;

figure
hold on
title('initial');
plot(abs(ceil(training1')));
plot(estm1);
hold off



for i=1:100
%     for j=1:prediction_time+1
%         white_coeff(j) = b(j).^i;
%     end
%     e = (Y(1:length(X(:,1))) - H*Y(1:length(X(:,1))));
%     e = e - n*(Y(1:length(X(:,1))) - ceil(abs(X*b)));
    b = b - (n/length(X(:,1)))*((X'*X)\(X'*(Y(1:length(X(:,1))) - e)));
    e = Y(1:length(X(:,1))) - X*b;
%     coeff = coeff - n*((X'*X)\(X'*(Y(1:length(X(:,1))) - X*white_coeff)));
    training1(i, :) = (X*b + e)';
end

% for j=1:10000
%     for i=prediction_time+1:TrainingDays
%     %     for j=1:prediction_time
%     %        white_coeff(j) = coeff(j).^i; 
%     %     end
%     %     wn = out(i) - out(i-prediction_time:i-1)*(white_coeff);
%         %coeff(i+1) = rand(1);
% 
%         %w = sqrt(0.5*p)*(randn(1:TrainingDays,1)+i*randn(1:TrainingDays,1));
%         %w = sqrt(0.5*p)*(random(i)+i*random(i));
% 
%         const = [1 out(i-prediction_time:i-1)];
% 
%         estimate = ceil(const*coeff + w(i));
%     %    error = ((estimate - out(i))*100)/(out(i));
%      %   plot(error, i);
%         est = out(i);
% %        if(k<5000)
%             training1(i) = abs(estimate);
%             estm1(i) = est;
%  %           k = k + 1;
%  %       end
%     %    for j=1:i-1
%             coeff = coeff + (n*(out(i+1)-estimate)/prediction_time);
%     %    end
%     end
% end



prediction = zeros(1, size(input_x, 1)-TrainingDays+prediction_time);
prediction(1:prediction_time) = out(TrainingDays+1-prediction_time:TrainingDays);

match = 0;

for i =prediction_time+1:size(prediction, 2)            % 8 samples in training batch
%    wn = prediction(i-1) - prediction(i-prediction_time-1:i-2);%*(white_coeff));
    const = [1 prediction(i-prediction_time:i-1)];
%     const = prediction(i-prediction_time:i);
    
    %w = sqrt(0.5*p)*(random(i)+i*random(i));
    prediction(i) = const*b + e(i);
    
    if floor(prediction(i)) == out(TrainingDays+i-prediction_time)
        match = match+1;
    end

%    prediction(i) = (prediction(i-prediction_time:i-1)*coeff) + sum(wn);
end

figure
hold on
title('During the training')
plot(abs(ceil(training1')));
plot(estm1);
hold off

figure
hold on
plot(floor(prediction));
title('prediction');
plot(out(TrainingDays+1-prediction_time:size(input_x, 1)));
title('actual');
hold off

s = sum(floor(prediction));
N = sum(out(TrainingDays+1:size(input_x, 1)));

PAI = s/N

match
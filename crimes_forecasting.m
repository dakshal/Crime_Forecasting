clear all
close all
clc

% sim_data_gen2
% close all


%% load input and output data
load('input_sorted.mat');
load('output_sorted.mat');     

dates = input(:,2);
dates = unique(dates, 'rows');
a = size(dates,1);
data = [];
first = dates(1);
last = dates(a);
in = zeros(last-first+1, 2);
out = zeros(last-first+1, 1);
b = size(input(:,2), 1);

%% restructure input and output
for i=1:b
    breaker = input(i,2);
    in(input(i,2)-first+1, :) = input(i, 2:3);
    out(input(i,2)-first+1) = out(input(i,2)-60) + output(i);
end

prediction_time = 7;
input_x = [in out];
out(1:prediction_time, :) = [];
ex_y = out;

numP = 10;

%% Repeat data to create better analysis
Data = zeros(size(input_x, 1) * numP, size(input_x, 2));
Class =  zeros(size(ex_y, 1) * numP, 1);
count  = 0;
for i = 1 : size(input_x, 1)
    Data(count+1 : count + numP, :) = ones(numP, 1) * input_x(i, :);
    if i < size(ex_y, 1)
        Class(count+1 : count + numP, :) = ex_y(i) + 1;
    end
    count = count + numP;
end

%% create prediction model
TrainingDays = 250;
T=TrainingDays*numP;
size_x = size(Data,2);
layers = 10;

W1 = ones(size_x,layers)/2;
size_y = size(out(1,:));
W2 = ones(layers, size_y(2))/2;
nn_lr = 0.01;

predict = [];


nn = [3 10 1];
dIn=[0];
dIntern=[ ];
dOut=[ ];

%% input data to NN to train it
net = CreateNN(nn, [dIn, dIntern, dOut]);
k_max=100;
E_stop=1e-10;

result_after = train_LM(Data(1:T, :)', Class(1:T)', net, k_max, E_stop);


%% create prediction from trained data model
prediction = NNOut(input_x(TrainingDays+1, size(input_x,1)-prediction_time-1)', net, [Data(1:T)', Class(1:T)']); %zeros(size(input_x,1)-prediction_time - TrainingDays,1);
actual = zeros(size(input_x,1)-prediction_time - TrainingDays,1);
i = 1;

for x = TrainingDays+1 : size(input_x,1)-prediction_time-1
    actual(i) =  out(x)*10;
    i = i + 1;
end

%% plot both analytical and actual prediction data sets
figure
plot(prediction);

hold on
stem(actual);

hold off

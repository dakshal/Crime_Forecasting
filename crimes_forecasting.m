clear all
close all
clc

% sim_data_gen2
% close all

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

TrainingDays = 250;
T=TrainingDays*numP;
size_x = size(Data,2);
layers = 10;

W1 = ones(size_x,layers)/2;
size_y = size(out(1,:));
W2 = ones(layers, size_y(2))/2;
nn_lr = 0.01;

predict = [];

%for x = 1 : T
%         if (t == T)
%             t
%         end
 %   nn_input = Data(x, :);
%    nn_hidden = (nn_input * W1)';
%    nn_hidden = sig(nn_hidden);

%    nn_output = (nn_hidden' * W2)';
%    nn_output = sig(nn_output);

    % update output weights
%    sigma2 = nn_output .* (1 - nn_output) .* (Class(x, :)' - nn_output);
%    delta2 = nn_lr * nn_hidden * sigma2';

    % update hidden weights
%    sigma1 = nn_hidden .* (1 - nn_hidden) .* (W2 * sigma2);
%    delta1 = nn_lr * nn_input' * sigma1';

%    W2 = W2 + delta2;
%    W1 = W1 + delta1;

%    predict(i) = ((Class(i) - nn_output).^2)/2;
%end

nn = [3 10 1];
dIn=[0];
dIntern=[ ];
dOut=[ ];

net = CreateNN(nn, [dIn, dIntern, dOut]);
k_max=100;
E_stop=1e-10;

result_after = train_LM(Data(1:T, :)', Class(1:T)', net, k_max, E_stop);



prediction = NNOut(input_x(TrainingDays+1, size(input_x,1)-prediction_time-1)', net, [Data(1:T)', Class(1:T)']); %zeros(size(input_x,1)-prediction_time - TrainingDays,1);
actual = zeros(size(input_x,1)-prediction_time - TrainingDays,1);
i = 1;

for x = TrainingDays+1 : size(input_x,1)-prediction_time-1
%    nn_input = input_x(x, :);
%    nn_hidden = (nn_input * W1)';
%    nn_hidden = sig(nn_hidden);

%    nn_output = (nn_hidden' * W2)';
%    nn_output = sig(nn_output);

%    prediction(i) = nn_output*10;
    actual(i) =  out(x)*10;
    i = i + 1;

end

figure
plot(prediction);
%title('developing accuracy');

hold on
stem(actual);
%title('prediction accuracy');

hold off

function data_out = sig(data_in)
    data_out = 1 ./ (1 + exp(-data_in));
end


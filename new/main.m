%% NIJ Crime Forecasting Challenge
% Training a Neural Network
% 
% Contributors : Dakshal Shah, Nicholas Kumia
% Last Modified : 01.07.2017

clc; clear all;
load('train.mat');    

%% Normalizing Data
%  A           ->  The # of CRIMES that occur per DAYd per ARE
%  train_data  ->  The specs of each crime that happened between Mar 2012
%                  and Jul 2016

in = train_data;
dates = [in(:,2) in(:,5)];
dates = unique(dates, 'rows');
in = dates;

for i = 1:length(dates)
    out(i) = (A(dates(i,2), dates(i,1))-4)/8;
end

in(:,1) = (in(:,1)-366/2) / 366;
in(:,2) = (in(:,2)-max(in(:,2))/2) / max(in(:,2));
in = [in out'];

%% Set Prediction Paramters
%  prediction_time -> the day ahead of the current day to predict for

prediction_time = 7;
input_x = in;
%out(1:prediction_time, :) = [];

%% Define the amount of Training Data
TrainingCrimes = 500000;

X = input_x;

%% Starting the Neuralnet

% Number of nodes for each layer, L1 .. L2 .. L3
% Number of hidden layers, H_layers
L1 = 3;
L2 = 10;
L3 = 1;
H_layers = 1;

% Total # of Nodes
total_size = L2*( L1 + 1 ) + L3*( L2 + 1 );

% Initialize Random weights, theta
% Define actual output, Y
theta = rand(total_size,1);
Y = out;

% Connections between Layer A and B, ParamA
Parameter1 = rand(L2, L1 + 1);
Parameter2 = rand(L3, L2 + 1);

% Repeat Data for better accuracy
% The model is trained with each crime r-fold
r = 10;
array = zeros(r*TrainingCrimes, 1);
array_accurate = zeros(r*TrainingCrimes, 1);

for iteration = 1:100
    % Prediction Output, output_mat
    % Accumulated weights for the i-th layer after each iteration,
    % accum_parami
    output_mat = zeros(size(Y,1),1);
    accum_param1 =zeros(L2,L1+1);
    accum_param2 = zeros(L3,L2+1);
    
    for i = 1:TrainingCrimes
        fprintf('Currently running\nIteration %d, Crime %d\n', iteration, i)
        % Layers without bias
        L11 = X(i,(1:3))';
%         L21 = zeros(L2,1) ;
%         L31 = zeros(L3,L3);
        
        % Forward Propagation considering layers with bias, A1 .. A2 .. A3
        [A1,A2,A3,output] = forwardprop(L11,Parameter1,Parameter2);
        output_mat(i,:) = output;
        L21 = A2(2:size(A2,1),:);
        L31 = A3;
        
        % Backward Propagation
        e3 = output - Y(i) ;
        e2 = backward_prop(e3,Parameter2,A2);
        
        accum_param1 = accum_param1 + e2(2:size(e2, 1))*A1';
        accum_param2 = accum_param2 + e3*A2';
        
        array(iteration*TrainingCrimes + i) = output;
        array_accurate(iteration*TrainingCrimes + i) = out(i);
        
    end
    
    % Calculate D1 and D2, which are partial dervatives w.r.t cost function
    D1 = accum_param1*(1/size(X,1));   
    D2 = accum_param2*(1/size(X,1));
    
    step_size = 0.5;
       
    % Update Parameters
    Parameter1 = Parameter1 - step_size.*D1;
    Parameter2 = Parameter2 - step_size.*D2;
    
    % Cost Function (cross-entropy)
%     cost(iteration,:) = (-1/size(X,1)*(log(output_mat)'*Y + log(1-output_mat)'*(1-Y)));

end

prediction = zeros(size(input_x, 1) - TrainingCrimes, 1);
expected = out(:, TrainingCrimes+1:size(out, 2));

for i = TrainingCrimes+1:size(input_x, 1)
        L11 = X(i,(1:3))';
%         L21 = zeros(L2,1) ;
%         L31 = zeros(L3,L3);
        
        % Forward Propagation considering layers with bias, A1 .. A2 .. A3
        [A1,A2,A3,output] = forwardprop(L11,Parameter1,Parameter2);
        output_mat(i,:) = output;
        L21 = A2(2:size(A2,1),:);
        L31 = A3;
        
        prediction(i-TrainingCrimes) = output;
        
end
    
subplot(1,2,1)
plot(prediction);
title('Training Model - Predicted Crimes');

subplot(1,2,2)
plot(expected);
title('Training Model - Actual Crimes');

% hold off
% 
% figure
% plot(array);
% %title('developing accuracy');
% 
% hold on
% plot(array_accurate);
% %title('prediction accuracy');
% 
% hold off
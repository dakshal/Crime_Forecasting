%% NIJ Crime Forecasting Challenge
% Training a Neural Network
% 
% Contributors : Dakshal Shah, Nicholas Kumia
% Last Modified : 01.04.2017

clc; clear all;

load('test.mat');    

%% Normalizing Data
%  A          ->  The # of CRIMES that occur per DAYd per ARE
%  test_data  ->  The specs of each crime that happened in 2012

in = test_data;
dates = [in(:,2) in(:,5)];
dates = unique(dates, 'rows');
in = dates;

for i = 1:length(dates)
    out(i) = A(dates(i,2), dates(i,1));
end

in(:,1) = in(:,1) / 366;
in(:,2) = in(:,2) / max(in(:,2));
in = [in out'];

%% Set Prediction Paramters
%  prediction_time -> the day ahead of the current day to predict for

prediction_time = 7;
input_x = in;
%out(1:prediction_time, :) = [];

%% trainging data
TrainingDays = 250;

X = input_x;

%% Neuralnet starting

% Number of nodes for each layer
L1 = 3;
L2 = 10;
L3 = 1;
H_layers = 1;

total_size= L2*(L1 +1 ) + L3* ( L2 + 1);     % Defining parameter vector size
%total_size = L2*(L1+1) + L3*(L2+1) + (H_layers-1)*L2*(L2+1);
theta = rand(total_size,1);             % Initialising random weights
Y = out;                             % output
Parameter1 = rand(L2, L1 + 1);                     % Generating weight matrices
Parameter2 = rand(L3, L2 + 1);

array = zeros(10*TrainingDays, 1);
array_accurate = zeros(10*TrainingDays, 1);

for iteration =1:10
    output_mat = zeros(size(Y,1),1);         %Matrix for storing output
    Accum_par1 =zeros(L2,L1+1);              % Storing accumulated values after each batch is passed
    Accum_par2 = zeros(L3,L2+1);
    
    for i =1:TrainingDays              % 8 samples in training batch
        Lone = X(i,(1:3))';       % Lone, Ltwo, Lthree layers without bias
        Ltwo = zeros(L2,1) ;
        Lthree = zeros(L3,L3);
        
        % Forward Propogation ,A1,A2,A3 layers with bias

        [A1,A2,A3,output] = forwardprop(Lone,Parameter1,Parameter2);  %Lone and Parameter1 and Parameter2 passed as arguement for
        
        output_mat(i,:) = output;      % output stored
        Ltwo = A2(2:size(A2,1),:);
        Lthree = A3;
        
        %Backward Propogation
        
        e3 = output - Y(i) 
        [e2] = backward_prop(e3,Parameter2,A2)
        
        Accum_par1 = Accum_par1 + e2(2:size(e2, 1))*A1';
        Accum_par2 = Accum_par2 + e3*A2';
        
        
        array(iteration*TrainingDays + i) = output;
        array_accurate(iteration*TrainingDays + i) = out(i);
        
    end
    
    % calculating D1 & D2 which are partial dervatives w.r.t cost function
    
    D1 = Accum_par1*(1/size(X,1));   
    D2 = Accum_par2*(1/size(X,1));
    
   
       step_size = 0.5;                       %setting step_size    
       
       %Updating parameters
    Parameter1 = Parameter1 - step_size.*D1;
    Parameter2 = Parameter2 - step_size.*D2;
    
    %Cost Function (cross-entropy)
    cost(iteration,:) = (-1/size(X,1)*(log(output_mat)'*Y + log(1-output_mat)'*(1-Y)));
end

prediction = zeros(size(input_x, 1) - TrainingDays, 1);
expected = out(TrainingDays+1:size(out), :);

for i =TrainingDays+1:size(input_x, 1)            % 8 samples in training batch
        Lone = X(i,(1:3))';       % Lone, Ltwo, Lthree layers without bias
        Ltwo = zeros(L2,1) ;
        Lthree = zeros(L3,L3);
        
        % Forward Propogation ,A1,A2,A3 layers with bias
        
        [A1,A2,A3,output] = forwardprop(Lone,Parameter1,Parameter2);  %Lone and Parameter1 and Parameter2 passed as arguement for
        
        output_mat(i,:) = output;      % output stored
        Ltwo = A2(2:size(A2,1),:);
        Lthree = A3;
        
        prediction(i-TrainingDays) = output;
        
end
    
figure
plot(prediction);
%title('developing accuracy');

hold on
stem(expected);
%title('prediction accuracy');

hold off

figure
plot(array);
%title('developing accuracy');

hold on
plot(array_accurate);
%title('prediction accuracy');

hold off
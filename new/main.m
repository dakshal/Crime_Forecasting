clc;
load('test.mat');    

%% Normalizing Data
%  A          ->  The # of CRIMES that occur per DAYd per ARE
%  test_data  ->  The specs of each crime that happened in 2012

in = test_data;
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
out(:, 1:prediction_time+1) = [];

%% trainging data
TrainingDays = 127000;

X = input_x;

%% Neuralnet starting

% Number of nodes for each layer
L1 = 3;
L2 = 40;
L3 = prediction_time;
H_layers = 1;

total_size= L2*(L1 +1 ) + L3* ( L2 + 1);     % Defining parameter vector size
theta = rand(total_size,1);             % Initialising random weights
Y = out(1:TrainingDays);                             % output
Parameter1 = rand(L2, L1 + 1);                     % Generating weight matrices
Parameter2 = rand(L3, L2 + 1);


array = zeros(10*TrainingDays, L3);
array_accurate = zeros(10*TrainingDays, L3);


%% input data to NN to train it
for iteration =1:30
    iteration
    output_mat = zeros(size(Y,1),L3);         %Matrix for storing output
    Accum_par1 =zeros(L2,L1+1);              % Storing accumulated values after each batch is passed
    Accum_par2 = zeros(L3,L2+1);
    
    for i =1:TrainingDays              % 8 samples in training batch
%         i
        Lone = X(i,:)';       % Lone, Ltwo, Lthree layers without bias
        Ltwo = zeros(L2,1) ;
        Lthree = zeros(L3,L3);
        
        % Forward Propogation ,A1,A2,A3 layers with bias

        [A1,A2,A3,output] = forwardprop(Lone,Parameter1,Parameter2);  %Lone and Parameter1 and Parameter2 passed as arguement for
        
        output_mat(i,:) = output;      % output stored
        Ltwo = A2(2:size(A2,1),:);
        Lthree = A3;
        
        %Backward Propogation
        
        e3 = output - Y(i) ;
        [e2] = backward_prop(e3,Parameter2,A2);
        
        Accum_par1 = Accum_par1 + e2(2:size(e2, 1))*A1';
        Accum_par2 = Accum_par2 + e3*A2';
        
        
        array(iteration*TrainingDays + i, :) = output;
        array_accurate(iteration*TrainingDays + i, :) = out(i);

    end
    
    % calculating D1 & D2 which are partial dervatives w.r.t cost function
    
    D1 = Accum_par1*(1/size(X,1));   
    D2 = Accum_par2*(1/size(X,1));
    
   
       step_size = 0.1;                       %setting step_size    
       
       %Updating parameters
    Parameter1 = Parameter1 - step_size.*D1;
    Parameter2 = Parameter2 - step_size.*D2;

	%Cost Function (cross-entropy)
    cost(iteration,:) = (-1/size(X,1)*(log(output_mat)'*Y' + log(1-output_mat)'*(1-Y)'));

end

prediction = zeros(size(input_x, 1) - TrainingDays, L3);
expected = out(:, TrainingDays+1:size(out, 2));


%% create prediction from trained data model
for i =TrainingDays+1:size(input_x, 1)            % 8 samples in training batch
    Accum_par1 =zeros(L2,L1+1);              % Storing accumulated values after each batch is passed
    Accum_par2 = zeros(L3,L2+1);

        Lone = X(i,(1:3))';       % Lone, Ltwo, Lthree layers without bias
        Ltwo = zeros(L2,1) ;
        Lthree = zeros(L3,L3);
        
        % Forward Propogation ,A1,A2,A3 layers with bias
        
        [A1,A2,A3,output] = forwardprop(Lone,Parameter1,Parameter2);  %Lone and Parameter1 and Parameter2 passed as arguement for
        
        output_mat(i,:) = output;      % output stored
        Ltwo = A2(2:size(A2,1),:);
        Lthree = A3;
        
        pos = (i-TrainingDays);
        prediction(pos, :) =  -41.75841*output;
        
end
    
%% plot both analytical and actual prediction data sets
figure
plot(mean(prediction, 2));
%title('developing accuracy');

hold on
plot(expected);
%title('prediction accuracy');

hold off

figure
plot(array);
%title('developing accuracy');

hold on
plot(array_accurate);
%title('prediction accuracy');

hold off

figure
subplot(1, 2, 1)
title('actual')
plot(abs(expected));

subplot(1, 2, 2)
title('prediction')
plot(abs(mean(prediction,2)));

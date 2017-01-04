
clc;
clear all;

load('input_sorted.mat');
load('output_sorted.mat');     

%% formating data
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
    in(input(i,2)-first+1, 1) = in(input(i,2)-first+1, 1) / 366;
    in(input(i,2)-first+1, 2) = in(input(i,2)-first+1, 2) / 1000;
    out(input(i,2)-first+1) = out(input(i,2)-60) + output(i);
end

%% prediction ahead of specific days
prediction_time = 7;
input_x = [in out];
out(1:prediction_time, :) = [];
ex_y = out;

%% formating input data
for i=1:size(input_x,1)
    if input_x(i, 1) == 0
        input_x(i, 1) = 60+i;
        input_x(i, 2) = 100;
        input_x(i, 3) = 0;
    end
end

%% repeating data
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

%% trainging data
TrainingDays = 250;
T=TrainingDays*numP;
size_x = size(Data,2);


X = input_x;
%X = [input_x(:,1) input_x(:,3)];

%Setting Network structure parameters

%% Neuralnet starting
L1 = 3;
L2=10;
L3=1;
H_layers = 1;     % L1,L2,L3 : size of input,hidden and output layer without bias

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
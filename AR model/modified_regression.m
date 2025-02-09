
clc;

crime = format_matrix();
%% prediction days
prediction_time = 30;

%% training days
TrainingDays = 1300;

%% defining input
X = crime;
Y = X;
feature = 3;
% Y(:,:,:, 1:(prediction_time*feature)) = [];
n = 0.1;

%p = prediction_time;

% t = (0:0.1:TrainingDays)';
% x = sawtooth(t);
% w = awgn(x,length(out(:, 1)),'measured');

% random = randn(306, 1);

%n = 1000;	% number of points

iteration = 10;

training1 = zeros(iteration, TrainingDays-prediction_time);
estm1 = zeros(TrainingDays, 1);
k=1;

summed_crimes = sum(crime,4);
rows=size(crime,1);
cols=size(crime,2);
days=size(crime,4);

reshape_crime = reshape(summed_crimes, rows*cols, 1);

[sorted_crimes,sortingIndices] = sort(reshape_crime,'descend');

total_area = 31;

%% Auto-Regressive Model


%% formate data for the input

b1 = zeros(prediction_time, total_area+1, feature);
b2 = zeros(prediction_time*2, total_area+1, feature);
b3 = zeros(prediction_time*3, total_area+1, feature);

restructured_input1 = zeros(days, prediction_time*1, total_area+1); 
restructured_input2 = zeros(days, prediction_time*2, total_area+1); 
restructured_input3 = zeros(days, prediction_time*3, total_area+1); 

restructured_output= zeros(days+1, total_area+1);

restructured_output(days+1, :) = rand(1,total_area+1);


for i=1:(total_area+1)
    row = mod(sortingIndices(i),rows);
    col = ceil(sortingIndices(i)/cols);
    for k=0:days-1
        for j=1:prediction_time
            for feature=1:3
                if feature==1
                    restructured_input1(k+j, j, i) = crime(row, col, 1, k+1);
                end
                if feature==2
                    restructured_input2(k+j, j, i) = 0 - (crime(row, col, 1, k+1)/9);
                    restructured_input2(k+j, prediction_time + j, i) = floor(mean(mean(crime(row-1:row+1, col-1:col+1, 1, k+1))));
                end
                if feature==3
                    restructured_input3(k+j, j, i) = 0 - (crime(row, col, 1, k+1)/9);
                    restructured_input3(k+j, prediction_time + j, i) = floor(mean(mean(crime(row-1:row+1, col-1:col+1, 1, k+1))));
                    restructured_input3(k+j, prediction_time*2 + j, i) = crime(row, col, 1, k+1)^2;
                end
            end
        end
        restructured_output(k+1, i) = crime(row, col, 1, k+1);
    end
end

restructured_input1(days+1:(days+prediction_time-1),:, :) = [];
restructured_input1(1:(prediction_time-1),:, :) = [];
restructured_input2(days+1:(days+prediction_time-1),:, :) = [];
restructured_input2(1:(prediction_time-1),:, :) = [];
restructured_input3(days+1:(days+prediction_time-1),:, :) = [];
restructured_input3(1:(prediction_time-1),:, :) = [];
restructured_output(1:prediction_time, :) = [];

% restructured_output = sum(restructured_input, 2);
%%


e = zeros(TrainingDays, total_area+1);

% H = (restructured_input(:,:,1)'*restructured_input(:,:,1))\(restructured_input(:,:,1)');
% for j=1:(total_area+1)
%     b(j, :) = b(j,:) + n*H(:, j)*(restructured_output(j,1) - e(j));
% end

x_train1 = restructured_input1(1:TrainingDays, :, :);
x_test1 = restructured_input1(TrainingDays+1:days-prediction_time+1, :, :);
x_train2 = restructured_input2(1:TrainingDays, :, :);
x_test2 = restructured_input2(TrainingDays+1:days-prediction_time+1, :, :);
x_train3 = restructured_input3(1:TrainingDays, :, :);
x_test3 = restructured_input3(TrainingDays+1:days-prediction_time+1, :, :);

y_train = restructured_output(1:TrainingDays, :);
y_test = restructured_output(TrainingDays+1:days-prediction_time+1, :);

for i=1:total_area+1
    %     H = (X)*((X'*X)\(X'));
    %     reshape_output=reshape(Y(:,:,1,i), 32,32);
    b1(:, i) = ((x_train1(:,:,i)'*x_train1(:,:,i))\(x_train1(:,:,i)'))*y_train(:,i);
    b2(:, i) = ((x_train2(:,:,i)'*x_train2(:,:,i))\(x_train2(:,:,i)'))*y_train(:,i);
    b3(:, i) = ((x_train3(:,:,i)'*x_train3(:,:,i))\(x_train3(:,:,i)'))*y_train(:,i);
    %     for j=1:(total_area+1)
    %         b(j, :) = b(j,:) - n*(restructured_output(:,i) - restructured_input(:,:,i)*(restructured_output(j,i) - e(j)));
    %     end
    %     b(:,:,:) = H(:,:).*(reshape_output);
%     e(:, i) = y_train(:,i) - x_train(:,:,i)*b(:, i);
end



% b = (X'*(H*Y(1:length(X(:,1))) - Y(1:length(X(:,1)))));
% white_coeff = b;

% e = Y(1:length(X(:,1))) - X*b;



% training1(1, :) = (X*b)';
% 
% estm1 = Y;
% 
% figure
% hold on
% title('initial');
% plot(abs(ceil(training1')), 'r-');
% plot(estm1, 'b--');
% hold off


%% prediction

prediction_output1=zeros(days-TrainingDays-prediction_time+1, total_area+1);
prediction_output2=zeros(days-TrainingDays-prediction_time+1, total_area+1);
prediction_output3=zeros(days-TrainingDays-prediction_time+1, total_area+1);
% actual_output = restructured_output(TrainingDays:days-prediction_time, :);

for i=1:total_area+1
    %prediction_output(:, i) = x_test(:, :, i)*b(:, i) + e(1:(days-TrainingDays-prediction_time+1), i);
    prediction_output1(:, i) = x_test1(:, :, i)*b1(:, i);
    prediction_output2(:, i) = x_test2(:, :, i)*b2(:, i);
    prediction_output3(:, i) = x_test3(:, :, i)*b3(:, i);
end


% prediction = zeros(1, size(input_x, 1)-TrainingDays+prediction_time);
% prediction(1:prediction_time) = out(TrainingDays+1-prediction_time:TrainingDays);
% 
% match = 0;
% 
% for i =prediction_time+1:size(prediction, 2)            % 8 samples in training batch
% %    wn = prediction(i-1) - prediction(i-prediction_time-1:i-2);%*(white_coeff));
%     const = [1 prediction(i-prediction_time:i-1)];
% %     const = prediction(i-prediction_time:i);
%     
%     %w = sqrt(0.5*p)*(random(i)+i*random(i));
%     prediction(i) = const*b + e(i);
%     
%     if floor(prediction(i)) == out(TrainingDays+i-prediction_time)
%         match = match+1;
%     end
% 
% %    prediction(i) = (prediction(i-prediction_time:i-1)*coeff) + sum(wn);
% end

for i=1:6
    figure
    hold on
%     subplot(2, 2, 1)
    plot((prediction_output1(:, i)), 'y');
    title('prediction1');
%     subplot(2, 2, 2)
    plot((prediction_output2(:, i)), 'g');
    title('prediction2');
%     subplot(2, 2, 3)
    plot((prediction_output3(:, i)), 'b');
    title('prediction3');
%     subplot(2, 2, 4)
    plot(y_test(:, i), 'r');
    title('actual');
    hold off
end

% mat = zeros(32, 32);
% 
% for i=0:(32*32)-1
%     mat(mod(i, 32)+1, floor(i/32)+1) = i+1;
% end


pai = zeros(total_area+1, 1, feature);

pred = prediction_output1;

% if feature==1
%     pai(:, :, 1) = sum(pred, 1)./sum(y_test, 1);
% else
%     pai() = sum(pred, 1)./(sum(y_test, 1)*9);
% end
pai(:, :, 1) = sum(prediction_output1, 1)./sum(y_test, 1);
pai(:, :, 2) = sum(prediction_output2, 1)./(sum(y_test, 1));
pai(:, :, 3) = sum(prediction_output3, 1)./(sum(y_test, 1));

figure;
hold on
plot(pai(:, :, 1), 'y');
plot(pai(:, :, 2), 'g');
plot(pai(:, :, 3), 'b');
hold off

pei = zeros(total_area+1, 1, feature);

for j=1:total_area+1
    for i=1:(days-TrainingDays-prediction_time)
        a =  prediction_output1(i, j);
        b =  prediction_output2(i, j);
        c =  prediction_output3(i, j);
        pei(j, 1, 1) = pei(j, 1, 1) + a/max([a, b, c]);
        pei(j, 1, 2) = pei(j, 1, 2) + b/max([a, b, c]);
        pei(j, 1, 3) = pei(j, 1, 3) + c/max([a, b, c]);
    end
    pei(j, 1, :) = pei(j, 1, :)/((days-TrainingDays-prediction_time));
%     pei(j, 1, 2) = pei(j, 1, 2)/((days-TrainingDays-prediction_time));
%     pei(j, 1, 3) = pei(j, 1, 3)/((days-TrainingDays-prediction_time));
end

figure;
hold on
plot(pei(:, :, 1), 'y');
plot(pei(:, :, 2), 'g');
plot(pei(:, :, 3), 'b');
hold off

% figure
% hold on
% title('During the training')
% plot(abs(ceil(training1')));
% plot(estm1);
% hold off
% 
% figure
% hold on
% plot(floor(prediction));
% title('prediction');
% plot(out(TrainingDays+1-prediction_time:size(input_x, 1)));
% title('actual');
% hold off
% 
% s = sum(floor(prediction));
% N = sum(out(TrainingDays+1:size(input_x, 1)));
% 
% PAI = s/N
% 
% match
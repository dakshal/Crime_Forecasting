clc;

% crime = format_matrix();
% %% prediction days
% prediction_time = 30;
% 
% %% training days
% TrainingDays = 1300;
% 
% %% defining input
% X = crime;
% Y = X;
% feature = 3;
% % Y(:,:,:, 1:(prediction_time*feature)) = [];
% n = 0.1;
% 
% %p = prediction_time;
% 
% % t = (0:0.1:TrainingDays)';
% % x = sawtooth(t);
% % w = awgn(x,length(out(:, 1)),'measured');
% 
% % random = randn(306, 1);
% 
% %n = 1000;	% number of points
% 
% iteration = 10;
% 
% training1 = zeros(iteration, TrainingDays-prediction_time);
% estm1 = zeros(TrainingDays, 1);
% k=1;
% 
% summed_crimes = sum(crime,4);
% rows=size(crime,1);
% cols=size(crime,2);
% days=size(crime,4);
% 
% reshape_crime = reshape(summed_crimes, rows*cols, 1);
% 
% [sorted_crimes,sortingIndices] = sort(reshape_crime,'descend');
% 
% total_area = 31;
% 
% %% formate data for the input
% 
% b1 = zeros(prediction_time, total_area+1, feature);
% b2 = zeros(prediction_time*2, total_area+1, feature);
% b3 = zeros(prediction_time*3, total_area+1, feature);
% 
% restructured_input1 = zeros(days, prediction_time*1, total_area+1); 
% restructured_input2 = zeros(days, prediction_time*2, total_area+1); 
% restructured_input3 = zeros(days, prediction_time*3, total_area+1); 
% 
% restructured_output= zeros(days+1, total_area+1);
% 
% restructured_output(days+1, :) = rand(1,total_area+1);
% 
% 
% for i=1:(total_area+1)
%     row = mod(sortingIndices(i),rows);
%     col = ceil(sortingIndices(i)/cols);
%     for k=0:days-1
%         for j=1:prediction_time
%             for feature=1:3
%                 if feature==1
%                     restructured_input1(k+j, j, i) = crime(row, col, 1, k+1);
%                 end
%                 if feature==2
%                     restructured_input2(k+j, j, i) = 0 - (crime(row, col, 1, k+1)/9);
%                     restructured_input2(k+j, prediction_time + j, i) = floor(mean(mean(crime(row-1:row+1, col-1:col+1, 1, k+1))));
%                 end
%                 if feature==3
%                     restructured_input3(k+j, j, i) = 0 - (crime(row, col, 1, k+1)/9);
%                     restructured_input3(k+j, prediction_time + j, i) = floor(mean(mean(crime(row-1:row+1, col-1:col+1, 1, k+1))));
%                     restructured_input3(k+j, prediction_time*2 + j, i) = crime(row, col, 1, k+1)^2;
%                 end
%             end
%         end
%         restructured_output(k+1, i) = crime(row, col, 1, k+1);
%     end
% end
% 
% restructured_input1(days+1:(days+prediction_time-1),:, :) = [];
% restructured_input1(1:(prediction_time-1),:, :) = [];
% restructured_input2(days+1:(days+prediction_time-1),:, :) = [];
% restructured_input2(1:(prediction_time-1),:, :) = [];
% restructured_input3(days+1:(days+prediction_time-1),:, :) = [];
% restructured_input3(1:(prediction_time-1),:, :) = [];
% restructured_output(1:prediction_time, :) = [];
% 

%% neural network

% layers = 3;
l1 = prediction_time*2; 
l2 = 40; 
l3 = 25; 
l4 = 10; 
l5 = 1;

nodes_in_layer = [l1, l2, l3, l4, l5];
% nodes_in_layer = [l1, l2, l5];
w1 = rand(l1, l2, total_area);
w2 = rand(l2, l3, total_area);
w3 = rand(l3, l4, total_area);
w4 = rand(l4, l5, total_area);
% w4 = rand(l2, l5, total_area);
batch_size = 25;

for i=1:total_area
%     A1 = [1;Lone];
%     j=1;
%     imp1 = zeros();
%     while j<TrainingDays
%         e = j + batch_size;
        A1 = restructured_input2(:, :, i)';
        Z2 = w1(:, :, i)'*A1;
        A2 =  sigmg(Z2);
        Z3 = w2(:, :, i)'*A2;
        A3 =  sigmg(Z3);
        Z4 = w3(:, :, i)'*A3;
        A4 =  sigmg(Z4);
        Z5 = w4(:, :, i)'*A4;
        A5 =  sigmg(Z5);    
        output = A5;
        e5 = (output.^2 - (restructured_output(:, i)'.^2))/2;
        e4 = e5*(A4.*(1- A4))';
%         e4 = e5*(A2.*(1- A2))';
        e3 = e4*(A3.*(1- A3))';
        e2 = e3*(A2.*(1- A2))';
        e1 = e2*(A1.*(1- A1))';
%         j = e+1;
        w4(:, :, i) = (e4'.*w4(:, :, i));
        w3(:, :, i) = (e3'.*w3(:, :, i));
        w2(:, :, i) = (e2'.*w2(:, :, i));
        w1(:, :, i) = (e1'.*w1(:, :, i));
%     end
end

for i=1:3
        A1 = restructured_input2(:, :, i)';
        Z2 = w1(:, :, i)'*A1;
        A2 =  sigmg(Z2);
        Z3 = w2(:, :, i)'*A2;
        A3 =  sigmg(Z3);
        Z4 = w3(:, :, i)'*A3;
        A4 =  sigmg(Z4);
        Z5 = w4(:, :, i)'*A4;
        A5 =  sigmg(Z5);    
        output = A5;
        e5 = output - restructured_output(:, i)';
        figure;
        plot(output, 'r--');
        plot(restructured_output(:, i)', 'g--');
end


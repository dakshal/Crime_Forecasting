
% Loading Data
clc;
clear all;
% load('sorted_tData.mat');    
% load('new_formatted.mat');    
load('tData2_new.mat');    


%% Normalizing Data
%  A          ->  The # of CRIMES that occur per DAY per AREA
%  test_data  ->  The specs of each crime that happened in 2012
%4  =
%5  =
%6  =
%7  =
%8  = 1 1 1 1 1 1 7
%9  = 1 1 1 1 1 1 8
%10 = 1 1 1 1 1 1 9
%11 = 1 1 1 1 1 1 10
%12 = 1 1 1 1 1 1 11
%13 = 1 1 1 1 1 1 12
%14 = 1 1 1 1 1 1 13
%15 = 1 1 1 1 1 1 14
% 8x7

%% initializing a 3D matrix for storing regional crimes/date

total_region = unique(Crime(:, 4));
prediction_time = 7;


for crt=0:19
    [in2012, in2013, in2014, in2015, in2016, in2017, out2012, out2013, out2014, out2015, out2016, out2017] = format_data(prediction_time, total_region, Y2012, Y2013, Y2014, Y2015, Y2016, crt);

    %%


    %% training days

    % X = input_x;
    n = 0.05;

    %p = prediction_time;

    %% Setting Gaussian variable
    % t = (0:0.1:366)';
    % x = sawtooth(t);
    % w = awgn(x,length(out(:, 1)),'measured');

    % random = randn(length(in(:, 1)), 1);

    %n = 1000;	% number of points

    iteration = 10;

    max_region = length(total_region(:, 1));

    % training1 = zeros(iteration, TrainingDays-prediction_time);
    % estm1 = zeros(TrainingDays, 1);
    % k=1;



    %% Auto-Regressive Model

    % X = zeros(TrainingDays-prediction_time, prediction_time+1);
    % % G = zeros(TrainingDays-prediction_time, prediction_time+1);
    % 
    % for i=prediction_time+1:TrainingDays
    %     X(i-prediction_time, :) = [1 out(i-prediction_time:i-1)];
    % %     X(i-prediction_time, :) = out(i-prediction_time:i);
    % %     G(i-prediction_time, :) = w(i-prediction_time:i);
    % end

    % Y = out';
    % Y(1:prediction_time+2) = [];

    b = zeros(prediction_time + 1, max_region);
    e = zeros(366, max_region);

    % I = eye(213);
    % H = (X)*((X'*X)\(X'));

    for i=1:max_region
        X = in2016(:, :, i);
        Y = out2016(:, i);
        B = (pinv((X'*X))*(X'*Y));
        b(:, i) = B;
        E = Y - X*B;
        e(:, i) = E;
    end


    % b = ((X'*X)\(X'*(Y(1:length(X(:,1))))));
    % b = (X'*(H*Y(1:length(X(:,1))) - Y(1:length(X(:,1)))));
    % white_coeff = b;

    % e = Y(1:length(X(:,1))) - X*b;

    % training1(1, :) = (X*b)';

    % estm1 = Y;
    % 
    % figure
    % hold on
    % title('initial');
    % plot(abs(ceil(training1')));
    % plot(estm1);
    % hold off



    for j=1:100
    %     for j=1:prediction_time+1
    %         white_coeff(j) = b(j).^i;
    %     end
    %     e = (Y(1:length(X(:,1))) - H*Y(1:length(X(:,1))));
    %     e = e - n*(Y(1:length(X(:,1))) - ceil(abs(X*b)));
        for i=1:max_region
            X = in2016(:, :, i);
            Y = out2016(:, i);
            b(:, i) = b(:, i) - (n/length(X(:,1)))*(pinv(X'*X)*(X'*(Y(1:length(X(:,1))) - e(:, i))));
            E = Y(1:length(X(:,1))) - X*b(:, i);
            e(:, i) = E;
        end
        for i=1:max_region
            X = in2012(:, :, i);
            Y = out2012(:, i);
            b(:, i) = b(:, i) - (n/length(X(:,1)))*(pinv(X'*X)*(X'*(Y(1:length(X(:,1))) - e(:, i))));
            E = Y(1:length(X(:,1))) - X*b(:, i);
            e(:, i) = (e(:, i) + E)./2;
        end
        for i=1:max_region
            X = in2015(:, :, i);
            Y = out2015(:, i);
            b(:, i) = b(:, i) - (n/length(X(:,1)))*(pinv(X'*X)*(X'*(Y(1:length(X(:,1))) - e(:, i))));
            E = Y(1:length(X(:,1))) - X*b(:, i);
            e(:, i) = (e(:, i)*2 + E)./3;
        end
        for i=1:max_region
            X = in2013(:, :, i);
            Y = out2013(:, i);
            b(:, i) = b(:, i) - (n/length(X(:,1)))*(pinv(X'*X)*(X'*(Y(1:length(X(:,1))) - e(:, i))));
            E = Y(1:length(X(:,1))) - X*b(:, i);
            e(:, i) = (e(:, i)*3 + E)./4;
        end    
        for i=1:max_region
            X = in2014(:, :, i);
            Y = out2014(:, i);
            b(:, i) = b(:, i) - (n/length(X(:,1)))*(pinv(X'*X)*(X'*(Y(1:length(X(:,1))) - e(:, i))));
            E = Y(1:length(X(:,1))) - X*b(:, i);
            e(:, i) = (e(:, i)*4 + E)./5;
        end
        j
    %     b = b - (n/length(X(:,1)))*((X'*X)\(X'*(Y(1:length(X(:,1))) - e)));
    %     e = Y(1:length(X(:,1))) - X*b;
    %     coeff = coeff - n*((X'*X)\(X'*(Y(1:length(X(:,1))) - X*white_coeff)));
    %     training1(i, :) = (X*b + e)';
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



    prediction = zeros(max_region, 60 + prediction_time );
    out_size = length(out2016(:, 1));
    prediction(:, 1:prediction_time+1) = out2016(366-prediction_time:366, :)';

    match = 0;

    for i =prediction_time+1:length(prediction(1, :))            % 8 samples in training batch
    %    wn = prediction(i-1) - prediction(i-prediction_time-1:i-2);%*(white_coeff));
        one = ones(max_region, 1);
        const = [prediction(:, i-prediction_time:i-1) one];
    %     const = prediction(i-prediction_time:i);

        %w = sqrt(0.5*p)*(random(i)+i*random(i));
        prediction(:, i) = diag(const*b + e(i, :));

        i
    %    prediction(i) = (prediction(i-prediction_time:i-1)*coeff) + sum(wn);
    end

    create_actual_prediction

    PAI_calculation

    file_name = sprintf('crime_type_#%d.mat',crt);
    save(file_name);
%     save(['crime_type_' crt])

end

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

% s = sum(floor(prediction));
% N = sum(out(TrainingDays+1:size(input_x, 1)));
% 
% PAI = s/N
% 
% match
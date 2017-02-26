
PAI = zeros(max_region, 1);
sum_predicted = zeros(max_region, 1);
sum_actual = zeros(max_region, 1);


for j=1:max_region
    for i=1:3*prediction_time
        sum_predicted(j) = sum_predicted(j) + prediction(j, i);
        sum_actual(j) = sum_actual(j) + out2017(i, j);
    end
    
    PAI(j) = (sum_predicted(j)/floor(sum_actual(j)));
    
end

figure;
plot(sum_predicted);
plot(sum_actual);

figure;
plot(PAI);  

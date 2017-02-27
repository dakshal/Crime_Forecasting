
PAI = zeros(max_region, 1);
sum_predicted = zeros(max_region, 1);
sum_actual = zeros(max_region, 1);

avg_p = 0;
avg_a = 0;
for j=1:max_region
    
    for i=1:3*prediction_time
        sum_predicted(j) = sum_predicted(j) + prediction(j, i);
        avg_p = avg_p + prediction(j, i);
        avg_a = avg_a + out2017(i, j);
        sum_actual(j) = sum_actual(j) + out2017(i, j);
    end
    
    PAI(j) = (floor(abs(sum_predicted(j)))/floor(sum_actual(j)));
    
end

figure;
plot(sum_predicted);
plot(sum_actual);

figure;
plot(PAI);  

avg_PAI = ((floor(abs(avg_p)))/avg_a)

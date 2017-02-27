

i = 1;

while i <= length(Y2017(:, 1))
    j = 1;
    while j <= max_region
        if total_region(j) == Y2017(i, 2)
            break
        end
        j = j+1;
    end
    
    k = i;
    
%     temp = zeros(366 - prediction_time, prediction_time);    
    
    while Y2017(k, 2) == Y2017(i, 2)
        out2017(Y2017(k, 1), j) = Y2017(k, 3);        
        k = k + 1;
        if k > length(Y2017(:, 1))
            break;
        end
    end
    
    i = k;
    
end

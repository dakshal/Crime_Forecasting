function [in2012, in2013, in2014, in2015, in2016, in2017, out2012, out2013, out2014, out2015, out2016, out2017] = format_data(prediction_time, total_region, Y2012, Y2013, Y2014, Y2015, Y2016, crt)

A = zeros(366, prediction_time);
B = ones(366,1);
A = [A B];
A = A + 0.01;


in2012 = A;
in2013 = A;
in2014 = A;
in2015 = A;
in2016 = A;
in2017 = A;

max_region = length(total_region(:, 1));

B = zeros(366, max_region);
B = B + 0.0001;

out2012 = B;
out2013 = B;
out2014 = B;
out2015 = B;
out2016 = B;
out2017 = B;


for i=1:max_region
    in2012(:, :, i) = A;
    in2013(:, :, i) = A;
    in2014(:, :, i) = A;
    in2015(:, :, i) = A;
    in2016(:, :, i) = A;
    in2017(:, :, i) = A;
end

i = 1;

while i <= length(Y2012(:, 1))
    j = 1;
    while j <= max_region
        if total_region(j) == Y2012(i, 2)
            break
        end
        j = j+1;
    end
    
    k = i;
    
%     temp = zeros(366 - prediction_time, prediction_time);    
    
    while Y2012(k, 2) == Y2012(i, 2)  
        if Y2012(k, 4) == crt
            for l=1:prediction_time
                if Y2012(k, 1) + l <= 366
                    in2012(Y2012(k, 1) + l, l, j) = Y2012(k, 3);
                else 
                    in2013(Y2012(k, 1) + l - 366, l, j) = Y2012(k, 3);
                end
            end
            out2012(Y2012(k, 1), j) = Y2012(k, 3);
            k = k + 1;
        else
            k = k+1;
        end
        if k > length(Y2012(:, 1))
            break;
        end
    end
    
    i = k;
    
end
i
i = 1;

while i <= length(Y2013(:, 1))
    j = 1;
    while j <= max_region
        if total_region(j) == Y2013(i, 2)
            break
        end
        j = j+1;
    end
    
    k = i;
    
%     temp = zeros(366 - prediction_time, prediction_time);    
    
    while Y2013(k, 2) == Y2013(i, 2)
        if Y2013(k, 4) == crt
            for l=1:prediction_time
                if Y2013(k, 1) + l < 60
                    in2013(Y2013(k, 1) + l, l, j) = Y2013(k, 3);
                else
                    if Y2013(k, 1) + 2 <= 366
                        in2013(Y2013(k, 1) + 2, l, j) = Y2013(k, 3);
                    else 
                        in2014(Y2013(k, 1) + 2 - 366, l, j) = Y2013(k, 3);
                    end
                end
            end
            out2013(Y2013(k, 1), j) = Y2013(k, 3);
            k = k + 1;
        else
            k = k+1;
        end
        if k > length(Y2013(:, 1))
            break;
        end
    end
    
    i = k;
    
end

i
i = 1;

while i <= length(Y2014(:, 1))
    j = 1;
    while j <= max_region
        if total_region(j) == Y2014(i, 2)
            break
        end
        j = j+1;
    end
    
    k = i;
    
%     temp = zeros(366 - prediction_time, prediction_time);    
    
    while Y2014(k, 2) == Y2014(i, 2)
        if Y2014(k, 4) == crt
            for l=1:prediction_time
                if Y2014(k, 1) + l < 60
                    in2014(Y2014(k, 1) + l, l, j) = Y2014(k, 3);
                else
                    if Y2014(k, 1) + 2 <= 366
                        in2014(Y2014(k, 1) + 2, l, j) = Y2014(k, 3);
                    else 
                        in2015(Y2014(k, 1) + 2 - 366, l, j) = Y2014(k, 3);
                    end
                end
            end
            out2014(Y2014(k, 1), j) = Y2014(k, 3);
            k = k + 1;
        else
            k = k+1;
        end
        if k > length(Y2014(:, 1))
            break;
        end
    end
    
    i = k;
    
end

i
i = 1;

while i <= length(Y2015(:, 1))
    j = 1;
    while j <= max_region
        if total_region(j) == Y2015(i, 2)
            break
        end
        j = j+1;
    end
    
    k = i;
    
%     temp = zeros(366 - prediction_time, prediction_time);    
    
    while Y2015(k, 2) == Y2015(i, 2)
        if Y2015(k, 4) == crt
            for l=1:prediction_time
                if Y2015(k, 1) + l < 60
                    in2015(Y2015(k, 1) + l, l, j) = Y2015(k, 3);
                else
                    if Y2015(k, 1) + 2 <= 366
                        in2015(Y2015(k, 1) + 2, l, j) = Y2015(k, 3);
                    else 
                        in2016(Y2015(k, 1) + 2 - 366, l, j) = Y2015(k, 3);
                    end
                end
            end
            out2015(Y2015(k, 1), j) = Y2015(k, 3);
            k = k + 1;
        else
            k = k+1;
        end
        if k > length(Y2015(:, 1))
            break;
        end
    end
    
    i = k;
    
end

i
i = 1;

while i <= length(Y2016(:, 1))
    j = 1;
    while j <= max_region
        if total_region(j) == Y2016(i, 2)
            break
        end
        j = j+1;
    end
    
    k = i;
    
%     temp = zeros(366 - prediction_time, prediction_time);    
    
    while Y2016(k, 2) == Y2016(i, 2)
        if Y2016(k, 4) == crt
            for l=1:prediction_time
                if Y2016(k, 1) + l <= 366
                    in2016(Y2016(k, 1) + l, l, j) = Y2016(k, 3);
                else 
                    in2017(Y2016(k, 1) + l - 366, l, j) = Y2016(k, 3);
                end
            end
            out2016(Y2016(k, 1), j) = Y2016(k, 3);        
            k = k + 1;
        else
            k = k+1;
        end
        if k > length(Y2016(:, 1))
            break;
        end
    end
    
    i = k;
    
end

i


% A = zeros(366 - prediction_time, prediction_time);
% 
% in2012 = A;
% in2013 = A;
% in2014 = A;
% in2015 = A;
% in2016 = A;
% in2017 = A;
% 
% max_region = length(total_region(:, 1));
% 
% for i=1:max_region
%     in2012(:, :, i) = A;
%     in2013(:, :, i) = A;
%     in2014(:, :, i) = A;
%     in2015(:, :, i) = A;
%     in2016(:, :, i) = A;
%     in2017(:, :, i) = A;
% end
% 
% i = 1;
% 
% while i <= length(Y2012(:, 1))
%     j = 1;
%     while j <= max_region
%         if total_region(j) == Y2012(i, 2)
%             break
%         end
%         j = j+1;
%     end
%     
%     k = i;
%     
% %     temp = zeros(366 - prediction_time, prediction_time);    
%     
%     while Y2012(k, 2) == Y2012(i, 2)
%         for l=1:prediction_time
%             if Y2012(k, 1) - prediction_time + 1 + l <= 366
%                 in2012(Y2012(k, 1) - prediction_time + 1 + l, prediction_time - l + 1, j) = Y2012(k, 3);
%             else 
%                 in2013(Y2012(k, 1) - prediction_time + 1 + l - 366, prediction_time - l + 1, j) = Y2012(k, 3);
%             end
%         end
%         k = k + 1;
%         if k > length(Y2012(:, 1))
%             break;
%         end
%     end
%     
%     i = k;
%     
% end
% 
% i = 1;
% 
% while i <= length(Y2013(:, 1))
%     j = 1;
%     while j <= max_region
%         if total_region(j) == Y2013(i, 2)
%             break
%         end
%         j = j+1;
%     end
%     
%     k = i;
%     
% %     temp = zeros(366 - prediction_time, prediction_time);    
%     
%     while Y2013(k, 2) == Y2013(i, 2)
%         for l=1:prediction_time
%             if Y2013(k, 1) - prediction_time + 1 + l < 60
%                 in2013(Y2013(k, 1) - prediction_time + 1 + l, prediction_time - l + 1, j) = Y2013(k, 3);
%             else
%                 if Y2013(k, 1) - prediction_time + 1 + 2 <= 366
%                     in2013(Y2013(k, 1) - prediction_time + 1 + 2, prediction_time - l + 1, j) = Y2013(k, 3);
%                 else 
%                     in2014(Y2013(k, 1) - prediction_time + 1 + 2 - 366, prediction_time - l + 1, j) = Y2013(k, 3);
%                 end
%             end
%             
%         end
%         k = k + 1;
%         if k > length(Y2013(:, 1))
%             break;
%         end
%     end
%     
%     i = k;
%     
% end
% 
% i = 1;
% 
% while i <= length(Y2014(:, 1))
%     j = 1;
%     while j <= max_region
%         if total_region(j) == Y2012(i, 2)
%             break
%         end
%         j = j+1;
%     end
%     
%     k = i;
%     
% %     temp = zeros(366 - prediction_time, prediction_time);    
%     
%     while Y2014(k, 2) == Y2014(i, 2)
%         for l=1:prediction_time
%             if Y2014(k, 1) - prediction_time + 1 + l < 60
%                 in2014(Y2014(k, 1) - prediction_time + 1 + l, prediction_time - l + 1, j) = Y2014(k, 3);
%             else
%                 if Y2014(k, 1) - prediction_time + 1 + 2 <= 366
%                     in2014(Y2014(k, 1) - prediction_time + 1 + 2, prediction_time - l + 1, j) = Y2014(k, 3);
%                 else 
%                     in2015(Y2014(k, 1) - prediction_time + 1 + 2 - 366, prediction_time - l + 1, j) = Y2014(k, 3);
%                 end
%             end
%         end
%         k = k + 1;
%         if k > length(Y2014(:, 1))
%             break;
%         end
%     end
%     
%     i = k;
%     
% end
% 
% i = 1;
% 
% while i <= length(Y2015(:, 1))
%     j = 1;
%     while j <= max_region
%         if total_region(j) == Y2015(i, 2)
%             break
%         end
%         j = j+1;
%     end
%     
%     k = i;
%     
% %     temp = zeros(366 - prediction_time, prediction_time);    
%     
%     while Y2015(k, 2) == Y2015(i, 2)
%         for l=1:prediction_time
%             if Y2015(k, 1) - prediction_time + 1 + l < 60
%                 in2015(Y2015(k, 1) - prediction_time + 1 + l, prediction_time - l + 1, j) = Y2015(k, 3);
%             else
%                 if Y2015(k, 1) - prediction_time + 1 + 2 <= 366
%                     in2015(Y2015(k, 1) - prediction_time + 1 + 2, prediction_time - l + 1, j) = Y2015(k, 3);
%                 else 
%                     in2016(Y2015(k, 1) - prediction_time + 1 + 2 - 366, prediction_time - l + 1, j) = Y2015(k, 3);
%                 end
%             end
%         end
%         k = k + 1;
%         if k > length(Y2015(:, 1))
%             break;
%         end
%     end
%     
%     i = k;
%     
% end
% 
% i = 1;
% 
% while i <= length(Y2016(:, 1))
%     j = 1;
%     while j <= max_region
%         if total_region(j) == Y2016(i, 2)
%             break
%         end
%         j = j+1;
%     end
%     
%     k = i;
%     
% %     temp = zeros(366 - prediction_time, prediction_time);    
%     
%     while Y2016(k, 2) == Y2016(i, 2)
%         for l=1:prediction_time
%             if Y2016(k, 1) - prediction_time + 1 + l <= 366
%                 in2016(Y2016(k, 1) - prediction_time + 1 + l, prediction_time - l + 1, j) = Y2016(k, 3);
%             else 
%                 in2017(Y2016(k, 1) - prediction_time + 1 + l - 366, prediction_time - l + 1, j) = Y2016(k, 3);
%             end
%         end
%         k = k + 1;
%         if k > length(Y2016(:, 1))
%             break;
%         end
%     end
%     
%     i = k;
%     
% end
% 
end
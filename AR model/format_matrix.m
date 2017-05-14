function [crime] = format_matrix()
    
    load('total_crimes.mat');

    div_x=100;
    div_y=100;


    max_x = max(x_coordinate);
    max_y = max(y_coordinate);
    least_x = min(x_coordinate);
    least_y = min(y_coordinate);

    diff_x = max_x - least_x;
    diff_y = max_y - least_y;

    
    size_x = diff_x/(div_x-1);
    size_y = diff_y/(div_y-1);


    days = max(day)+1;
    rows = size(day, 1);
    cols = 4;

    % matrix = [[[0 for col in range(div_x)] for row in range(div_y)] for x in range(days)]
    crime = zeros(div_x, div_y, 1, days);

    for i=1:rows
        d = day(i)+1;
        x = x_coordinate(i);
        y = y_coordinate(i);
        c_y = floor((y-least_y)/size_y)+1;
        c_x = floor((x-least_x)/size_x)+1;
        % print "day:- %d row:- %d col:- %d"%(day, c_y, c_x)
        % matrix[day][c_y][c_x] +=1
        crime(c_x, c_y, 1, d) = crime(c_x, c_y, 1, d) + 1 ;
        % print "day:- %d row:- %d"%(day, c_y*div_x + c_x)
        % matrix[day][c_y*div_x + c_x] +=1
    end
end
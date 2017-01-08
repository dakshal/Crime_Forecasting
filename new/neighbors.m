%% NIJ Crime Forecasting Challenge
% File to perform neighbor analysis on crime areas
% 
% Contributors : Nicholas Kumia
% Last Modified : 11.25.2016

%close all; clc;

%% Set Limits

x_min = min(cell2mat(tX_coord));
x_max = max(cell2mat(tX_coord));
y_min = min(cell2mat(tY_coord));
y_max = max(cell2mat(tY_coord));

A_x = 200;
A_y = 200;

n_x = ceil((x_max - x_min)/A_x);
n_y = ceil((y_max - y_min)/A_y);

%% Create Matrix of Area

A = zeros(n_y, n_x);

for i = 1:length(tX_coord)
    id_x = ceil((cell2mat(tX_coord(i)) - x_min)/A_x);
    id_y = ceil((cell2mat(tY_coord(i)) - y_min)/A_y);
    
    if id_x == 0
        id_x = 1;
    end
    
    if id_y == 0
        id_y = 1;
    end
    
    A(id_y, id_x) = A(id_y, id_x) + 1;
end
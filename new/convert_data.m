%% NIJ Crime Forecasting Challenge
% File to create 'mat' files for 'xlsx' data
% 
% Contributors : Nicholas Kumia
% Last Modified : 11.25.2016

% clear all;
clear CrimeType CrimeDate CrimeArea

%% Import Data
new_file = 'Crimes_Mar_2012_Jul_2016.xlsx';

x = collect(new_file);

tCrime = [x(2:end, 3)];
tDate = [x(2:end, 5)];
tX_coord = cell2mat(x(2:end, 6));
tY_coord = cell2mat(x(2:end, 7));
tCensus_tract = cell2mat(x(2:end, 8));

%% Convert the DATES from strings to numbers

Date_string  = datevec(tDate);  
Date_string  = Date_string(:, 1:3);   % [N x 3] array, no time
Date_string2 = Date_string;
Date_string2(:, 2:3) = 0;    % [N x 3], day before 01.Jan

CrimeDate = cat(2, Date_string(:, 1), datenum(Date_string) - datenum(Date_string2));


%% Convert the CRIMES from strings to numbers

k = {
    'BURG  ', 'BURGP ','PROWLP','ASSLT ','ASSLTT','ASSLTW','DIST  ','DISTP ','DISTW ','GANG  ','ROB   ','ROBP  ','ROBW  ','SHOOT ','SHOOTW','SHOTS ','STAB  ','STABW ','VICE  ','RSTLN ','VEHREC','VEHST ','VEHSTP','ASSLTP','THRET ','THRETP','THRETW','AREACK','PREMCK','SUSP  ','SUSPP ','SUSPW ','ANIML ','FWI   ','NOISE ','FWH   ','PARK  ','SCHL  ','SCHLP ','PARTY ','TMET  ','UNWNT ','UNWNTP','ASSIST','CIVIL ','FOLLOW','PROP  ','WELCK ','RIVPOL','STNDBY','WELCKP','THEFT ','FRAUD ','FRAUDP','THEFTP','VAND  ','VANDP','ACCHR ','ACCHRP','ACCINJ','TMETP ','ACCNON','DUII  ','HAZARD','WARR  ','ANIMLP'};

% k = {
%     'BURG', 'BURGP','PROWLP','ASSLT','ASSLTT','ASSLTW','DIST',{'DISTP'},'DISTW','GANG','ROB','ROBP','ROBW','SHOOT','SHOOTW','SHOTS','STAB','STABW','VICE','RSTLN','VEHREC','VEHST','VEHSTP','ASSLTP','THRET','THRETP','THRETW','AREACK','PREMCK','SUSP','SUSPP','SUSPW','ANIML','FWI','NOISE','FWH','PARK','SCHL','SCHLP','PARTY','TMET','UNWNT','UNWNTP','ASSIST','CIVIL','FOLLOW','PROP','WELCK','RIVPOL','STNDBY','WELCKP','THEFT','FRAUD','FRAUDP','THEFTP','VAND','VANDP','ACCHR','ACCHRP','ACCINJ','TMETP','ACCNON','DUII','HAZARD','WARR','ANIMLP'};

n = 66;
v = ones(n, 1);
for i = 1:66
    v(i) = i;
end

CrimeTypeDict = containers.Map(k, v);
CrimeType(1) = 0;

for i = 1:length(tCrime)
    if isKey(CrimeTypeDict, cell2mat(tCrime(i)))
        CrimeType(i) = cell2mat(values(CrimeTypeDict, tCrime(i)));
    end
end

%% Convert the X_COORD / Y_COORD / CENSUS_TRACT into Useful Data

% CrimeArea = containers.Map();

% Based on Census Tract
CrimeArea = zeros(length(tX_coord), 2);

% Set Limits

x_min = min(tX_coord);
x_max = max(tX_coord);
y_min = min(tY_coord);
y_max = max(tY_coord);

A_x = 600;
A_y = 600;

n_x = ceil((x_max - x_min)/A_x);
n_y = ceil((y_max - y_min)/A_y);

% Create Matrix of Area
for i = 1:length(tX_coord)
    id_x = ceil((tX_coord(i) - x_min)/A_x);
    id_y = ceil((tY_coord(i) - y_min)/A_y);
        
%     if id_x == 0
%         id_x = 1;
%     end
%     
%     if id_y == 0
%         id_y = 1;
%     end
%     
%     A(id_y, id_x) = A(id_y, id_x) + 1;
    
    CrimeArea(i,1) = id_x;
    CrimeArea(i,2) = id_y;
end

n = max(CrimeDate);
A = zeros(n_y*n_x, n(2));
a = zeros(n_y*n_x, 1);

for k = 1:length(tCrime)
    k
    if CrimeArea(k,2) == 0
        i = CrimeArea(k,1);
    else
        i = (CrimeArea(k,2)-1)*n_x + CrimeArea(k,1);
    end

    j = CrimeDate(k,2);
    A(i,j) = A(i,j) + 1;
    a(k,1) = i;
end

Crime = [CrimeType' CrimeDate CrimeArea];
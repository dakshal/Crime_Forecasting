% load('crime_type_#1.mat');

% for n = 1:1:15
    n
    v = n;
%     z = sprintf('type%d.mat',n);
%     load(z);
    load(type1.mat);

    random = randn(length(output(:, 1)), 1)*360000;

    for i=1:length(output(:, 1))
        x = str2num(cell2mat(output(i, 8)))/358;
        y = mod(str2num(cell2mat(output(i, 8))), 309);

        rand_x = random(i)/600;
        rand_y = mod(random(i), 600);

        x = x*600 + rand_x;
        y = y*600 + rand_y;

        output(i, 6) = {sprintf('%d', x)};
        output(i, 7) = {sprintf('%d', y)};

    end
    
    save(z, 'output');
        
% end
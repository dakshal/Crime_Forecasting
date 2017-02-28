% x_min = [7547902];
% x_max = [7762614];
% y_min = [602723];
% y_max = [787862];
% 
% x_step = (x_max - x_min) / n_x;
% y_step = (y_max - y_min) / n_y;
% 
% y_t1 = Y2017(2660:2755,:);
% 
% y_t = y_t1;

clear all;

for n = 1:1:15
    n
    v = n;
    name = sprintf('crime_type_#%d.mat',n);
    z = sprintf('type%d.mat',n);
    load(name);

    for day = 1:length(prediction(1,:))
        for i = 1:length(prediction(:,1)) 
            if(prediction(i,day)==1) 
                reg(i,day) = total_region(i); 
            end
        end
    end

    output = cell(1,8);
    a = 1;
    
    for day = 1:length(reg(1,:))
        for j = 1:length(unique(reg(:,day), 'rows'))
            temp = unique(reg(:,day), 'rows');
            if (temp(j) ~= 0)
                if v == 1
                    output(a,1) = {'BURGLARY'};
                    output(a,2) = {'PROPERTY CRIME'};
                    output(a,3) = {'BURGP'};
                    output(a,4) = {'BURGLARY - PRIORITY *H'};
                elseif v == 2
                    output(a,1) = {'BURGLARY'};
                    output(a,2) = {'SUSPICIOUS'};
                    output(a,3) = {'PROWLP'};
                    output(a,4) = {'PROWLER'};
                elseif v == 3
                    output(a,1) = {'OTHER'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'ASSLT'};
                    output(a,4) = {'ASSAULT - COLD'};
                elseif (v == 4 || v == 5)
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'ASSLTP'};
                    output(a,4) = {'ASSAULT - PRIORITY'};
                elseif v == 6
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'ASSLTW'};
                    output(a,4) = {'ASSAULT - WITH WEAPON *H'};
                elseif v == 7
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'DISORDER'};
                    output(a,3) = {'DISTP'};
                    output(a,4) = {'DISTURBANCE - PRIORITY'};
                elseif v == 8
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'DISORDER'};
                    output(a,3) = {'DISTW'};
                    output(a,4) = {'DISTURBANCE - WITH WEAPON *H'};
                elseif v == 9
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'DISORDER'};
                    output(a,3) = {'GANG'};
                    output(a,4) = {'GANG RELATED'};
                elseif v == 10
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'ROBP'};
                    output(a,4) = {'ROBBERY - PRIORITY *H'};
                elseif v == 11
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'ROBW'};
                    output(a,4) = {'ROBBERY - WITH WEAPON *H'};
                elseif v == 12
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'SHOOTW'};
                    output(a,4) = {'SHOOTING - WITH WEAPON *H'};
                elseif v == 13
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'SHOTS'};
                    output(a,4) = {'SHOTS FIRED'};
                elseif v == 14
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'STABW'};
                    output(a,4) = {'SHOTS FIRED'};
                elseif v == 15
                    output(a,1) = {'STREET CRIMES'};
                    output(a,2) = {'PERSON CRIME'};
                    output(a,3) = {'SHOTS'};
                    output(a,4) = {'SHOTS FIRED'};
                end
                    
                output(a,5) = {sprintf('1/%d/2017',day)};
                output(a,6) = {'0'};
                output(a,7) = {'0'};
                output(a,8) = {sprintf('%d',temp(j))};
                a = a+1;
            end
        end
    end
  
    save(z, 'output');
end

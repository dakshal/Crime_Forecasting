clear all;
load('input_data.mat');
% inputData=[3 2 5;
%     1 2 5;
%     1 2 5;
%     3 4 5;
%     3 6 5];

A=unique(inputData, 'rows');
a = size(A(:, 2));
Y=ones(a(1), 1);



for i=1:a(1)
    count=0;
    b = size(inputData(:,2));
    remove = [];
    for j=i+1:b(1)
%         [a(1) b(1) i j inputData(i,2) inputData(j,2)];
        if inputData(i,2)==inputData(j,2)
            if(inputData(i,1)==inputData(j,1))
                Y(i)=Y(i)+1;
                remove = [remove;j];
            end
        end
    end
    r = size(remove);
    for k=1:r(1)
            inputData(remove(k),:) = [];
    end
end
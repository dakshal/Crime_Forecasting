%% NIJ Crime Forecasting Challenge
%  Dakshal Code - BInary XOR NeuralNet
%  Contributors : Dakshal Shah, Nicholas Kumia
%  Last Modified: 11.05.2016

close all; clear all; clc;

%% Initialize weights and other constants
%  w1 : weights between layer in and 2
%  w2 : weights between layer 2 and out
%  n  : learning rate

w1 = rand(2,3);
w2 = rand(3,1);
n = 0.01;

N = 20000;

%% Exact answers
%  x : input
%  y : output

x = [0 0;
     0 0;
     1 0;
     1 1];
     
ex_y = [0 0 1 0]';

Etotal=zeros(4,N);

%% Forward propogation

in1  = x*w1;
out1 = sigmoid(in1);
in2  = out1*w2;
y    = sigmoid(in2);

for j=1:N
    sum=0;
    %% Forward propogation
    
    in1  = x*w1;
    out1 = sigmoid(in1);
    in2  = out1*w2;
    y    = sigmoid(in2);

    %% Back propogation
    diff  = (ex_y-y);
    delta = y.*(1-y);
    dw2   = out1'*(delta.*diff);
    sum   = sum+dw2;
    Etotal(:,j) = Etotal(:,j) + ((diff.^2)./2);

    %% refining w1
    dEdy = (ex_y - y);
    dydin2 = y.*(1-y);
    din2dout1 = w2';
    dout1din1 = out1.*(1-out1);
    din1dw1 = x;
    dw1 = (((dEdy .* dydin2) * din2dout1) .* dout1din1)' * din1dw1;
    w1 = w1 - n*dw1';
    w2  = w2 - n*(sum*(1/4));

end 

for i = 1:4
    subplot(2,2,i)
    plot([1:1:N],Etotal(i,:))
end
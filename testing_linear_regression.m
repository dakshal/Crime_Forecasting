syms x;

%% initializing random variable
r0=rand(1);
r1=rand(1);
r2=rand(1);
r3=rand(1);
n=0.01;

%% creating equation for Y

%R=rand(50, 1);
%X=rand(1, 50);

%for i=0:49
 %  X(i) = x^i; 
%end

%Y(x)=R*X';

%input_x=[1;2;2;3;3;4;5;6;6;6;8;10];
%input_y=[-890;-1411;-1560;-2220;-2091;-2878;-3537;-3268;-3920;-4163;-5471;-5157];
m=12;   %total no of input dates

for j=1:1000000
        
    for i=1:m
        a=i;        %i=day
        b=cr(i);    %no of crimes on that day
        w=r0+r1*a+r2*a^2+r3*a^3;
        r0=r0-(n*(w-b))/m;
        r1=r1-(n*(w-b)*(a))/m;
        r2=r2-(n*(w-b)*((a)^2))/m;
        r3=r3-(n*(w-b)*((a)^3))/m;
    %    w = [b 0 0;0 b 0;0 0 b]*pinv([1 a a^2])
    %    [r0 r1 r2]=[r0 r1 r2] - w';
    end
end
r0
r1
    
    y=r0+r1*x+r2*x^2+r3*x^3;
    ezplot(y);
    w0=subs(y,x,4)
    w1=subs(y,x,5)
    w2=subs(y,x,7)
    w3=subs(y,x,8)
    w4=subs(y,x,10)
    w5=subs(y,x,9)
    w6=subs(y,x,11)

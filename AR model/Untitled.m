g=tf(1/3,[1 .66],0.1)
disp(g);

%simulate the system
[y t]=step(g,10);  

%add some random noise
n=0.001*randn(size(t));
y1=y+n;

%plot the data with noisy datastairs(t,y);
hold on
stairs(t,y1,'r');

x=ones(size(t)); %input step

Rmat=[y1(1:end-1) x(1:end-1)];
Yout=[y1(2:end)];
P=Rmat\Yout;
disp(P);

%simulated output
Yout1=Rmat*P;

%Mean Square Error
e=sqrt(mean((Yout-Yout1).^2));
disp(e);

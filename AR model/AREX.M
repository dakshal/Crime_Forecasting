% autoregressivo di ordine p con variabile esplicativa presente e
% ritardata fino al lag b (stime ols). y e' la dipendente, x la
% esplicativa (vettori colonna). c=0: ne' costante ne' trend tra i
% regressori; c=1: costante; c=2: costante e trend. se non si specifica
% c, c e' assunto uguale a zero.
% In uscita, a e' una matrice contenente sulla prima riga i parametri
% stimati e R^2 e sulla seconda gli errori standard e R^2 corretto;
% u e' il vettore (colonna) dei residui, fit e' il vettore dei valori
% stimati, v e' la matrice di varianza-covarianza dei coefficienti
% stimati.
%
function [a,u,fit,v]=arex(y,x,p,b,c)
if nargin==4, c=0; end;
pp=max([p b]);
xx=y(pp+1:length(y));
z=x(pp+1:length(y));
for i=1:pp,
yy(:,pp+1-i)=y(i:length(y)-pp+i-1);
zz(:,pp+1-i)=x(i:length(x)-pp+i-1);
end;
zzz=[z zz];
if c==1,
cc=ones(length(xx),1);
elseif c==2,
cc=[ones(length(xx),1) (1:length(xx))'];
else
cc=[];
end;
if p==0,
reg=[cc zzz(:,1:b+1)];
else
reg=[cc yy(:,1:p) zzz(:,1:b+1)];
end;
[a,u,fit,v]=ols(xx,reg);

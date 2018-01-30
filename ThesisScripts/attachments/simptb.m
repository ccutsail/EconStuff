function [out] = simptb(x,tb,paramvec)

% This is the steady-state system without a government budget constraint

% Assign parameters
alp = paramvec(1); D = paramvec(2); etae = paramvec(3); 
etah = paramvec(4); A = paramvec(5); bp = paramvec(6);
bt = paramvec(7); 
ti = 0;
% Assign vector of state variables
k = x(1); h = x(2); c0 = x(3); c2 = x(4); te = x(5);

% Use FOCs to get output
out = [h - ((1+te)/((1-ti)*(1-alp)*A*k^alp*D^((1-etae)/etae)*etae))^(etae/(etae*(1-alp)+etah-1));
       k/h - (alp*A*bt*bp*(1-tb))^(1/(1-alp));...
       c0 - (((1+bp)*bp-1)*(A*k^alp*h^(1-alp)-k-(h^(1-etah)/D)^(1/etae)))/((1+bp)^2-1);...
       c2 - (A*k^alp*h^(1-alp)-k-c0-(h^(1-etah)/D)^(1/etae))/(bp+1)*(1-tb);...
       tb*alp*k^alp*h^(1-alp) + te*(h^(1-etah)/D)^(1/etae)];
    
   

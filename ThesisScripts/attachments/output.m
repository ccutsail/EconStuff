function [outmat] = output(ssmat,paramvec,tb,ti,te)

% assign output, parameters (for tb variation)
s1 = ssmat(:,1); h1 = ssmat(:,2); c01 = ssmat(:,3); c21 = ssmat(:,4); 
s2 = ssmat(:,5); h2 = ssmat(:,6); c02 = ssmat(:,7); c22 = ssmat(:,8);
h = ssmat(:,9); k = ssmat(:,10); w = ssmat(:,11); R = ssmat(:,12); e1 = ssmat(:,13);
e2 = ssmat(:,14); c11 = ssmat(:,15); c12 = ssmat(:,16); b1 = ssmat(:,17); b2 = ssmat(:,18); 
%{
k = ssmat(:,1); h = ssmat(:,2); 
c01 = ssmat(:,3); c21 = ssmat(:,4); s1 = ssmat(:,5); e1 = ssmat(:,6); h1 = ssmat(:,7);
c02 = ssmat(:,8); c22 = ssmat(:,9); s2 = ssmat(:,10); e2 = ssmat(:,11); h2 = ssmat(:,12);
w = ssmat(:,13); R = ssmat(:,14);
%}
alp = paramvec(1); D1 = paramvec(2); D2 = paramvec(3); 
etae = paramvec(4); etah = paramvec(5); A = paramvec(6);
bp = paramvec(7); bt = paramvec(9); n1 = paramvec(10); 
n2 = paramvec(8);



% Use definitions of variables solved residually
%% ** Problems With s1 - s2, c21 - c22, c01 - c02:: e1 - e2 are good
y = A.*k.^alp.*h.^(1-alp);
% Store all output in a matrix -- used to generate a table
outmat = [k h c01 c02 s1 e1 h1 c21 c22 s2 e2 h2 w R b1 b2 c11 c12 y];
  
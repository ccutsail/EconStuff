function [outmat] = output(ssmat,paramvec,tb,ti,te)

% assign output, parameters (for tb variation)

k = ssmat(:,1); h = ssmat(:,2); 
c0 = ssmat(:,3); c2 = ssmat(:,4); 

alp = paramvec(1); D = paramvec(2); etae = paramvec(3); 
etah = paramvec(4); A = paramvec(5); bp = paramvec(6);
bt = paramvec(7);

% Use definitions of variables solved residually

w = (1-alp).*A.*k.^(alp).*h.^(-alp);
R = (alp).*A.*k.^(alp-1).*h.^(1-alp);

s = k;
e = (h.^(1-etah)./D).^(1/etae);

y = A.*k.^(alp).*h.^(1-alp);

b = R.*s - c2;
c = (1-ti).*w.*h + (1-tb).*(b) - s - (1+te).*e - c0;

G = ti.*(1-alp).*A.*k.^alp.*h.^(1-alp)+tb.*(alp.*A.*k.^(alp).*h.^(1-alp)-c2)+te.*(h.^(1-etah)/D).^(1/etae);
% Store all output in a matrix -- used to generate a table
outmat = [k h c0 c2 s e w R b c G y];

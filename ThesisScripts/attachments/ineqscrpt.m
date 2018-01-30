close all
clear all
% Initial Conditions
x0 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
% Vector of Parameters (I find this easier to work with than having each 
% individually assigned)
paramvec = [0.25; 2; 1; 0.5; 0.5; 1; 0.95; 0.95; 0.5;0.5]; 
           % alp, D1,D2,etae,etah,A, bp,   bt,  n1,  n2

% Subsidy rate is constant
te = -0.25;
% Turn off output for fsolve -- preferential//unnecessary for results
options = optimset('Display','off');
ti = 0.25;
% Let bequest tax range from 0.01 (negligible) to 0.08 (pretty high)
for tb = 0.01:0.01:0.8;
        [sol,fval,ext] = fsolve(@(x)ineq2(x,tb,te,ti,paramvec),x0,options);
        % Store output in a matrix
        ssmat(round(tb*100),:)= sol;
        resmat(round(tb*100),:)= fval;
        extmat1(round(abs(tb*100)),:) = ext;
        % Update initial conditions with each iteration -- should speed up
        % fsolve
        x0 = sol;
end
tb = 0.25;
display('Great Success')

%{

x0 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1];
for ti = 0.01:0.01:0.8;
        [sol,fval,ext] = fsolve(@(x)ineq(x,tb,te,ti,paramvec),x0,options);
        % Store output in a matrix
        ssmat2(round(ti*100),:)= sol;
        extmat2(round(abs(ti*100)),:) = ext;
        % Update initial conditions with each iteration -- should speed up
        % fsolve
        x0 = sol;
end
ti = 0.25; tb = 0.25;
x0 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1];
display('Great Success 2')
for te = -0.01:-0.01:-0.8;
        [sol,fval,ext] = fsolve(@(x)ineq(x,tb,te,ti,paramvec),x0,options);
        % Store output in a matrix
        ssmat3(round(abs(te*100)),:)= sol;
        extmat3(round(abs(te*100)),:) = ext;
        % Update initial conditions with each iteration -- should speed up
        % fsolve
        x0 = sol;
end
display('Great Success 3')
% assign output, parameters (for tb variation)
tb = (0.01:0.01:0.8)'; ti = 0.25; te = -0.25;
%}
[outmat] = output(ssmat,paramvec,tb,ti,te);
% Store all output in a matrix -- used to generate a table
% indices  [1,2,3,  4,  5, 6, 7, 8,  9,  10,-1 -2 3 4 5  6  7   8   9]
% outmat = [k h c01 c21 s1 e1 h1 c02 c22 s2 e2 h2 w R b1 b2 c11 c12 G];
% Assign these

k = outmat(:,1); h = outmat(:,2); c01 = outmat(:,3); c21 = outmat(:,4);
s1 = outmat(:,5); e1 = outmat(:,6); h1 = outmat(:,7); c02 = outmat(:,8);
c22 = outmat(:,9); s2 = outmat(:,10); e2 = outmat(:,11); h2 = outmat(:,12);
w = outmat(:,13); R = outmat(:,14); b1 = outmat(:,15); b2 = outmat(:,16);
c11 = outmat(:,17); c12 = outmat(:,18); y = outmat(:,19)

for i=1:min(size(outmat));
    figure(8)
    hold on
    plot(real(outmat(:,i)))
    title('All Variables')
end
%{
tb2 = 0.25; ti2 = (0.01:0.01:0.8)'; te2 = -0.25;
[outmat2] = output(ssmat2,paramvec,tb2,ti2,te);
te3 = (-0.01:-0.01:-0.8)'; ti3 = 0.25; tb3 = 0.25;
[outmat3] = output(ssmat3,paramvec,tb3,ti3,te3);


% Define the value function and felicitous utility functions anonymously
valfun = @(c1,c2,c3,bt,bp)log(c2) + bt.*log(c3) + bp.*(log(c1)+bt.*log(c2)+bt^2.*log(c3));
felicitous = @(c1,c2,c3,bt)log(c1) + bt.*log(c2) + bt^2.*log(c3);

extmat = [extmat1,extmat2,extmat3];


% Partition output matrix
outmatpart(1,:) = outmat(1,:);outmatpart(2,:) = outmat(10,:);
outmatpart(3,:) = outmat(20,:);outmatpart(4,:) = outmat(40,:);
outmatpart(5,:) = outmat(60,:);outmatpart(6,:) = outmat(80,:);

tab1 = latex(outmatpart,'%.4f'); % Generate table


outmatpart(1,:) = outmat2(1,:);outmatpart(2,:) = outmat2(10,:);
outmatpart(3,:) = outmat2(20,:);outmatpart(4,:) = outmat2(40,:);
outmatpart(5,:) = outmat2(60,:);outmatpart(6,:) = outmat2(80,:);

tab2 = latex(outmatpart,'%.4f'); % Generate table

outmatpart(1,:) = outmat3(1,:);outmatpart(2,:) = outmat3(10,:);
outmatpart(3,:) = outmat3(20,:);outmatpart(4,:) = outmat3(40,:);
outmatpart(5,:) = outmat3(60,:);

tab3 = latex(outmatpart,'%.4f'); % Generate table
%}
figure(1)
hold on; 
plot(c11); 
plot(c12); 
legend('Bequest Tax C1','Income Tax C1','Bequest Tax C2','Income Tax C2')

figure(2)
hold on;
plot(k./h);  
plot(h); 

legend('Bequest Tax k/h','Income Tax k/h','Bequest Tax h','Income Tax h')

figure(3);
hold on;
plot(tb.*(b1+b2));
legend('Bequest Tax Revenues, Bequest Variation', 'Bequest Tax Revenues, Income Variation')

figure(4);
hold on; 
plot(ti.*w.*h);
legend('Income Tax Revenues, Bequest Variation', 'Income Tax Revenues, Income Variation')

figure(5);
hold on; 
plot(te.*(e1+e2));
legend('Educational Subsidies, Bequest Variation', 'Educational Subsidies, Income Variation')

%{
figure(6); 
hold on; 
plot(real(felicitous(outmat(:,4),outmat(:,2),outmat(:,5),paramvec(7))))
plot(real(felicitous(outmat2(:,4),outmat2(:,2),outmat2(:,5),paramvec(7))))
%plot(felicitous(outmat3(:,4),outmat3(:,2),outmat3(:,5),paramvec(7)))
plot(real(valfun(outmat(:,4),outmat(:,2),outmat(:,5),paramvec(7),paramvec(6))))
plot(real(valfun(outmat2(:,4),outmat2(:,2),outmat2(:,5),paramvec(7),paramvec(6))))
%plot(valfun(outmat3(:,4),outmat3(:,2),outmat3(:,5),paramvec(7),paramvec(6)))
legend('Felicitious Utility - Bequest Tax','Felicitious Utility - Income Tax','Value Function - Bequest','Value Function - Income')
%}
figure(7);
hold on;
plot(h1);
plot(h2);

alp = paramvec(1); D1 = paramvec(2); etae = paramvec(3); 
etah = paramvec(4); A = paramvec(5); bp = paramvec(6);
bt = paramvec(7); n1 = paramvec(9); n2 = paramvec(10); 
D2 = paramvec(8);


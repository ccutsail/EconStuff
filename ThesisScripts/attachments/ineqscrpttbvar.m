% Initial Conditions
x0 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 -0.01];
% Vector of Parameters (I find this easier to work with than having each 
% individually assigned)
paramvec = [0.25; 2; 1; 0.5; 0.3; 3; 0.98; 0.98; 0.5;0.5]; 
           % alp, D1,D2,etae,etah,A, bp,   bt,  n1,  n2
n1 = 0.5; n2 = 0.5;

% Turn off output for fsolve -- preferential//unnecessary for results
options = optimset('Display','off');

clear ssmat
clear resmat
clear extmat1
clear outmatpart
clear outmat

% Let bequest tax range from 0.01 (negligible) to 0.08 (pretty high)
for tbtbin = 0:0.01:0.8;
        [sol,fval,ext] = fsolve(@(x)ineq2b(x,tbtbin,paramvec),x0,options);
        % Store output in a matrix
        ssmat(round(tbtbin*100)+1,:)= sol;
        resmat(round(tbtbin*100)+1,:)= fval;
        extmat1(round(abs(tbtbin*100))+1,:) = ext;
        % Update initial conditions with each iteration -- should speed up
        % fsolve
        x0 = real(sol);
end

% assign output, parameters (for tb variation)
tbtbin = (0:0.01:0.8)'; 
tetbin = ssmat(:,19);
titbin = 0;
[outmat] = output(ssmat,paramvec,tbtbin,titbin,tetbin);
% Store all output in a matrix -- used to generate a table
% indices  [1,2,3,  4,  5, 6, 7, 8,  9,  10,-1 -2 3 4 5  6  7   8   9]
% outmat = [k h c01 c21 s1 e1 h1 c02 c22 s2 e2 h2 w R b1 b2 c11 c12 G];
% Assign these
bt = 0.98; bp = 0.98;


ktbin = outmat(:,1); 
htbin = outmat(:,2); 
c01tbin = outmat(:,3); 
c02tbin = outmat(:,4);
s1tbin = outmat(:,5); 
e1tbin = outmat(:,6); 
h1tbin = outmat(:,7); 


c21tbin = outmat(:,8);
c22tbin = outmat(:,9); 
s2tbin = outmat(:,10); 
e2tbin = outmat(:,11); 
h2tbin = outmat(:,12);
wtbin = outmat(:,13); 

Rtbin = outmat(:,14); 
b1tbin = outmat(:,15); 
b2tbin = outmat(:,16);
c11tbin = outmat(:,17); 
c12tbin = outmat(:,18); 
ytbin = outmat(:,19);
%for i=1:min(size(outmat));
%    figure(8)
%    hold on
%    plot(outmat(:,i))
%    title('All Variables')
%end





tb2 = 0.25; ti2 = (0.01:0.01:0.4)'; te2 = -0.25;
%{
% Define the value function and felicitous utility functions anonymously
valfun = @(c1,c2,c3,bt,bp)log(c2) + bt.*log(c3) + bp.*(log(c1)+bt.*log(c2)+bt^2.*log(c3));
felicitous = @(c1,c2,c3,bt)log(c1) + bt.*log(c2) + bt^2.*log(c3);


% Partition output matrix
outmatpart(1,:) = outmat(1,:);outmatpart(2,:) = outmat(10,:);
outmatpart(3,:) = outmat(20,:);outmatpart(4,:) = outmat(40,:);
outmatpart(5,:) = outmat(60,:);outmatpart(6,:) = outmat(80,:);

outmatpart = [[0.01;0.1;0.2;0.4;0.6;0.8],outmatpart(:,1:7),[0.01;0.1;0.2;0.4;0.6;0.8],....
    outmatpart(:,8:13),[0.01;0.1;0.2;0.4;0.6;0.8],outmatpart(:,14:19)];

tabtb1 = latex(outmatpart(:,1:8),'%.4f'); % Generate table
tabtb2 = latex(outmatpart(:,9:15),'%.4f'); % Generate table
tabtb3 = latex(outmatpart(:,16:end),'%.4f');
cd C:\Users\math-student\Desktop\Inequality
% cd ~\Inequality\Output\Tables

fileID = fopen('tbtables.txt','w');


fprintf(fileID,tabtb1);
fprintf(fileID,tabtb2);
fprintf(fileID,tabtb3);
fclose(fileID);
%{
%figure1=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(1)
hold on; 
plot(c11tbin); 
plot(c12tbin); 
legend('Type 1, \tau^b','Type 2, \tau^b','Location','Southwest')
title('Adult Consumption')
xlabel('\tau\in[0.01,0.8')
%figure2=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(2)
hold on;
plot(ktbin);  
plot(htbin); 
legend('h, \tau^b','k, \tau^b','Location','Southwest')
title('Capital and Human Capital')
xlabel('\tau\in[0.01,0.8]')

%figure3=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(3)
hold on;
plot(tbtbin.*(b1tbin*n1+b2tbin*n2));
legend('\tau^b','Location','Southeast')
title('Bequest Tax Revenues')
xlabel('\tau\in[0.01,0.8]')

%figure5=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(5)
hold on; 
plot(tetbin.*(e1tbin*n1+e2tbin*n2));
legend('\tau^b','Location','Southeast');
title('Educational Subsidies')
xlabel('\tau\in[0.01,0.8]')

%figure6=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(6)
hold on; 
plot(real(valfun(c01tbin,c11tbin,c21tbin,bt,bp)))
plot(real(valfun(c02tbin,c12tbin,c22tbin,bt,bp)))
plot(real(felicitous(c01tbin,c11tbin,c21tbin,bt)))
plot(real(felicitous(c02tbin,c12tbin,c22tbin,bt)))
legend('V^1','V^2','F^1','F^2')
title('Utility Levels, Bequest Taxation')
xlabel('\tau^b\in[0.01,0.8]')
saveas(gcf,'utilstb2.png')
%figure8=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(8)
hold on;
plot(c01tbin)
plot(c02tbin)
plot(c21tbin)
plot(c22tbin)
title('Young/Old Consumption by Type Under Bequest Taxation')
legend('c_{01}','c_{02}','c_{21}','c_{22}')
xlabel('\tau^b\in[0.01,0.8]')
saveas(gcf,'tbconsplot.png')
%figure9=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(9)
hold on
plot(e1tbin);
plot(e2tbin);
legend('e_1, \tau^b','e_2, \tau^b')
title('Human Capital Expenditure by Type')
xlabel('\tau\in[0.01,0.8]')

%figure10=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(10)
hold on
plot(s1tbin)
plot(s2tbin)
legend('s_1','s_2')
title('Savings Levels by Type')
xlabel('\tau\in[0.01,0.8]')


%figure12=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)

figure(12)
hold on
plot(b1tbin./(wtbin.*h1tbin+b1tbin))
plot(b2tbin./(wtbin.*h2tbin+b2tbin))
legend('b_1/(wh_1+b_1),\tau^b','b_2/(wh_2+b_2),\tau^b')
title('Bequests by Type')
xlabel('\tau\in[0.01,0.8]')


figure(11)
hold on
plot(ytbin)
legend('y(\tau^b)')
title('Per Capita Output')
xlabel('\tau\in[0.01,0.8]')

%}
cd C:\Users\math-student\Desktop\Inequality
%}
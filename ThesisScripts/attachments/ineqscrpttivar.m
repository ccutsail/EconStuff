clear ssmat
clear resmat
clear extmat1
% Initial Conditions
x0 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 -0.1];
% Vector of Parameters (I find this easier to work with than having each 
% individually assigned)
paramvec = [0.25; 2; 1; 0.5; 0.3; 3; 0.98; 0.98; 0.5;0.5]; 
% alp, D1,D2,etae,etah,A, bp,   bt,  n1,  n2
bp = 0.98; bt = 0.98;
n1 = 0.5; n2 = 0.5;

% Subsidy rate is constant
% Turn off output for fsolve -- preferential//unnecessary for results
options = optimset('Display','off');

% Turn off output for fsolve -- preferential//unnecessary for results
options = optimset('Display','off');
clear ssmat
clear resmat
% Let bequest tax range from 0.01 (negligible) to 0.08 (pretty high)
for titin = 0:0.01:0.35;
        [sol,fval,ext] = fsolve(@(x)ineq2i(x,titin,paramvec),x0,options);
        % Store output in a matrix
        ssmat(round(titin*100)+1,:)= sol;
        resmat(round(titin*100)+1,:)= fval;
        extmat2(round(abs(titin*100))+1,:) = ext;
        % Update initial conditions with each iteration -- should speed up
        % fsolve
        x0 = sol;
end
tetin = ssmat(:,19);
% assign output, parameters (for tb variation)
titin = (0:0.01:0.35)'; 
tbtin = 0;
[outmat] = output(ssmat,paramvec,tbtin,titin,tetin);
% Store all output in a matrix -- used to generate a table
% indices  [1,2,3,  4,  5, 6, 7, 8,  9,  10,-1 -2 3 4 5  6  7   8   9]
% outmat = [k h c01 c21 s1 e1 h1 c02 c22 s2 e2 h2 w R b1 b2 c11 c12 G];
% Assign these

ktiin = outmat(:,1); htiin = outmat(:,2); c01tiin = outmat(:,3); c02tiin = outmat(:,4);
s1tiin = outmat(:,5); e1tiin = outmat(:,6); h1tiin = outmat(:,7); c21tiin = outmat(:,8);
c22tiin = outmat(:,9); s2tiin = outmat(:,10); e2tiin = outmat(:,11); h2tiin = outmat(:,12);
wtiin = outmat(:,13); Rtiin = outmat(:,14); b1tiin = outmat(:,15); b2tiin = outmat(:,16);
c11tiin = outmat(:,17); c12tiin = outmat(:,18); ytiin = outmat(:,19);

%for i=1:min(size(outmat));
%    figure(8)
%    hold on
%    plot(outmat(:,i))
%    title('All Variables')
%end
%{



% Define the value function and felicitous utility functions anonymously
valfun = @(c1,c2,c3,bt,bp)log(c2) + bt.*log(c3) + bp.*(log(c1)+bt.*log(c2)+bt^2.*log(c3));
felicitous = @(c1,c2,c3,bt)log(c1) + bt.*log(c2) + bt^2.*log(c3);

clear outmatpart

% Partition output matrix
outmatpart(1,:) = outmat(1,:);outmatpart(2,:) = outmat(10,:);
outmatpart(3,:) = outmat(20,:);outmatpart(4,:) = outmat(40,:);
outmatpart(5,:) = outmat(60,:);outmatpart(6,:) = outmat(80,:);


outmatpart = [[0.01;0.1;0.2;0.4;0.6;0.8],outmatpart(:,1:7),[0.01;0.1;0.2;0.4;0.6;0.8],....
    outmatpart(:,8:13),[0.01;0.1;0.2;0.4;0.6;0.8],outmatpart(:,14:19)];

tabti1 = latex(outmatpart(:,1:8),'%.4f') % Generate table
tabti2 = latex(outmatpart(:,9:15),'%.4f') % Generate table
tabti3 = latex(outmatpart(:,16:end),'.%4f')
cd C:\Users\math-student\Desktop\Inequality
% cd ~\Inequality\Output\Tables

fileID = fopen('titables.txt','w');


fprintf(fileID,tabti1);
fprintf(fileID,tabti2);
fprintf(fileID,tabti3)
fclose(fileID);

%{
%figure1=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(1)
hold on; 
plot(c11tiin); 
plot(c12tiin); 
legend('i=1, \tau^b','i=2, \tau^b','i=1, \tau^i','i=2, \tau^i','Location','Southwest')
title('Adult Consumption')
xlabel('\tau\in[0.01,0.8')
saveas(gcf,'adcons2.png')



%figure2=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(2)
hold on;
plot(ktiin);  
plot(htiin); 
legend('h, \tau^b','k, \tau^b','h, \tau^i','k, \tau^i','Location','Southwest')
title('Capital and Human Capital')
xlabel('\tau\in[0.01,0.8]')
saveas(gcf,'hk2.png')

%figure4=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(4)
hold on; 
plot(titin.*wtiin.*htiin);
legend('\tau^b','\tau^i')
title('Income Tax Revenues')
xlabel('\tau\in[0.01,0.8]')
saveas(gcf,'tirev2.png')



%figure5=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(5)
hold on; 
plot(tetin.*(e1tiin*n1+e2tiin*n2));
legend('\tau^b','\tau^i','Location','Southeast');
title('Educational Subsidies')
xlabel('\tau\in[0.01,0.8]')
saveas(gcf,'edsub.png')



%figure6=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(14)
hold on; 
plot(real(valfun(c01tiin,c11tiin,c21tiin,bt,bp)))
plot(real(valfun(c02tiin,c12tiin,c22tiin,bt,bp)))
plot(real(felicitous(c01tiin,c11tiin,c21tiin,bt)))
plot(real(felicitous(c02tiin,c12tiin,c22tiin,bt)))
legend('V^1','V^2','F^1','F^2')
title('Utility Levels, Income Taxation')
xlabel('\tau^i\in[0.01,0.8]')
saveas(gcf,'tiutils.png')

%figure8=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(13)
hold on;
plot(c01tiin)
plot(c02tiin)
plot(c21tiin)
plot(c22tiin)
title('Young/Old Consumption by Type Under Income Taxation')
legend('c_{01}','c_{02}','c_{21}','c_{22}')
xlabel('\tau^i\in[0.01,0.8]')
saveas(gcf,'constipplt.png')



%figure9=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)
figure(9)
hold on
plot(e1tiin);
plot(e2tiin);
legend('e_1, \tau^b','e_2, \tau^b','e_1, \tau^i','e_2, \tau^i')
title('Human Capital Expenditure by Type')
xlabel('\tau\in[0.01,0.8]')
saveas(gcf,'e2.png')

%figure12=figure('Position', [100, 100, 800, 1200]);
%subplot(3,1,1)


figure(11)
hold on
plot(ytiin)
legend('y(\tau^b)','y(\tau^i)')
title('Per Capita Output')
xlabel('\tau\in[0.01,0.8]')
saveas(gcf,'y2.png')
%}
cd C:\Users\math-student\Desktop\Inequality
%}
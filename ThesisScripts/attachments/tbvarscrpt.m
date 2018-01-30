
clear all
close all
% Initial Conditions
x0 = [1 1 1 1 0];
% Vector of Parameters (I find this easier to work with than having each 
% individually assigned)
paramvec = [0.25; 1; 0.5; 0.3; 3; 0.98; 0.98]; % alp, D, etae, etah, A, bp

% Turn off output for fsolve -- preferential//unnecessary for results
options = optimset('Display','off');
% Let bequest tax range from 0.01 (negligible) to 0.08 (pretty high)
for tbtb = 0:0.01:0.8;
        [sol,fval,ext] = fsolve(@(x)simptb(x,tbtb,paramvec),x0,options);
        % Store output in a matrix
        ssmat(round(tbtb*100)+1,:)= sol;
        extmat1(round(abs(tbtb*100))+1,:) = ext;
        % Update initial conditions with each iteration -- should speed up
        % fsolve
        x0 = sol;
end

% assign output, parameters (for tb variation)
tbtb = (0:0.01:0.8)'; titb = 0; tetb = ssmat(:,5);
[outmat] = output(ssmat,paramvec,tbtb,titb,tetb);
% Store all output in a matrix -- used to generate a table
% indices  [  1, 2, 3, 4,  5,  6,    7, 8, 9, 10,11 ]
% outmat = [ c1, s, e, c0, c2, k./h, h, y, R, w, b, ];

% Define the value function and felicitous utility functions anonymously
valfun = @(c1,c2,c3,bt,bp)log(c2) + bt.*log(c3) + bp.*(log(c1)+bt.*log(c2)+bt^2.*log(c3));
felicitous = @(c1,c2,c3,bt)log(c1) + bt.*log(c2) + bt^2.*log(c3);

% Partition output matrix
outmatpart(1,:) = outmat(1,:);outmatpart(2,:) = outmat(10,:);
outmatpart(3,:) = outmat(20,:);outmatpart(4,:) = outmat(40,:);
outmatpart(5,:) = outmat(60,:);outmatpart(6,:) = outmat(80,:);

outmatpart = [[0.01;0.1;0.2;0.4;0.6;0.8],outmatpart(:,1:5),[0.01;0.1;0.2;0.4;0.6;0.8],outmatpart(:,6:end)]

tab1 = latex(outmatpart(:,1:6),'%.4f'); % Generate table
tab12 = latex(outmatpart(:,7:end),'%.4f'); % Generate table

ktb = outmat(:,1);
htb = outmat(:,2);
c0tb = outmat(:,3);
c2tb = outmat(:,4);
stb = outmat(:,5);
etb = outmat(:,6);
wtb = outmat(:,7);
Rtb = outmat(:,8);
btb = outmat(:,9);
ctb = outmat(:,10);
Gtb = outmat(:,11);
ytb = outmat(:,12);
tetb = ssmat(:,5);
%{
% Change directory to save output -- prevents clutter
% Windows
cd C:\Users\math-student\Desktop\simpmod
% Mac
% cd ~\Output\Tables

fileID = fopen('tbtable.txt','w');
fprintf(fileID,tab1);
fprintf(fileID,tab12);
fclose(fileID);
%{
cd E:\simpmod\Output\Plots

figure(1)
hold on; 
plot(ktb); 
legend('tau^b','tau^i','tau^e')
title('Capital/Unit of Effective Labor')
saveas(gcf,'k.png')

figure(2)
hold on;
plot(htb); 
legend('tau^b','tau^i','tau^e')
title('Human Capital/Unit of Effective Labor')
saveas(gcf,'h.png')

figure(3);
hold on;
plot(tbtb.*btb);
legend('tau^b','tau^i','tau^e')
title('Bequest Tax Revenues')
saveas(gcf,'beqrev.png')

figure(5);
hold on; 
plot(tetb.*etb);
legend('tau^b','tau^i','tau^e')
title('Government Expenditure on Education Subsidy')
saveas(gcf,'govedex.png')

bt= 0.95;bp = 0.95;
figure(6); 
hold on; 
plot(felicitous(c0tb,ctb,c2tb,bt));
legend('tau^b','tau^i','tau^e')
title('Felicitous Utility')
saveas(gcf,'utils.png')


figure(7)
subplot(3,1,1)
hold on
plot(c0tb./((1-titb).*wtb.*htb+(1-tbtb).*btb));
plot(ctb./((1-titb).*wtb.*htb+(1-tbtb).*btb));
plot(stb./((1-titb).*wtb.*htb+(1-tbtb).*btb));
plot(etb./((1-titb).*wtb.*htb+(1-tbtb).*btb));
legend('c_0','c_1','s','e')
title('Allocation-Income Ratios--tau^b,tau^i, tau^e')
saveas(gcf,'incrat.png')

figure(8)
hold on
plot(btb);
title('Bequests')
legend('tau^b','tau^i')
saveas(gcf,'b.png')

%}
cd C:\Users\math-student\Desktop\simpmod
% cd `\simpmod
%}
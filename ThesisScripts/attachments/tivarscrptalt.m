clear ssmat
clear resmat
clear extmat1
clear outmatpart
clear outmat
% Initial Conditions
x0 = [0.6594 1.0213 0.3404 0.3620 0.3547 0];
% Vector of Parameters (I find this easier to work with than having each 
% individually assigned)
paramvec = [0.25; 1; 0.5; 0.3; 3; 0.98; 0.98]; % alp, D, etae, etah, A, bp

% Turn off output for fsol ve -- preferential//unnecessary for results
options = optimset('Display','off');
% Let bequest tax range from 0.01 (negligible) to 0.08 (pretty high)
for titi = 0:0.01:0.8;
        [sol,fval,ext] = fsolve(@(x)simptialt(x,titi,paramvec),x0,options);
        % Store output in a matrix
        ssmat(round(titi*100)+1,:)= sol;
        extmat1(round(abs(titi*100))+1,:) = ext;
        % Update initial conditions with each iteration -- should speed up
        % fsolve
        x0 = sol;
end



% assign output, parameters (for tb variation)
titi = (0:0.01:0.8)'; tbti = 0; teti = ssmat(:,5);
[outmat] = output(ssmat,paramvec,tbti,titi,teti);
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


kti2 = ssmat(:,1);
hti2 = ssmat(:,2);
c0ti2 = ssmat(:,3);
c2ti2 = ssmat(:,4);
sti2 = outmat(:,5);
eti2 = outmat(:,6);
wti2 = outmat(:,7);
Rti2 = outmat(:,8);
bti2 = outmat(:,9);
cti2 = ssmat(:,5);
Gti2 = outmat(:,11);
yti2 = outmat(:,12);
teti2 = ssmat(:,6);
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
plot(kti); 
legend('tau^b','tau^i','tau^e')
title('Capital/Unit of Effective Labor')
saveas(gcf,'k.png')

figure(2)
hold on;
plot(hti); 
legend('tau^b','tau^i','tau^e')
title('Human Capital/Unit of Effective Labor')
saveas(gcf,'h.png')

figure(3);
hold on;
plot(tbti.*bti);
legend('tau^b','tau^i','tau^e')
title('Bequest Tax Revenues')
saveas(gcf,'beqrev.png')

figure(5);
hold on; 
plot(teti.*eti);
legend('tau^b','tau^i','tau^e')
title('Government Expenditure on Education Subsidy')
saveas(gcf,'govedex.png')

bt= 0.95;bp = 0.95;
figure(6); 
hold on; 
plot(felicitous(c0ti,cti,c2ti,bt));
legend('tau^b','tau^i','tau^e')
title('Felicitous Utility')
saveas(gcf,'utils.png')


figure(7)
subplot(3,1,1)
hold on
plot(c0ti./((1-titi).*wti.*hti+(1-tbti).*bti));
plot(cti./((1-titi).*wti.*hti+(1-tbti).*bti));
plot(sti./((1-titi).*wti.*hti+(1-tbti).*bti));
plot(eti./((1-titi).*wti.*hti+(1-tbti).*bti));
legend('c_0','c_1','s','e')
title('Allocation-Income Ratios--tau^b,tau^i, tau^e')
saveas(gcf,'incrat.png')

figure(8)
hold on
plot(bti);
title('Bequests')
legend('tau^b','tau^i')
saveas(gcf,'b.png')
%}
cd C:\Users\math-student\Desktop\simpmod
% cd `\simpmod
%}
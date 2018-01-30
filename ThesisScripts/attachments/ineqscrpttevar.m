% Initial Conditions
x0 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
% Vector of Parameters (I find this easier to work with than having each 
% individually assigned)
paramvec = [0.25; 2; 1; 0.5; 0.3; 3; 0.98; 0.98; 0.5;0.5]; 
           % alp, D1,D2,etae,etah,A, bp,   bt,  n1,  n2
bt = 0.95; bp = 0.95;
% Subsidy rate is constant

% Turn off output for fsolve -- preferential//unnecessary for results
options = optimset('Display','off');
ti = 0.25;
tb = 0;
% Turn off output for fsolve -- preferential//unnecessary for results
options = optimset('Display','off');
clear ssmat
clear resmat
% Let bequest tax range from 0.01 (negligible) to 0.08 (pretty high)
for te = -0.01:-0.01:-0.8;
        [sol,fval,ext] = fsolve(@(x)ineq2(x,tb,te,ti,paramvec),x0,options);
        % Store output in a matrix
        ssmat(round(te*-100),:)= sol;
        resmat(round(te*-100),:)= fval;
        extmat3(round(abs(te*-100)),:) = ext;
        % Update initial conditions with each iteration -- should speed up
        % fsolve
        x0 = sol;
end
% assign output, parameters (for tb variation)
ssmat = ssmat(1:64,:);
[outmat] = output(ssmat,paramvec,tb,ti,te);
% Store all output in a matrix -- used to generate a table
% indices  [1,2,3,  4,  5, 6, 7, 8,  9,  10,-1 -2 3 4 5  6  7   8   9]
% outmat = [k h c01 c21 s1 e1 h1 c02 c22 s2 e2 h2 w R b1 b2 c11 c12 G];
% Assign these

k = outmat(:,1); h = outmat(:,2); c01 = outmat(:,3); c02 = outmat(:,4);
s1 = outmat(:,5); e1 = outmat(:,6); h1 = outmat(:,7); c21 = outmat(:,8);
c22 = outmat(:,9); s2 = outmat(:,10); e2 = outmat(:,11); h2 = outmat(:,12);
w = outmat(:,13); R = outmat(:,14); b1 = outmat(:,15); b2 = outmat(:,16);
c11 = outmat(:,17); c12 = outmat(:,18); y = outmat(:,19);

%for i=1:min(size(outmat));
%    figure(8)
%    hold on
%    plot(outmat(:,i))
%    title('All Variables')
%end




% Define the value function and felicitous utility functions anonymously
valfun = @(c1,c2,c3,bt,bp)log(c2) + bt.*log(c3) + bp.*(log(c1)+bt.*log(c2)+bt^2.*log(c3));
felicitous = @(c1,c2,c3,bt)log(c1) + bt.*log(c2) + bt^2.*log(c3);



% Partition output matrix
outmatpart(1,:) = outmat(1,:);outmatpart(2,:) = outmat(10,:);
outmatpart(3,:) = outmat(20,:);outmatpart(4,:) = outmat(40,:);
outmatpart(5,:) = outmat(60,:);


tabed1 = latex(outmatpart(:,1:9),'%.4f'); % Generate table
tabed2 = latex(outmatpart(:,10:19),'%.4f'); % Generate table


cd E:\Inequality\Output\Tables
% ~cd \Inequality\Output\Tables

fileID = fopen('edtables.txt','w');

fprintf(fileID,tabed1);
fprintf(fileID,tabed2); 
fclose(fileID);

cd E:\Inequality\Output\Plots

figure(1)
subplot(3,1,3)
hold on; 
plot(c11); 
plot(c12); 
legend('Type 1','Type 2','Location','Southwest')
title('Adult Consumption Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'c11.png')

figure(2)
subplot(3,1,3)
hold on;
plot(k);  
plot(h); 
legend('k','h')
title('Capital and Human Capital Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'kh.png')

figure(3);
subplot(3,1,3)
hold on;
plot(tb.*(b1*n1+b2*n2));
legend('$\tau^b(b_1n_1+b_2n_2$','Location','Southeast')
title('Bequest Tax Revenues Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'tbb.png')

figure(4);
subplot(3,1,3)
hold on; 
plot(ti.*w.*h);
legend('$\tau^iwh$')
title('Income Tax Revenues Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'tauwh.png')

figure(5);
subplot(3,1,3)
hold on; 
plot(-te.*(e1*n1+e2*n2));
legend('\tau^e(e_1n_1+e_2n_2)','Location','Southeast');
title('Educational Subsidies Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'subs.png')


figure(6); 
subplot(3,1,3)
hold on; 
plot(real(valfun(c01,c11,c21,bt,bp)))
plot(real(valfun(c02,c12,c22,bt,bp)))
plot(real(felicitous(c01,c11,c21,bt)))
plot(real(felicitous(c02,c12,c22,bt)))
legend('V^1','V^2','F^1','F^2')
title('Utilities Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'utils.png')

figure(7)
subplot(3,1,3)
hold on;
plot(c01)
plot(c02)
plot(c21)
plot(c22)
legend('c_{01}','c_{02}','c_{21}','c_{22}')
title('Young/Old Consumption by Type Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'cons.png')

figure(8)
subplot(3,1,3)
hold on
plot(e1);
plot(e2);
plot(h1);
plot(h2);
legend('e_1','e_2','h_1','h_2')
title('Human Capital Expenditure/Levels by Type Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'hce.png')

figure(9)
subplot(3,1,3)
hold on
plot(s1)
plot(s2)
legend('s_1','s_2')
title('Savings Levels by Type Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'svg.png')

figure(10)
subplot(3,1,3)
hold on
plot(b1./(w.*h1+b1))
plot(b2./(w.*h2+b2))
legend('b_1/(wh_1+b_1)','b_2/(wh_2+b_2)')
title('Bequests by Type Under Educational Subsidies')
xlabel('\tau^e\in[-0.01,-0.8]')
saveas(gcf,'beq.png')

figure(11)
hold on
plot(y)
legend('y(\tau^b)','y(\tau^i)','y(\tau^e)')
title('Per Capita Output')
saveas(gcf,'y.png')

cd E:\Inequality
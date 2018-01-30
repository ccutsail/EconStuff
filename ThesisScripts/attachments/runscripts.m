cd C:\Users\math-student\Desktop\simpmod
run('tbvarscrpt.m')
run('tivarscrptalt.m')

cd C:\Users\math-student\Desktop\Inequality
run('ineqscrpttbvar.m')
run('ineqscrpttivar.m')

valfun = @(c1,c2,c3,bt,bp)log(c2) + bt.*log(c3) + bp.*(log(c1)+bt.*log(c2)+bt^2.*log(c3));
felicitous = @(c1,c2,c3,bt)log(c1) + bt.*log(c2) + bt^2.*log(c3);

Vti = valfun(c0ti2,cti2,c2ti2,0.98,0.98);
Uti = felicitous(c0ti2,cti2,c2ti2,0.98);
Vtb= valfun(c0tb,ctb,c2tb,0.98,0.98);
Utb = felicitous(c0tb,ctb,c2tb,0.98);
U1tin = valfun(c01tiin,c11tiin,c21tiin,0.98,0.98);
V1tin = felicitous(c01tiin,c11tiin,c21tiin,0.98);
U2tin = valfun(c02tiin,c12tiin,c22tiin,0.98,0.98);
V2tin = felicitous(c02tiin,c12tiin,c22tiin,0.98);
U1tbin = valfun(c01tbin,c11tbin,c21tbin,0.98,0.98);
V1tbin = felicitous(c01tbin,c11tbin,c21tbin,0.98);
U2tbin = valfun(c02tbin,c12tbin,c22tbin,0.98,0.98);
V2tbin = felicitous(c02tbin,c12tbin,c22tbin,0.98);

aveutin = (U1tin+U2tin)./2;
avevtin = (V1tin+V2tin)./2;
aveutbin = (U1tbin+U2tbin)./2;
avevtbin = (V1tbin+V2tbin)./2;


close all
figure(1)
subplot(2,2,1)
hold on
plot(tbtb,ktb)
plot(tbtb,htb,'b--')
xlabel('\tau^b')

subplot(2,2,3)
hold on
plot(tbtb,ktbin)
plot(tbtb,htbin,'b--')
xlabel('\tau^b, inequality')
subplot(2,2,2)
hold on
plot(tbtb,kti2)
plot(tbtb,hti2,'b--')
xlabel('\tau^i')

subplot(2,2,4)
hold on
plot(titin,ktiin)
plot(titin,htiin,'b--')
legend('k','h')
xlabel('\tau^i, inequality')


figure(2)
subplot(2,2,1)
hold on
plot(tbtb,c0tb)
plot(tbtb,c2tb,'b--')
xlabel('\tau^b')

subplot(2,2,2)
hold on
hold on
plot(tbtb,c0ti2)
plot(tbtb,c2ti2,'b--')
xlabel('\tau^i')

subplot(2,2,3)
hold on
plot(tbtb,c01tbin)
plot(tbtb,c02tbin,'b--')
plot(tbtb,c11tbin,'b.')
plot(tbtb,c02tbin,'b-.')
xlabel('\tau^b, inequality')

subplot(2,2,4)
hold on
plot(titin,c01tiin)
plot(titin,c02tiin,'b--')
plot(titin,c11tiin,'b.')
plot(titin,c02tiin,'b-.')
legend('c_{01}','c_{02}','c_{21}','c_{22}')
xlabel('\tau^i, inequality')

figure(3)
subplot(2,2,1)
hold on
plot(tbtb,Vtb,'b')
plot(tbtb,Utb,'b--')
xlabel('\tau^b')

subplot(2,2,2)
hold on
plot(tbtb,Vti,'b')
plot(tbtb,Uti,'b--')
xlabel('\tau^i')

subplot(2,2,3)
hold on
plot(tbtb,aveutbin,'b' )
plot(tbtb,avevtbin ,'b--')
xlabel('\tau^b, inequality')

subplot(2,2,4)
hold on
plot(titin,aveutin,'b' )
plot(titin,avevtin ,'b--')
legend('F','V')
xlabel('\tau^i, inequality')

figure(4)
subplot(2,2,1)
hold on
plot(tbtb,stb,'b')
plot(tbtb,etb,'b--')
xlabel('\tau^b')

subplot(2,2,2)
hold on
plot(tbtb,sti2,'b')
plot(tbtb,eti2,'b--')
xlabel('\tau^i')

subplot(2,2,3)
hold on
plot(tbtb,s1tbin,'b')
plot(tbtb,e1tbin,'b--')
plot(tbtb,s2tbin,'b.')
plot(tbtb,e2tbin,'b-.')
xlabel('\tau^b, inequality')

subplot(2,2,4)
hold on
plot(titin,s1tiin,'b')
plot(titin,e1tiin,'b--')
plot(titin,s2tiin,'b.')
plot(titin,e2tiin,'b-.')
legend('s_1','e_1','s_2','e_2')
xlabel('\tau^i, inequality')

figure(5)
subplot(2,2,1)
hold on
plot(tbtb,Rtb,'b')
plot(tbtb,wtb,'b--')
xlabel('\tau^b')

subplot(2,2,2)
hold on
plot(tbtb,Rti2,'b')
plot(tbtb,wti2,'b--')
xlabel('\tau^i')

subplot(2,2,3)
hold on
plot(tbtb,Rtbin,'b')
plot(tbtb,wtbin,'b--')
xlabel('\tau^b, inequality')

subplot(2,2,4)
hold on
plot(titin,Rtiin,'b')
plot(titin,wtiin,'b--')
legend('w','R')
xlabel('\tau^i, inequality')


figure(6)
subplot(2,2,1)
hold on
plot(tbtb,ytb,'b')
plot(tbtb,ctb,'b--')
xlabel('\tau^b')

subplot(2,2,2)
hold on
plot(tbtb,yti2,'b')
plot(tbtb,cti2,'b--')
xlabel('\tau^i')

subplot(2,2,3)
hold on
plot(tbtb,ytbin,'b')
plot(tbtb,c11tbin,'b--')
plot(tbtb,c12tbin,'b--')
xlabel('\tau^b, inequality')

subplot(2,2,4)
hold on
plot(titin,ytiin,'b')
plot(titin,c11tiin,'b--')
plot(titin,c12tiin,'b--')
legend('y','c_{11}','c_{12}')
xlabel('\tau^i, inequality')

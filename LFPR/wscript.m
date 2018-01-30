close all

t1 = datetime(1948,1,1);
t2 = datetime(2016,8,1);
t = t1:calmonths(1):t2;

plot(t,agg)
hold on
plot(t,W20)
hold on
plot(t,M20)
xlabel('Time')
ylabel('LFPR')
legend('Aggregate LFPR, 20-24','Women 20+','Men 20+','Location','Southeast')
title('Labor Force Participation Rates (LFPR), 1948 - 2016')
hold on
plot(t(1),0,'w')
hold on
plot(t(1),100,'w')
hold on
recessionplot
[maxagg,tmaxagg] = max(agg);
[maxm20,tmaxm20] = max(M20);
[maxw20,tmaxw20] = max(W20);
[minagg,tminagg] = min(agg);
[minm20,tminm20] = min(M20);
[minw20,tminw20] = min(W20);
hold on
plot(t(tmaxw20),maxw20,'rd')
hold on
plot(t(tmaxm20),maxm20,'yd')
hold on
plot(t(tmaxagg),maxagg,'bd')
hold on
plot(t(tminw20),minw20,'r+')
hold on
plot(t(tminm20),minm20,'y+')
hold on
plot(t(tminagg),minagg,'b+')

% Figure 2

tim = t(468:end);
y = 1:357;
womtrendseries = W20(468:end);
slope = (W20(end) - W20(468))/(y(end) - y(1));
slope2 = (max(W20) - W20(468))/(y(261) - y(1));
intercept = W20(468);
fittedvals = slope*y + intercept;
fittedvals2 = slope2*y + intercept
figure(2)
plot(tim,fittedvals)
hold on
plot(tim,womtrendseries)
hold on
plot(tim,fittedvals2)


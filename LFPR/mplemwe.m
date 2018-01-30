t1 = datetime(1988,1,1);
t2 = datetime(2015,1,1);
t = t1:calyears(1):t2;

[hAx,hLine1,hLine2] = plotyy(t,MWE,t,PL)
recessionplot
title('Productivity of Labor and Earnings, 1988 - 2015')
xlabel('Year')
legend('1','2','Location','Southwest')
ylabel(hAx(1),'Labor Productivity') % left y-axis
ylabel(hAx(2),'Median Weekly Earnings') % right y-axis


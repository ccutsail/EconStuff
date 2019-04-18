rng('default')
tol = 0.00001;
J = 60;
av = zeros(J+1,4);
cv = zeros(J,4);
R = 1.0525;
b = 0.98;
au = 10;
al = -10;
ev = zeros(60,4);

ev(:,1) = (10-linspace(-3,3,J).^2 + normrnd(0,0.25,1,J))';
ev(:,2) = 10-linspace(-3,3,J).^2;
ev(:,3) = 10-linspace(-3,3,J).^2 + normrnd(0,1,1,J);
ev(:,4) = 10-linspace(-3,3,J).^2 + normrnd(0,3,1,J);

w = 1;

ee = @(c) b * R * c;
bc = @(a,c,e) R * a + w * e - c;
av(J+1,:) = 100;

for i = 1:4
    au = 10;
    al = -10;
    while abs(av(J+1,i)) > tol
        av(2,i) = (au + al)/2;
        cv(1,i) = w * ev(1,i) - av(2,i);
        for j = 2:J
            cv(j,i) = ee(cv(j-1,i));
            av(j+1,i) = bc(av(j,i),cv(j,i),ev(j,i));
        end
        if av(J+1,i) > 0
            au = (av(2,i) + au)/2;
        elseif av(J+1,i) < 0
            al = (av(2,i) + al)/2;
        end
    end    
end

subplot(3,1,1);
plot(cv)
title('Life-Cycle Consumption')

subplot(3,1,2);
plot(av)
title('Asset Holdings')

subplot(3,1,3)
plot(ev)
title('Income')

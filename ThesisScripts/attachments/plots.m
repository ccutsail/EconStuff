
%c01tbin = outmat(:,3); 
%c02tbin = outmat(:,4);
%s1tbin = outmat(:,5); 
%e1tbin = outmat(:,6); 
%h1tbin = outmat(:,7); 

%Rtbin = outmat(:,14); 
%b1tbin = outmat(:,15); 
%b2tbin = outmat(:,16);
%c11tbin = outmat(:,17); 
%c12tbin = outmat(:,18); 
%ytbin = outmat(:,19);

subplot(2,2,1)
hold on
plot(ktb)
plot(kti)

subplot(2,2,2)
hold on
plot(ktbin)
plot(ktiin)

subplot(2,2,3)
hold on
plot(htb)
plot(hti)

subplot(2,2,4)
hold on
plot(htbin)
plot(htiin)

%c21tbin = outmat(:,8);
%c22tbin = outmat(:,9); 
%s2tbin = outmat(:,10); 
%e2tbin = outmat(:,11); 
%h2tbin = outmat(:,12);
%wtbin = outmat(:,13); 

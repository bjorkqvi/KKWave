%% Lasketaan Suomenlinnan pyyhkäisymatka
% Laskettu kartasta pyyhkäisymatkat 10 asteen välein
% Lopulliset pyyhkäisymatkat 60 asteen keskiarvoja
clear
close all

%     0   10  20  30  40  50  60  70  80  90  100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300 310 320 330 340 350
Xraw=[3.5 3.2 2.5 2.5 3.0 2.5 2.1 2.6 7.5 7.5 7.5 8.3 6.5 4.7 5.0 4.0 3.5 3.0 3.5 4.0 6.5 6.0 6.0 5.5 1.0 1.0 1.0 1.0 1.0 1.5 4.5 5.0 5.5 5.5 4.5 4.0];
Xraw=Xraw/3.8; % cm -> km

Xloop=[Xraw(end-2:end) Xraw Xraw(1:3)];
ct=1;
for n=4:(length(Xraw)+3)
   X(ct)=mean([cos(30*pi/180)*Xloop(n-3) cos(20*pi/180)*Xloop(n-2) cos(10*pi/180)*Xloop(n-1) Xloop(n) cos(10*pi/180)*Xloop(n+1) cos(20*pi/180)* Xloop(n+2) cos(30*pi/180)*Xloop(n+3)]); 
   ct=ct+1;
end

plot(Xraw,'k-o');
hold on
plot(X,'ro');
title('Fetch at Suomenlinna');
xlabel('D');
ylabel('X (km)');
legend({'raw lines','60 deg averages'});



dlmwrite('../Suomenlinna_fetch.txt',[[0:10:350]' X'],'delimiter',' ','precision','%0.2f');

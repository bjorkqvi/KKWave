%% Calibrate the longe wave energy from the GoF buoy for the Suomenlinna KKWave-model
close all
clear

addpath('../model_files/functions');
%% Observations
buoy.time=roundto30min(datetime(ncread('Suomenlinna2016_Hs.nc','UNIXtime'),'convertfrom','posixtime'));
buoy.hs=ncread('Suomenlinna2016_Hs.nc','Hs');
buoy.E=(buoy.hs/4).^2;

load('../wave_output/KKW_Suomenlinna2016_nobnd.mat','Hs','Site');
load('../bnd/BND_GoF2016.mat','Bnd');


SupressFigures=1;

Nesting(1).BoundaryDelay=0;
%% Nest the boundary
for k=1:length(Bnd) % Loop through the different boundary areas
    Fn={'U','Ud','E','fp','Dw','ta','tw'};
    T=Nesting(k).BoundaryDelay;
    for n=1:length(Fn)
       P=Fn{n};
       
       switch P
           case 'E'
            pad=0.1;
           case 'fp'
            pad=1;
           case 'Dw'
            pad=0;
           case 'ta'
            pad=5;
           case 'tw'
            pad=5;
           otherwise    
            pad=0;
       end
       Block1=Bnd(k).(P)(1:end-T);
       Block0=ones(1,1+(T-1))*pad;
       Bnd(k).(P)=[Block0 Block1];
    end
    
end

k=1;

 Dir='Ud'; % Use wind direction to determine the attenuation


r=Site.cumchecksum & ~isnan(Bnd(k).E)  & ~isnan(Bnd(k).U) & ~isnan(Bnd(k).(Dir));


long=cleanNaN(Bnd,r,{'time','E','Ud','Dw'});

local=cleanNaN(Site,r,{'time'});
local.E=(Hs(r)'/4).^2;


[j,ra,rb]=joindate(buoy.time,buoy.E,local.time,local.E);

buoy.time=buoy.time(ra);
buoy.E=buoy.E(ra);
buoy.hs=buoy.hs(ra);


local.time=local.time(rb);
local.E=local.E(rb);

long.time=long.time(rb);
long.E=long.E(rb);
long.(Dir)=long.(Dir)(rb);
long.(Dir)(long.(Dir)>359)=0;




D0=0;
D1=360;
dD=10;
K2=zeros(36,2);
for D=D0:dD:(D1-1)
    r=long.(Dir)>=D & long.(Dir)<(D+dD);
    x=long.E(r);
    y=max(buoy.E(r)-local.E(r),0);
    kk=x\y;
    k(1)=kk;
    k(2)=0;
    %k=linfitef(x,y);
    K2(pntr(D),1)=k(1);
    K2(pntr(D),2)=k(2);
    r=corrcoef(x,y);
    R(pntr(D))=r(1,2);
    
    if ~SupressFigures
        scatter(x,y,15);
        title(sprintf('%.0f<=%s<%.0f',D,Dir,D+dD));
        xlim([0 0.7]);
        ylim([0 0.2]);

        hold on
        t=[0:0.1:0.7];
        plot(t,t*k(1)+k(2),'k');
        hold off
        pause
    end
    
end

% Wind vector
windD=D0:dD:(D1-1);

%% Write output
Fn=sprintf('../attenuations/KKW_att_Suomenlinna_%s.mat',Dir);
save(Fn,'K2','windD','R');

fprintf('Attenuations written to %s\n',Fn)

Fn=sprintf('../attenuations/Suomenlinna_energy_attenuations_%s.txt',Dir);
dlmwrite(Fn,[windD' K2(:,1)],'delimiter',' ','precision','%.4f');


% Validate
for n=1:length(long.(Dir))
     KKW.E(n)=local.E(n)+K2(pntr(long.(Dir)(n)))*long.E(n);
end

if ~SupressFigures
    figure

    scatter(buoy.hs,4*sqrt(KKW.E),10,long.(Dir));colorbar;
    ylim([0 1.5]);
    hold on
    plot([0 1.5],[0 1.5],'k');
    xlabel('H_s Wave Buoy'); ylabel('H_s KKWave');

    rmse=sqrt(mean((4*sqrt(KKW.E)-buoy.hs').^2));
    bias=mean(4*sqrt(KKW.E)-buoy.hs');
    title(sprintf('Bias %.2f m, RMSE %.2f m',bias, rmse));


    figure
    plot(windD,K2(:,1))
    hold on
    plot(windD,R,'r');
    xlabel(sprintf('%s (deg)',Dir));
    ylabel('Attenuation factor K^2 / Correclation');
    legend({'Energy attenuation (K^2)','Correlation'});
    title('GoF wave buoy vs. Suomenlinna long wave');
end




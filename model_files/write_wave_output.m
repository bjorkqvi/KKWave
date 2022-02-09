function write_wave_output(fid,Site,Bnd,Nesting,Info,Hs,fp,Dw)
% function write_wave_output(fid,Site,Bnd,Info,Hs,fp,Dw)
Fn=sprintf('wave_output/KKW_%s.mat',Info.name);

write_output(sprintf('Saving wave data >> %s', Fn),fid,dbstack());
save(Fn,'Site','Bnd','Nesting','Hs','fp','Dw');



% 
% fprintf(fid,'### Starting time series output to %s...\n',['TULOSHA_',Info.name]);
% 
% IFILE=fopen(['TULOSHA_',Info.name],'w');
% fprintf(IFILE,' PARAMETRIC WAVE MODEL OUTPUT,  Point: Helsinki buoy (59 58.5 N 25 14.0 E)\n');
% fprintf(IFILE,'                TOTAL                     SWELL0        SWELL1        SWELL2\n');
% fprintf(IFILE,' m  d  UTC Uef   Hs  Hmax  Tp   Dw    Hs   Tp  Dw   Hs   Tp  Dw   Hs   Tp  Dw\n');
% 
% for i=1:length(Site.U)
%     
%     mm=month(Site.time(i));
%     dd=day(Site.time(i));
%     hh=hour(Site.time(i));
%    
%    Eswell0=Site.E_swell(i);
%    fpswell0=Site.fp_swell(i);
%    Dwswell0=Site.Dw_swell(i);
%    %Dw=Site.Dw(i);
%    
%    Eswell1=Bnd(1).E(i);
%    fpswell1=Bnd(1).fp(i);
%    Dwswell1=Bnd(1).Dw(i);
%    
%    Eswell2=Bnd(2).E(i);
%    fpswell2=Bnd(2).fp(i);
%    Dwswell2=Bnd(2).Dw(i);
%    
%    u=Site.Ueff(i);
%    
%     Hmax=1.8*Hs;
% 
% 
%   OUT=[sprintf('%4.0f',mm),...
%       sprintf('%4.0f',dd),...
%       sprintf('%4.0f',hh),...
%       sprintf('%5.1f',u),...
%   sprintf('%5.2f',Hs(i)),...
%   sprintf('%5.2f',Hmax(i)),...
%   sprintf('%5.1f',1/fp(i)),...
%   sprintf('%5g',Dw(i)),...
%   sprintf('%6.2f',4*sqrt(Eswell0)),...
%   sprintf('%5.1f',1/fpswell0),...
%   sprintf('%4g',Dwswell0),...
%   sprintf('%5.2f',4*sqrt(Eswell1)),...
%   sprintf('%5.1f',1/fpswell1),...
%   sprintf('%4g',Dwswell1),...
%   sprintf('%5.2f',4*sqrt(Eswell2)),...
%   sprintf('%5.1f',1/fpswell2),...
%   sprintf('%4g\n',Dwswell2)];
% 
% 
%   fprintf(IFILE,OUT);

% end



end


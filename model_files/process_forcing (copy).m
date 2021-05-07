function [Site,Forcing,Bnd,Bnd_Forcing,fid]=process_forcing(Info,Site,Forcing,Bnd,Bnd_Forcing)
%function [fid,Site,Bnd]=process_forcing(Info,Site,Forcing,Bnd,Bnd_Forcing)

Fn=sprintf('%s/KKWave_logfile_%s',Info.folder,Info.name);
fid=fopen(Fn,'w');

%% Write start info

fprintf(fid,'### Starting KKWave wave model run\n');
fprintf(fid,'Projekt folder: %s\n',Info.folder);
fprintf(fid,'Projekt name: %s\n\n',Info.name);

%% Forcing

fprintf(fid,'### Reading forcing data for the main site (%s)\n',Site.name);
fprintf(fid,'# Reading wind data\n');
fprintf(fid,'Loading file: %s...\n',Forcing.wind_input);
wind=load(Forcing.wind_input);
fprintf(fid,'Processing data...\n');
Forcing.time=datetime([wind(:,1:5) 0*wind(:,1)]);
Forcing.U=wind(:,6);
Forcing.Ud=wind(:,7);
fprintf(fid,'Done!\n');

fprintf(fid,'# Reading air temperature data\n');
fprintf(fid,'Loading file: %s...\n',Forcing.ta_input);
ta=load(Forcing.ta_input);
fprintf(fid,'Processing data...\n');
Forcing.ta=ta;
fprintf(fid,'Done!\n');

fprintf(fid,'# Reading water temperature data\n');
fprintf(fid,'Loading file: %s...\n',Forcing.ta_input);
tw=load(Forcing.tw_input);
fprintf(fid,'Processing data...\n');
% if size(tw,2)>1
%     Site.tw_time=datetime([tw(:,1:5) 0*tw(:,1)]);
%     Site.tw=tw(:,6);
%     fprintf(fid,'Assuming time stamps in water temperature data.\n');
%     fprintf(fid,'First and last time stamps: %s and %s.\n',datestr(Site.tw_time(1),'yyyy mm dd HH MM'),datestr(Site.tw_time(end),'yyyy mm dd HH MM'));
% else
    fprintf(fid,'No time stamps in water temperature data. Assuming that they coincide with wind data.\n');
    Forcing.tw=tw(:,end);
% end
    
fprintf(fid,'Done!\n');

fprintf(fid,'\n');

if length(Bnd_Forcing)==0
   fprintf(fid,'### No Boundary forcing files defined!\n');
else
    fprintf(fid,'### Reading Boundary forcing data\n');
    
    warning('Testing attenuations applied to the boundary wind conditions!');
    att=[0.9 1.1];
    for n=1:length(Bnd_Forcing)
        fprintf(fid,'### Boundary area %s\n',Bnd(n).name);
        fprintf(fid,'# Reading wind data\n');
        fprintf(fid,'Loading file: %s...\n',Bnd_Forcing(n).wind_input);
        wind=load(Bnd_Forcing(n).wind_input);
        fprintf(fid,'Processing data...\n');
        Bnd_Forcing(n).time=datetime([wind(:,1:5) 0*wind(:,1)]);
        Bnd_Forcing(n).U=wind(:,6)*att(n);
        Bnd_Forcing(n).Ud=wind(:,7);
        fprintf(fid,'Done!\n');

        fprintf(fid,'# Reading air temperature data\n');
        fprintf(fid,'Loading file: %s...\n',Bnd_Forcing(n).ta_input);
        ta=load(Bnd_Forcing(n).ta_input);
        fprintf(fid,'Processing data...\n');
        Bnd_Forcing(n).ta=ta;
        fprintf(fid,'Done!\n');

        fprintf(fid,'# Reading water temperature data\n');
        fprintf(fid,'Loading file: %s...\n',Bnd_Forcing(n).tw_input);
        tw=load(Bnd_Forcing(n).tw_input);
        fprintf(fid,'Processing data...\n');
        Bnd_Forcing(n).tw=tw;
        fprintf(fid,'Done!\n');

        fprintf(fid,'\n');

    end
end

%%
Site.time=Forcing.time;
Site.U=Forcing.U;
Site.Ud=Forcing.Ud;
Site.ta=Forcing.ta;
Site.tw=Forcing.tw;

for k=1:length(Bnd)
    Bnd(k).time=Bnd_Forcing(k).time;
    Bnd(k).U=Bnd_Forcing(k).U;
    Bnd(k).Ud=Bnd_Forcing(k).Ud;
    Bnd(k).ta=Bnd_Forcing(k).ta;
    Bnd(k).tw=Bnd_Forcing(k).tw;
end






end


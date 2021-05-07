function [Forcing,Bnd_Forcing]=load_forcing(Site,Forcing,Bnd,Bnd_Forcing,fid)
%function [Forcing,Bnd_Forcing]=load_forcing(Site,Forcing,Bnd,Bnd_Forcing,fid)
%--------------------------------------------------------------------------------------------------------
%Forcing.U/Ud/ta/tw = Wind speed/direction, and air/water temperature for actual site
%Bnd_Forcing(n).U/Ud/ta/tw = Wind speed/direction, and air/water temperature n different boundary points
%--------------------------------------------------------------------------------------------------------

%% Forcing
write_output(sprintf('Reading forcing data [%s]',Site.name),fid,dbstack());
write_output(sprintf('Reading wind data: %s...',Forcing.wind_file),fid);

wind=load(Forcing.wind_file);
Forcing.time_U=datetime([wind(:,1:6)]);
if isfield(Site,'wind_att') & abs(Site.wind_att-1)>eps
    Forcing.U=wind(:,7)*Site.wind_att;
    %warning('Attenuation factor %.2f applied to the wind forcing of %s',Site.wind_att,Site.name);
    write_output(sprintf('Attenuation factor %.2f applied to the wind forcing of %s',Site.wind_att,Site.name),fid);
else
    Forcing.U=wind(:,7);
end
Forcing.Ud=wind(:,8);

write_output(sprintf('Loading air temperature data << %s...',Forcing.ta_file),fid);
ta=load(Forcing.ta_file);
Forcing.time_ta=datetime([ta(:,1:6)]);
Forcing.ta=ta(:,7);

write_output(sprintf('Loading water temperature data << %s...',Forcing.tw_file),fid);
tw=load(Forcing.tw_file);
Forcing.time_tw=datetime([tw(:,1:6)]);
Forcing.tw=tw(:,7);



if length(Bnd_Forcing)==0
   write_output('No Boundary forcing files defined!',fid,dbstack());
else
    write_output('Reading boundary forcing data',fid,dbstack());
    for k=1:length(Bnd_Forcing)
        write_output(sprintf('# Boundary area [%s]',Bnd(k).name),fid);
        write_output(sprintf('Loading wind data << %s...',Bnd_Forcing(k).wind_file),fid);
        wind=load(Bnd_Forcing(k).wind_file);
        Bnd_Forcing(k).time_U=datetime([wind(:,1:6)]);
        
        if isfield(Bnd(k),'wind_att') & abs(Bnd(k).wind_att-1)>eps
            Bnd_Forcing(k).U=wind(:,7)*Bnd(k).wind_att;
            %warning('Attenuation factor %.2f applied to the wind forcing of Boundary Area %.0f: %s',Bnd(k).wind_att,k,Bnd(k).name);
            write_output(sprintf('Attenuation factor %.2f applied to the wind forcing of Boundary Area %.0f: %s',Bnd(k).wind_att,k,Bnd(k).name),fid);
        else
            Bnd_Forcing(k).U=wind(:,7);
        end
        Bnd_Forcing(k).Ud=wind(:,8);

        write_output(sprintf('Loading air temperature data << %s...',Bnd_Forcing(k).ta_file),fid);
        ta=load(Bnd_Forcing(k).ta_file);
        Bnd_Forcing(k).time_ta=datetime([ta(:,1:6)]);
        Bnd_Forcing(k).ta=ta(:,7);

        write_output(sprintf('Loading water temperature data << %s...',Bnd_Forcing(k).tw_file),fid);
        tw=load(Bnd_Forcing(k).tw_file);
        Bnd_Forcing(k).time_tw=datetime([tw(:,1:6)]);
        Bnd_Forcing(k).tw=tw(:,7);
       
        write_output('',fid)

    end
end


end


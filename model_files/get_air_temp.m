function Ta=get_air_temp(Site,n,fid)
%function Tw=get_water_temp(Site,n)
  if isfield(Site,'ta_time')
       Ta=interp1(Site.ta_time,Site.Ta,Site.time(n));
       fprintf(fid,'Interpolated air temperature to time %s\n',datestr(Site.time(n),'yyyy-mm-hhTHH:MM'));
   else
       Ta=Site.ta(n);
   end



end


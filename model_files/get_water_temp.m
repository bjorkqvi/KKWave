function Tw=get_water_temp(Site,n,fid)
%function Tw=get_water_temp(Site,n)
  if isfield(Site,'tw_time')
       Tw=interp1(Site.tw_time,Site.tw,Site.time(n));
       fprintf(fid,'Interpolated water temperature to time %s\n',datestr(Site.time(n),'yyyy-mm-dd HH:MM'));
   else
       Tw=Site.tw(n);
   end



end


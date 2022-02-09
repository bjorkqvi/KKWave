function write_boundary_output(Site,Info,Hs,fid)
% function write_boundary_output(Site,Info,Hs,fid)

Bnd.name=Site.name;
Bnd.X=Site.X;
Bnd.time=Site.time;
Bnd.U=Site.U;
Bnd.Ud=Site.Ud;
Bnd.E=(Hs/4).^2;
Bnd.fp=Site.fp;
Bnd.Dw=Site.Dw;
Bnd.ta=Site.ta;
Bnd.tw=Site.tw;
Bnd.checksum=Site.checksum;
Bnd.cumchecksum=Site.cumchecksum;

Fn=sprintf('bnd/BND_%s.mat',Info.name);
write_output(sprintf('Saving wave data as boundary for nested runs >> %s', Fn),fid,dbstack());
save(Fn,'Bnd');


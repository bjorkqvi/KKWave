function [Info,Site,Bnd,Nesting,dt,g,init]=init_model(fid,Info,Site,Bnd,Nesting)
%function [Info,Site,Bnd,Nesting,dt,g,init]=init_model(fid,Info,Site,Bnd,Nesting)

% Gravitational acceleration (m/s^2)
g=9.82;

dt=Info.dt;
write_output(sprintf('Time step set to %.0f seconds',dt),fid,dbstack());

%% Initial conditions
% Boundary initial values
init.E_bnd=0;
init.fp_bnd=1;
init.Dw_bnd=0;

% Swell initial values
init.E_swell=0;
init.fp_swell=1;
init.Dw_swell=0;

% Wind sea initial values
init.E_sea=0.1;
init.fp_sea=1;
init.Dw_sea=Site.Ud(1);
init.Xe_sea=1;

if ~isfield('Info','BoundaryInput') | ~Info.BoundaryInput % Only set initial boundary values if they are not being loaded
    write_output(sprintf('Setting initial boundary conditions...'),fid,dbstack());
    for k=1:length(Bnd)
       write_output(sprintf('# Boundary area [%s]',Bnd(k).name),fid); 
       write_output(sprintf('Setting initial E in boundary area %.0f: %.2f m*m',k,init.E_bnd),fid);
       Bnd(k).E(1)=init.E_bnd;
       write_output(sprintf('Setting initial fp in boundary area %.0f: %.2f Hz',k,init.fp_bnd),fid);
       Bnd(k).fp(1)=init.fp_bnd;
       write_output(sprintf('Setting initial Dw in boundary are %.0f: %.0f deg',k,init.Dw_bnd),fid);
       Bnd(k).Dw(1)=init.Dw_bnd;
        write_output('',fid)
        
    end

end

% If the attenuation is not given as a function of wave direction we
% have to multiply it to a dummy vector
for k=1:length(Nesting)
    if length(Nesting(k).att)==1
        Nesting(k).att=repmat(Nesting(k).att,length(Site.X),1);
    end
end

write_output(sprintf('Setting initial swell conditions...'),fid,dbstack());

write_output(sprintf('Setting initial E for swell: %.2f m*m',init.E_swell),fid);
Site.E_swell(1)=init.E_swell;
write_output(sprintf('Setting initial fp for swell: %.2f Hz',init.fp_swell),fid);
Site.fp_swell(1)=init.fp_swell;
write_output(sprintf('Setting initial Dw for swell: %.0f deg',init.Dw_swell),fid);
Site.Dw_swell(1)=init.Dw_swell;


%% Set logical flags
if ~isfield(Info,'IgnoreBoundary'); Info.IgnoreBoundary=0; end
if ~isfield(Info,'BoundaryRun'); Info.BoundaryRun=0; end
if ~isfield(Info,'BoundaryOutput'); Info.BoundaryOutput=0; end
if ~isfield(Info,'BoundaryInput'); Info.BoundaryInput=0; end
if ~isfield(Info,'Coastal'); Info.Coastal=0; end

end


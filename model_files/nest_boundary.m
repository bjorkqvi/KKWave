function [Site, Bnd]=nest_boundary(Site,Bnd,Nesting,init,fid)
%function Bnd=nest_boundary(Bnd,Nesting)

write_output('Correcting the boundary values for delay because of wave propagation',fid,dbstack());
%% Propagate the boundary
% It takes a certain amount of time steps for the boundary waves to reach
% the area
for k=1:length(Bnd) % Loop through the different boundary areas
    if length(Site.time)~=length(Bnd(k).time)
            error('Length of Site times does not equal the boundary times!')
    end
    
    Fn={'U','Ud','E','fp','Dw','ta','tw'};
    T=Nesting(k).BoundaryDelay;
    write_output(sprintf('# Boundary area [%s], delay %.0f time steps',Bnd(k).name,T),fid); 
    for n=1:length(Fn)
       P=Fn{n};
       
       switch P
           case 'E'
            %pad=init.E_bnd;
            pad=NaN;
           case 'fp'
            pad=init.fp_bnd;   
           case 'Dw'
            pad=init.Dw_bnd;
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


write_output('Removing data outside of the valid directions',fid,dbstack());
for k=1:length(Bnd) % Loop through the different boundary areas
    write_output(sprintf('# Boundary area [%s], valid for %.0f < Dw < %.0f',Bnd(k).name,  Nesting(k).valid_dir(1),Nesting(k).valid_dir(2)),fid); 
    for n=2:length(Bnd(k).time)
        if  Bnd(k).Ud(n) < Nesting(k).valid_dir(1) | Bnd(k).Ud(n) > Nesting(k).valid_dir(2) % Waves propagating away from the actual site
            if abs(angdiff([Bnd(k).Ud(n),Site.Ud(n)],360)) >= 41
                %Bnd(k).E(n)=Bnd(k).E(1); % Use initial condition (meaning zero energy)
                Bnd(k).E(n)=init.E_bnd; % Use initial condition (meaning zero energy)
                Bnd(k).fp(n)=Bnd(k).fp(1); 
                Bnd(k).Dw(n)=Bnd(k).Dw(1);
            end
        end
    end    
end

% Update checksum
for k=1:length(Bnd)
    r=isnan(Bnd(k).E);
    Site.checksum(r)=0; % The boundary wave conditions are used for the next time step
    Bnd(k).checksum=~isnan(Bnd(k).E);
end

Site.cumchecksum=Site.checksum;
for k=1:length(Bnd)
    Site.cumchecksum=Site.cumchecksum & Bnd(k).checksum  & ~isnan(Bnd(k).U) & ~isnan(Bnd(k).Ud); % These are needed for calculating wave parameters
end

end
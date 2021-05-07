function [Hs,fp,Dw,Bnd]=calculate_wave_parameters(Info,Site,Bnd,Nesting,n,Hs,fp,Dw)
%function [Hs,fp,Dw,Bnd]=calculate_wave_parameters(Info,Site,Bnd,Nesting,n,Hs,fp,Dw)

% M=Matrix
% ---------------------------------------------------------
% E_sea             fp_sea          Dw_sea          0
% E_swell           fp_swell        Dw_swell        swell_attenuation
% Boundary(1).E     Boundary(1).fp  Boundary(1).Dw  Boundary(1).attenuation  
% Boundary(2).E     Boundary(2).fp  Boundary(1).Dw  Boundary(2).attenuation  
% ....
M=[Site.E(n) Site.fp(n) Site.Dw(n) 0;
   Site.E_swell(n) Site.fp_swell(n) Site.Dw_swell(n) Site.att];

for k=1:length(Bnd)
    M(k+2,1)=Bnd(k).E(n); 
    M(k+2,2)=Bnd(k).fp(n);
    M(k+2,3)=Bnd(k).Dw(n);
    M(k+2,4)=Nesting(k).att(pntr(Bnd(k).Dw(n))); 
end

[~,r]=max(M(:,1)); % Find maximum energy

% Peak frequeny and wave direction
fp(n)=M(r,2);
Dw(n)=M(r,3);

if Info.Coastal
    % In coastal runs no correction for oversaturation is made
    M(3:end,4)=0;
end
    
if Site.fp_swell<Site.fp
    % If swell is present from the same are as the wind sea, then the wind sea
    % is attenuated in order for the total energy not to saturate
    % The swell energy has already been attenuaten upon calculation
    E=Site.E(n)*(1-M(2,4));
else 
    % If no swell is present, then the same attenuation is set by the most
    % energetic system. If this is the wind sea, then no attenuation is
    % used, since att=1-0=1
    E=Site.E(n)*(1-M(r,4));
end

% %% DEBUGGING!
% local=load('wave_output/KKW_Suomenlinna2016_nobnd.mat','Site');
% long=load('bnd/BND_GoF2016.mat','Bnd');
% 
% %%
% if abs(E-local.Site.E(n))>eps;keyboard;end


% Local area energy: Wind sea + swell
E=E+Site.E_swell(n);
% Add energy from boundary areas
for k=1:length(Bnd)
    if Info.Coastal % Coastal runs have attenuations defined using the wind speed
        try 
            % To avoid sudden jumps in the attenuation, the attenuation
            % coefficient is averaged over the relaxtime that determines
            % how fast the wave direction reacts to the wind direction
            n0=max(1,n-Info.relaxtime/Info.dt);
            Bnd(k).K(n)=mean(Nesting(k).att(pntr(Bnd(k).Ud(n0:n),'vector')));
            %E=E+Bnd(k).E(n)*Nesting(k).att(pntr(Bnd(k).Ud(n))); % Attenuate the boundary wave system here
            E=E+Bnd(k).E(n)*Bnd(k).K(n); % Attenuate the boundary wave system here
        catch
  
        end
    else
        E=E+Bnd(k).E(n)*Nesting(k).att(pntr(Bnd(k).Dw(n))); % Attenuate the boundary wave system here
         Bnd(k).K(n)=Nesting(k).att(pntr(Bnd(k).Dw(n)));
    end
end

% Significant wave height
Hs(n)=4.0*sqrt(E);

   

   
      
end

function [Site]=tstep2(Info,Site,Bnd,Nesting,dt,i,g,init)
%function [running,Site,Bnd]=tstep2(Site,Bnd,running,Info,dt,i,g,init)


%  Ennustusohjelman aika-askel versio 2: 360 ei sis�lly 1 alueeseen
%  XW:n aiheuttama virhe on korjattu 29.12.1995.  KK
   % Määrätään geometrinen X rannan ja tuulen suunnan avulla
   % Aaltojen suuntaa ei tässä vaihessa huomioida (yksinkertaistus)
XK = Site.X;
U  = Site.U(i);
if ~Info.Coastal% In coastal runs the winds are used as is
    for k=1:length(Bnd)
    % Jos aallokko tulee viereiselt� ja lis�ksi se on samansuuntainen
    % Varoitus!  T�m� lauseke p�tee vain kun 360 ei sis�lly sektoriin
        if  Bnd(k).Ud(i) >= Nesting(k).valid_dir(1) && Bnd(k).Ud(i) <= Nesting(k).valid_dir(2)
            if abs(angdiff([Bnd(k).Ud(i),Site.Ud(i)],360)) < 41
                XK = min([Bnd(k).X;Site.Xeff]); % Kasvavan aallokon X korkeintaan efektiivinen
                a = pntr([Site.Ud(i);Bnd(k).Ud(i)]);
                U  = Site.X(a)/XK(a)*Site.U(i) + (1-Site.X(a)/XK(a))*Bnd(k).U(i);
                % T�m� on ensi appr. U:n voi laskea uudelleen kun Dw on
                % m��r�tty ja Cg:n avulla voidaan interpoloida oikeaaikainen
                % tuuli viereiselle alueelle. T�ss� oletetaan, ett� aallokolta
                % kest�� 6 tuntia tulla viereiselt� alueelta. Tuuli otetaan koko
                % alueelta 1 vaikka efektiivinen X onkin lopulta lyhyempi.
            end
        end
    end
end

XK = min([XK;Site.Xeff]); % Kasvavan aallokon X on korkeintaan efektiivinen

% M��r�t��n aallokon suunta
% M��r�t��n Rb ja relaatio perusalueella suunnan laskemiseksi.

% Dimensionless fetch of a fully developed sea
[Rb, P]=BulkRichardson(Site.ta(i),Site.tw(i),Site.U(i));
XmF=(0.82/(P(2)*2*pi))^(1/P(1));

% Set fetch from km -> m
 try
X  = 1000*XK(pntr(Site.Ud(i))); 
 catch
     keyboard
 end
% Calculate waves (????)
[Esea0,fpsea0,Xe0] = wgrowth(X,U,dt,0,P);
   
  
     
  
if g*X/U^2  > XmF
    % Direction of fully developed waves set to the wind direction
    Site.Dw(i) =Site.Ud(i);
else  % For a developing sea the shoreline affects the direction
    if i>1
          EP=Site.E(i-1);
          XP=Site.Xe(i-1);
      else
          EP=init.E_sea;
          XP=init.Xe_sea;
    end

    % Aikaisemmat tuulensuunnat huomioidaan keskisuunnassa
    % Lasketaan ensin Cg
    [~,fa] = wgrowth(X,U,dt,EP,P);
    [~,Cg]=wavec(fa*2*pi,Info.depth);
    % Suunnan relaksaatioaika, tässäyksinkertaisin appr. eli vakio
    b = min([Info.relaxtime/dt,i-1,floor(XP/(Cg*dt))]);
    dirs=Site.Ud(i-b:i);
    dirs(isnan(dirs))=[];
    Site.Dw(i)=Site.DX(pntr(dirs));

    X  = 1000*XK(pntr(Site.Dw(i)));
end



%% Calculate the waves for the actual site

% Määrätään efektiivinen tuuli
% Tässä voitaisiin laskea tarkempi U käyttäen Cg:tä. Ei kannata
% enenekuin on nähty, että tämä appr. ei riitä.
Site.Ueff(i)=U*cos((Site.Ud(i)-Site.Dw(i))*pi/180);
Site.Ueff(i)=max([Site.Ueff(i),1]);

if i>1
    EP=Site.E(i-1);
else
    EP=init.E_sea;
end
[Site.E(i),Site.fp(i),Site.Xe(i)] = wgrowth(X,Site.Ueff(i),dt,EP,P);

if Esea0 >= Site.E(i)
    Site.E(i) = Esea0;
    Site.fp(i) = fpsea0;
    Site.Xe(i) = Xe0;
    Site.Dw(i) = Site.Ud(i);
    Site.Ueff(i) = U;
    %X  = 1000*XK(pntr(D0(i)));
end

   
  
%% Swell calculations
% If the fp from the previous time step is smaller than the current one, it
% is swell
if i>1 % No swell possible in the first time step
    [~,Cg]=wavec(Site.fp(i-1)*2*pi,Info.depth);
    r=1-min([1,(Cg*dt)/Site.Xe(i-1)]); % ?????
    Site.fp_swell(i)=Site.fp(i-1)*r^P(1);
    

    if Site.fp_swell(i) < Site.fp(i) % Swell exists?
        % The swell is the local wave system from the previous time step that
        % has been attenuated
        Site.E_swell(i)=Site.att*r*Site.E(i-1);
        Site.Dw_swell(i)=Site.Dw(i-1);
    end
end
   
% If swell conditions have not been set that means that they don't exist
% Set swell to 0
if length(Site.Dw_swell)<i
    Site.E_swell(i)=init.E_swell;
    Site.fp_swell(i)=init.fp_swell;
    Site.Dw_swell(i)=init.Dw_swell;
end
   

   
      
end
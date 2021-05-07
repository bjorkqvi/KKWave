function [tH,EP,fpP,XP,DwP,Hs,Hmax,Dwave,Tp,Dw,u,Eswell0,Eswell1,Eswell2,fpswell0,fpswell1,fpswell2,Dwswell0,Dwswell1,Dwswell2]=tstep2(DX,X0,X1,X2,XW,D1a,D1b,D2a,D2b,relaxtime,dt,spread0,spread1,spread2,D0,D1,D2,U0,U1,U2,Ta,Tw,tH,EP,fpP,XP,DwP,Hs,Hmax,Dwave,Tp,i,g,g2)
%function [tH,EP,fpP,XP,DwP,Hs,Hmax,Dwave,Tp,Dw,u]=tstep2(DX,X0,X1,X2,XW,D1a,D1b,D2a,D2b,relaxtime,dt,spread0,spread1,spread2,D0,D1,D2,U0,U1,U2,Ta,Tw,tH,Hs,Hmax,Dwave,Tp,i,g,g2)



%  Ennustusohjelman aika-askel versio 2: 360 ei sis�lly 1 alueeseen
%  XW:n aiheuttama virhe on korjattu 29.12.1995.  KK
   % M��r�t��n geometrinen X rannan ja tuulen suunnan avulla
   % Aaltojen suuntaa ei t�ss� vaihessa huomioida (yksinkertaistus)
     XK = X0;
     U  = U0(i);
     if i > 1
        % Jos aallokko tulee viereiselt� ja lis�ksi se on samansuuntainen
        % Varoitus!  T�m� lauseke p�tee vain kun 360 ei sis�lly sektoriin
        if  D1(i-1) >= D1a & D1(i-1) <= D1b
          if abs(angdiff([D1(i-1),D0(i)],360)) < 41
              XK = min([X1;XW]); % Kasvavan aallokon X korkeintaan efektiivinen
              %a = angmean([D0(i);D1(i-1)],360)/10 + 1;
              a = round(meanang([D0(i);D1(i-1)],'deg')/10) + 1;
              U  = X0(a)/XK(a)*U0(i) + (1-X0(a)/XK(a))*U1(i-1);
              % T�m� on ensi appr. U:n voi laskea uudelleen kun Dw on
              % m��r�tty ja Cg:n avulla voidaan interpoloida oikeaaikainen
              % tuuli viereiselle alueelle. T�ss� oletetaan, ett� aallokolta
              % kest�� 6 tuntia tulla viereiselt� alueelta. Tuuli otetaan koko
              % alueelta 1 vaikka efektiivinen X onkin lopulta lyhyempi.
          end
        end
        % Varoitus!  T�m� lauseke p�tee vain kun 360 ei sis�lly sektoriin
        if  D2(i-1) >= D2a & D2(i-1) <= D2b
          if abs(angdiff([D2(i-1),D0(i)],360)) < 41
              XK = min([X2;XW]); % Kasvavan aallokon X korkeintaan efektiivinen
              %a = angmean([D0(i);D2(i-1)],360)/10 + 1;
              a = round(meanang([D0(i);D2(i-1)],'deg')/10) + 1;
              U  = X0(a)/XK(a)*U0(i) + (1-X0(a)/XK(a))*U2(i-1);
           end
        end
     end
     XK = min([XK;XW]); % Kasvavan aallokon X on korkeintaan efektiivinen

   % M��r�t��n aallokon suunta
   % M��r�t��n Rb ja relaatio perusalueella suunnan laskemiseksi.
   Rb=BulkRichardson(Ta(i),Tw(i),U0(i));
   %Rb=g*((Ta(i)-Tw(i))./10)./((Ta(i)+273).*(U0(i)./10).^2);
   P=relat(Rb);
   % M��r�t��n t�ysinkehittyneen aallokon dimensioton pyyhk�isymatka
   XmF=(0.82/(P(2)*2*pi))^(1/P(1));

   X  = 1000*XK(round(D0(i)/10) + 1);
  [Esea0,fpsea0,Xe0] = wgrowth(X,U,dt,0,P);
   if g*X/U^2  > XmF
      % T�ysinkehittyneen aallon suunta on tuulen suunta
      Dw = D0(i);
   else  % Kehittyv��n aallokkoon ranta vaikuttaa

      % Aikaisemmat tuulensuunnat huomioidaan keskisuunnassa
      % Lasketaan ensin Cg
      [Ea,fa] = wgrowth(X,U,dt,EP,P);
      Cg = g/(fa*4*pi);

      % Suunnan relaksaatioaika, t�ss� yksinkertaisin appr. eli vakio
       b = min([relaxtime/dt,i-1,floor(XP/(Cg*dt))]);
      %Dw = DX(angmean(D0([i-b:i]),360)/10 + 1);
      
      Dw = DX(round(meanang(D0([i-b:i]),'deg')/10) + 1);
      X  = 1000*XK(Dw/10 + 1);
   end
   P=relat(Rb);

   % T�ss� voitaisiin laskea tarkempi U k�ytt�en Cg:t�. Ei kannata
   % enenekuin on n�hty, ett� t�m� appr. ei riit�.


   % M��r�t��n efektiivinen tuuli
   u=U*cos((D0(i)-Dw)*pi/180);
   u= max([u,1]);

  % Lasketaan aallokko perusalueella
  [Esea,fpsea,Xe] = wgrowth(X,u,dt,EP,P);

  if Esea0 >= Esea
     Esea  = Esea0;
     fpsea = fpsea0;
     Xe    = Xe0;
     Dw    = D0(i);
     u     = U;
     X  = 1000*XK(round(D0(i)/10) + 1);
  end

   % Maininki perusalueelta
   % Jos edellisen aika-askeleen kasvattama kulkeutunut fp on pienempi niin
   % se on maininki.
   r=1-min([1,(g/(fpP*4*pi)*dt)/XP]);
   fpswell0=fpP*r^P(1);
   if fpswell0 < fpsea
      Eswell0=spread0*r*EP;
      E=(1-spread0)*Esea; % Esea+Eswell0 ylitt�isi saturaatiorajan kun f>fpsea
      Dwswell0=DwP;
   else
      E=Esea;
      fp=fpsea;
      Eswell0=0;
      fpswell0=1;
      Dwswell0=0;
   end
   EP=Esea;     % Seuraavassa aika-asleleessa EP on nyt kasvanut Esea.
   fpP=fpsea;
   DwP=Dw;
   XP=Xe;

   if Eswell0 > Esea
      fp=fpswell0;
      Dw=Dwswell0;
   end
 
   % Maininki viereiselt� alueelta 1
   Eswell1  = 0;
   fpswell1 = 1;
   Dwswell1 = 0;
   Eswell2  = 0;
   fpswell2 = 1;
   Dwswell2 = 0;
   if i > 1
      if  D1(i-1) >= D1a & D1(i-1) <= D1b
         if abs(angdiff([D1(i-1),D0(i)],360)) > 41
            % viereiselt� alueelta tulee mainikia
            Dwswell1 = D1(i-1);
            a = round(Dwswell1/10)+1;
            X10= 1000*(X1(a)-X0(a));

            % M��r�t��n Rb ja relaatio ja aallokko viereiselle alueelle 1.
            % Oikeastaan pit�isi k�ytt�� viereisen alueen l�mp�tiloja
            % ja ennustaa aallokko yht� tarkasti kuin perusalueelle.
            % Ei kanna tehd� ennekuin yksinkertainen on todettu liian
            % ep�tarkaksi.
            Rb=BulkRichardson(Ta(i),Tw(i),U1(i));
            %Rb=g*((Ta(i)-Tw(i))./10)./((Ta(i)+273).*(U1(i)./10).^2);
            P=relat(Rb);
            [Eswell1,fpswell1] = wgrowth(X10,U1(i-1),dt,0,P);

            Eswell1=spread1*Eswell1;
            if Eswell1 > max([Esea,Eswell0])
               E =(1-spread1)*Esea;
               fp=fpswell1;
               Dw=Dwswell1;
            end
         end
      end
   % Maininki viereiselt� alueelta 2
      if  D2(i-1) >= D2a & D2(i-1) <= D2b
         if abs(angdiff([D2(i-1),D0(i)],360)) > 41
            % viereiselt� alueelta tulee mainikia
            Dwswell2 = D2(i-1);
            a = round(Dwswell2/10)+1;
            X20= 1000*(X2(a)-X0(a));
            % T�m� voi tarvittaessa tarkentaa omalla taulukolla X20

            % M��r�t��n Rb ja relaatio ja aallokko viereiselle alueelle 2.
            % Oikeastaan pit�isi k�ytt�� viereisen alueen l�mp�tiloja
            % ja ennustaa aallokko yht� tarkasti kuin perusalueelle.
            % Ei kanna tehd� ennekuin yksinkertainen on todettu liian
            % ep�tarkaksi.
            Rb=BulkRichardson(Ta(i),Tw(i),U2(i));
            %Rb=g*((Ta(i)-Tw(i))./10)./((Ta(i)+273).*(U2(i)./10).^2);
            P=relat(Rb);
            [Eswell2,fpswell2] = wgrowth(X20,U2(i-1),dt,0,P);

            Eswell2=spread2*Eswell2;
            if Eswell2 > max([Esea,Eswell0,Eswell1])
               E =(1-spread2)*Esea;
               fp=fpswell2;
               Dw=Dwswell2;
            end
         end
      end
    end

   Hs(i)=4.0*sqrt(E+Eswell0+Eswell1+Eswell2);
   Hmax(i)=1.8*Hs(i);
   Tp(i)=1/fp;
   Dwave(i)=Dw;
   tH = tH + dt/3600;

%    if ~exist('Dwswell0','var');Dwswell0=0;end
%    if ~exist('Dwswell1','var');Dwswell1=0;end
%    if ~exist('Dwswell2','var');Dwswell2=0;end
   
end
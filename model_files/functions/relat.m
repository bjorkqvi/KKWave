function P=relat(Rb)


%     1981 ennustusrelaatiot
%a1=-1/3;
%a2=22/(2*pi);
%b1=1;
%b2=1.9e-7;

%     1992 ennustusrelaatiot, stabiili stratifikaatio
a1s=-0.24;
a2s=12.0/(2*pi);
b1s=0.76;
b2s=9.3e-7;

%     1992 ennustusrelaatiot, epästabiili stratifikaatio
a1u=-0.28;
a2u=14.2/(2*pi);
b1u=0.94;
b2u=5.4e-7;

%     1992 ennustusrelaatiot, neutraali stratifikaatio
a1n=-0.27;
a2n=13.7/(2*pi);
b1n=0.9;
b2n=5.2e-7;


% Neutraali stabiliteetti
P(1)=a1n; P(2)=a2n; P(3)=b1n; P(4)=b2n;

% Alustava karkea stabilisuuden huomiointi
% raja nostettu 11.11.1993  0.01   entinen  0.005

if      Rb >  0.01, P(1)=a1s; P(2)=a2s; P(3)=b1s; P(4)=b2s; end
if      Rb < -0.01, P(1)=a1u; P(2)=a2u; P(3)=b1u; P(4)=b2u; end
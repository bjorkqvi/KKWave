function [E,fp,XP,XmX,XmF,Xmt] = wgrowth(X,u,dt,EP,P);

   g=9.82;
   a1=P(1); a2=P(2); b1=P(3); b2=P(4);

   % M��r�t��n t�ysinkehittyneen aallokon dimensioton pyyhk�isymatka
   % PIERSONIN ARVO 0.87 ON REDUKOITU 19.5 m TASOSTA 10 m TASOON
   XmF=(0.82/(a2*2*pi))^(1/a1);

   % M��r�t��n dimensioton pyyhk�isymatka
   XmX=g*X/(u*u);

   if EP > 0
      Em=g*g*EP/u^4;
      Xmev=(Em/b2) ^ (1 /b1);
      % Lasketaan Xmev:t� vastaava aika fp:n perusteella
      tmev=(4*pi*a2/(a1+1))*Xmev ^ (a1+1);
   else
      tmev = 0;
   end

   % Lis�t��n aika askel dimensiolliseen aikaan (dt sekunteja)
   tm = tmev + g*dt/u;
   % Lasketaan uutta aikaa vastaava dimesioton X fp:n perusteella
   Xmt = (tm*(a1+1)/(4.0*pi*a2)) ^ (1/(a1+1));
   % Xmt arvo on oikea vain kun se on pienempi kuin XmF.

   Xm=min([XmX,Xmt,XmF]);
   % EFEKTIIVINEN PYYHK�ISYMATKA ON MINIMI ERI TEKIJ�IDEN RAJOITTA-
   % MISTA PYYHK�ISYMATKOISTA.

   % Lasketaan Em ja fpm ja dimensiolliset parametrit
   Em  = b2*Xm^b1;
   fpm = a2*Xm^a1;

   E = Em*u^4 /(g*g);
   fp= g*fpm/u;
   XP=Xm*u*u/g;



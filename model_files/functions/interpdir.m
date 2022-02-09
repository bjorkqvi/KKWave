function Di = interpdir(t,D,ti)
%function Di = interpdir(t,D,ti)
if isdatetime(t)
    t=datenum(t);
end
if isdatetime(ti)
    ti=datenum(ti);
end


  S=sin(D*pi/180);
  C=cos(D*pi/180);

    % Change very small values because according to Octave sin(pi)=1.2246e-16
    S(abs(S)<eps)=0;
    C(abs(C)<eps)=0;

    Si=interp1(t,S,ti);
    Ci=interp1(t,C,ti);
    
    Di=180/pi*atan2(Si,Ci);

% Force the result to be a positive angle
Di=mod(Di,360);

end



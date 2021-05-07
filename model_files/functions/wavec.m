function [c,cg]=wavec(w,h)
%        [c,cg]=wavec(w,h)

%g=9.81; 

g=9.82; % Baltic Sea value
if length(w) > 1,  one=ones(size(w)); else,  one=1; end
if length(h) == 1, h=one*h; end
c0=g*one./w;
c=c0; 
c1=0*c; e=max(c)*2*eps;
while max(abs(c-c1)) > e
   x=(h.*w./c);
   x=sign(x).*min(20,abs(x));
   tanhx = (exp(x) - exp(-x))./(exp(x) + exp(-x));
   c1=c0.*tanhx;
%  semilogy(abs(c-c1)+eps,'g') % check convergence
   c=0.4*c+0.6.*c1; 
end

kh2 = 2*h .* w ./c;
cg  = 0.5*c.*(1+ kh2./(sinh(kh2)));



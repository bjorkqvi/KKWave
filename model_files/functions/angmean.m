function m=angmean(D,cycle)
%        m=angmean(D,cycle)
%
%        Angular mean of F, where D = rem(F,c)

if nargin==1, cycle=2*pi; end

N=length(D);
if N > 1
   D=D(:);
   a = diff(D);
   b = a<=-cycle/2;
   c = a>= cycle/2;
   a(b)=a(b)+cycle;
   a(c)=a(c)-cycle;
   m=sum(cumsum([D(1);a]))/N;
   m=m-cycle*floor(m/cycle);
else
   m=D;
end




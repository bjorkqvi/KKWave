function a=angdiff(D,cycle)
%        a=angdiff(D,cycle)
%
%        Angular difference of F, where D = rem(F,c)

if nargin==1, cycle=2*pi; end

a = diff(D);
if length(D) > 1
   b = a<=-cycle/2;
   c = a>= cycle/2;
   a(b)=a(b)+cycle;
   a(c)=a(c)-cycle;
end

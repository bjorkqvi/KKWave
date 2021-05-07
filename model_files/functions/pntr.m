function p = pntr(D,p)
% function p = pntr(D)
% Calculates the pointer to a vactor containing directions with a 10 degree
% increent
% ----
% Set p='vector' to calculate separate values of the vector D
% if is omitted the vector D is first averaged and one value is
% returned

if nargin==1 || ~ischar(p)
    p=floor(angmean(D,360)/10) + 1;
else
    p=floor(D/10) + 1;
end



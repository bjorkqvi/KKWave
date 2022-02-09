function [xi] = interpgaps(x,L)
%function [xi] = interpgaps(x,L)
% Interpolates NaNs in x when the gaps are SHORTER than L

% Find NaN-blocks AT LEAST L long
notnan=find(~isnan(x));
Dnotnan=diff(notnan);
Ind=find(Dnotnan>L);

% Interpolate everything
if any(isnan(x))
    xi=interpNaN(x);
else
    xi=x;
end
% Reintroduce NaN to the gaps at least L long
for n=1:length(Ind)
   xi(notnan(Ind(n))+1:notnan(Ind(n))+Dnotnan(Ind(n))-1)=NaN;
end
end


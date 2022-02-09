function [Rb, P] = BulkRichardson(Ta,Tw,U)
% function [Rb, P] = BulkRichardson(Ta,Tw,U)
g=9.82; %Baltic Sea value 
Rb=g*((Ta-Tw)./10)./((Ta+273).*(U./10).^2);
P=relat(Rb);

end


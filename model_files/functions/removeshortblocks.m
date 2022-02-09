function xc = removeshortblocks(x,L)
% function xc = removeshortblocks(x,L)
% Remove (not-NaN) blocks that are SHORTER than L
% Short blocks in the beginning and end of vector are not touched

% Find not-NaN-blocks SHORTER than L
nans=find(isnan(x));
Dnans=diff(nans);
Ind=find(diff(nans)<L+1);

xc=x;

% Set short blocks to NaN
for n=1:length(Ind)
   xc(nans(Ind(n))+1:nans(Ind(n))+Dnans(Ind(n))-1)=NaN;
end

end


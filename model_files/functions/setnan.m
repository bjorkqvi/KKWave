function [Site]=setnan(Site,n)
%function [Site]=setnan(Site,n)

list={'E','fp','Dw','Ueff','Xe','E_swell','fp_swell','Dw_swell'};
for k=1:length(list)
   P=list{k};
   Site.(P)(n)=NaN;
end

end
function B=cleanNaN(A,r,list)
%function B=cleanNaN(A,r,list)
% A = struct
% r = locical vector
% list = list of fieldnames to clean
% ----
% list is set to fieldnames(A) is nargin==2
if nargin==2
    Fn=fieldnames(A);
else
    Fn=list;
end
    
for n=1:length(Fn)
    P=Fn{n};
    B.(P)=A.(P)(r);
    B.(P)=B.(P)(:);
end
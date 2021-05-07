function [joined_mat, IndexA, IndexB,time] = joindate(ta,A,tb,B)
% [joined_mat, IndexA, IndexB,time] = joindate(ta,A,tb,B)
% join two matrices mimicing the linux command "join"

% If we have only vectorn, make sure that they are row vectors to make the
% input less sensitive
if min(size(A))==1 && min(size(B))==1
    ta=ta(:);
    tb=tb(:);
    A=A(:);
    B=B(:);
end




if nargin==4 %times given separately
    if isdatetime(ta)
        ta=datenum(ta);
    end
    if isdatetime(tb)
        tb=datenum(tb);
    end
    
    A=[ta double(A)];
    B=[tb double(B)];
else
    B=A;
    A=ta;
    
end

% Number of data columns
dataA=size(A,2)-1;
dataB=size(B,2)-1;

IndexA = ismember(A(:,1),B(:,1), 'rows');
IndexB = ismember(B(:,1),A(:,1), 'rows');

A=A(IndexA,:);
B=B(IndexB,:);

if size(A,1)~=size(B,1)
   r=min(size(A,1),size(B,1));
   line=find(abs(A(1:r,1)-B(1:r,1))>0,1,'first');
   warning('After joining matrix A has %.0f lines and matrix B has %.0f lines! Possible duplicate lines in A or B? Check line %.0f. Diagnostic variable is "diagnostic"',size(A,1),size(B,1),line);
   tta=datetime(ta,'convertfrom','datenum');
   ttb=datetime(tb,'convertfrom','datenum');
   ttb=ttb(IndexB);
   tta=tta(IndexA);
   keyboard
   nn=min([length(tta) length(ttb)]);
   diagnostic=[tta(1:nn) ttb(1:nn)];
   dd=abs(tta(1:nn)-ttb(1:nn));
   aaa=find(dd>minutes(5));
   diagnostic(aaa(1)-1:aaa(1)+1,:)
   keyboard

end

joined_mat=zeros(size(A,1),1+dataA+dataB);


joined_mat(:,1)=A(:,1);

joined_mat(:,2:1+dataA)=A(:,2:end);

joined_mat(:,2+dataA:end)=B(:,2:end);

time=datetime(joined_mat(:,1),'convertfrom','datenum');

end


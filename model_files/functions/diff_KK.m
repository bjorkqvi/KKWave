function retval = diff(a);

% Difference 

[m,n] = size(a);
if m == 1
   retval = a(2:n)  -  a(1:n-1);
else
   retval = a(2:m,:) - a(1:m-1,:);
end
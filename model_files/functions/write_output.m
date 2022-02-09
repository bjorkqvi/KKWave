function write_output(msg, fid, dbs)
% function write_output(String, fid, dbs)

if nargin==3
    msg=sprintf('\n### %s: %s\n',dbs(1).file,msg);
    fprintf(msg);
else    
    msg=sprintf('\t%s\n',msg);
end

fprintf(fid,msg);


end


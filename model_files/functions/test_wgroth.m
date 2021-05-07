% Test new wgrotwh

U=[1:2:32];
X=[10:100:10000];
dt=[3600:3600:12*3600];
EP=([0:1:5]/4).^2;

Ta=[-10:5:30];Tw=[-5:5:25];

N=length(U)*length(X)*length(dt)*length(EP)*length(Ta)*length(Tw);

% E1=zeros(N,1);
% E2=zeros(N,1);
% fp1=zeros(N,1);
% fp2=zeros(N,1);
% XP1=zeros(N,1);
% XP2=zeros(N,1);


ct=1;
for nu=1:length(U)
    for nx=1:length(X)
        for nt=1:length(dt)
            for ne=1:length(EP)
                for na=1:length(Ta)
                    for nw=1:length(Tw)
                        [~, P] = BulkRichardson(Ta(na),Tw(nw),U(nu));                        
                        [E1,fp1,XP1,XmX1,XmF1,Xmt1] = wgrowth(X(nx),U(nu),dt(nt),EP(ne),P);
                        [E2,fp2,XP2,XmX2,XmF2,Xmt2] = wgrowth2(X(nx),U(nu),dt(nt),EP(ne),P);
                        ct=ct+1;
                        disp(ct/N*100);
                        if abs(E1-E2)>2*eps; error('E');end
                        if abs(fp1-fp2)>2*eps; error('fp');end
                        if abs(XP1-XP2)>2*eps; error('X');end
                        if abs(XmX1-XmX2)>2*eps; error('XmX');end
                        if abs(XmF1-XmF2)>2*eps; error('XmF');end
                        if abs(Xmt1-Xmt2)>2*eps; error('Xmt');end
                        
                        
                    end
                end
            end
        end
    end
end
        




function [Site,Bnd]=process_forcing(Info,Site,Forcing,Bnd,Bnd_Forcing,fid)
%function [fid,Site,Bnd]=process_forcing(Info,Site,Forcing,Bnd,Bnd_Forcing)


%% Make dure all forcing data is coincided

dt=hours(Info.dt/3600);
tol=dt*0.5;

%% Forcing for actual site
write_output(sprintf('Processing forcing to %.2f hour intervals [%s]',hours(dt),Site.name),fid,dbstack());
t=Forcing.time_U(1);
Site.time(1)=t;
ct=1;
while t<Forcing.time_U(end)
    t=t+dt; ct=ct+1;
    
    %% Find suitable wind time step
    r=find(abs(Forcing.time_U-t)<tol,1,'first');  
    if ~isempty(r)
        Site.time(ct)=t;
        Site.U(ct)=Forcing.U(r);
        Site.Ud(ct)=Forcing.Ud(r);

    else
        Site.time(ct)=t;
        Site.U(ct)=NaN;
        Site.Ud(ct)=NaN;

    end
    
    %% Find suitable air temperature time step
    r=find(abs(Forcing.time_ta-t)<tol,1,'first');
    if ~isempty(r) 
        Site.ta(ct)=Forcing.ta(r);
    else
        Site.ta(ct)=NaN;
    end
    
    
    %% Find suitable water temperature time step
    r=find(abs(Forcing.time_tw-t)<tol,1,'first');
    if ~isempty(r) 
        Site.tw(ct)=Forcing.tw(r);
    else
        Site.tw(ct)=NaN;
    end
    

end

%% Interpolate missing wind data
% Interpolate gaps shorter than 6 hours
L=6;
Site.U=interpgaps(Site.U,L);
Site.Ud=interpgaps(Site.Ud,L);
Site.ta=interpgaps(Site.ta,L);
Site.tw=interpgaps(Site.tw,L);

% Remove blocks shorter than 12 hours
Lb=12;
Site.U=removeshortblocks(Site.U,Lb);
Site.Ud=removeshortblocks(Site.Ud,Lb);
Site.ta=removeshortblocks(Site.ta,Lb);
Site.tw=removeshortblocks(Site.tw,Lb);



% if length(find(isnan(Site.U)))>0
%     Site.U=interpNaN(Site.U);
% end
% if length(find(isnan(Site.Ud)))>0
%     Site.Ud=interpNaN(Site.Ud);
% end
% 
% % If NaN:s are at the end then they are not interpolated
% r=isnan(Site.U) | isnan(Site.Ud);
% Site.time(r)=[];
% Site.U(r)=[];
% Site.Ud(r)=[];
% Site.tw(r)=[];
% Site.ta(r)=[];

%% These indeces are ok to calculate waves with
Site.checksum=~isnan(Site.Ud) & ~isnan(Site.U);

Site.Ud=round(Site.Ud);
Site.Ud(Site.Ud>359)=0;

%% It is not worth skipping wave calculations because of missing temperature data
% Missing water temperature set to the air temperature
r=isnan(Site.tw)&~isnan(Site.ta);
Site.tw(r)=Site.ta(r);

% Missing air temperature set to the water temperature
r=isnan(Site.ta)&~isnan(Site.tw);
Site.ta(r)=Site.tw(r);

% Is missing from both, set both to 5 deg C
r=isnan(Site.ta)&isnan(Site.tw);
Site.ta(r)=5; 
Site.tw(r)=5;

if (~isfield(Info,'IgnoreBoundary') | ~Info.IgnoreBoundary ) & length(Bnd)>0
    write_output('Interpolating forcing data for boundary area match the site forcing...',fid,dbstack());

    %%  Forcing for boundary areas
    for k=1:length(Bnd)
        write_output(sprintf('# Boundary area [%s]',Bnd(k).name),fid);
        Bnd(k).U=interp1(Bnd_Forcing(k).time_U,Bnd_Forcing(k).U,Site.time);
        Bnd(k).Ud=interp1(Bnd_Forcing(k).time_U,Bnd_Forcing(k).Ud,Site.time);
        Bnd(k).ta=interp1(Bnd_Forcing(k).time_ta,Bnd_Forcing(k).ta,Site.time);
        Bnd(k).tw=interp1(Bnd_Forcing(k).time_tw,Bnd_Forcing(k).tw,Site.time);

        Bnd(k).time=Site.time;

        keyboard    
        % Interpolate short NaN-blocks
        Bnd(k).U=interpgaps(Bnd(k).U,L);
        Bnd(k).Ud=interpgaps(Bnd(k).Ud,L);
        Bnd(k).ta=interpgaps(Bnd(k).ta,L);
        Bnd(k).tw=interpgaps(Bnd(k).tw,L);

        %% It is not worth skipping wave calculations because of missing temperature data
        % Missing water temperature set to the air temperature
        r=isnan(Bnd(k).tw)&~isnan(Bnd(k).ta);
        Bnd(k).tw(r)=Bnd(k).ta(r);

        % Missing air temperature set to the water temperature
        r=isnan(Bnd(k).ta)&~isnan(Bnd(k).tw);
        Bnd(k).ta(r)=Bnd(k).tw(r);

        % Is missing from both, set both to 5 deg C
        r=isnan(Bnd(k).ta)&isnan(Bnd(k).tw);
        Bnd(k).ta(r)=5; 
        Bnd(k).tw(r)=5;    
        
        
        % Remove short non-NaN-blocks
        Bnd(k).U=removeshortblocks(Bnd(k).U,Lb);
        Bnd(k).Ud=removeshortblocks(Bnd(k).Ud,Lb);
        Bnd(k).ta=removeshortblocks(Bnd(k).ta,Lb);
        Bnd(k).tw=removeshortblocks(Bnd(k).tw,Lb);
        
        
%         %% Interpolate missing wind data
%         if length(find(isnan(Bnd(k).U)))>0
%             Bnd(k).U=interpNaN(Bnd(k).U);
%         end
%         if length(find(isnan(Bnd(k).Ud)))>0
%             Bnd(k).Ud=interpNaN(Bnd(k).Ud);
%         end

        %% These indeces are ok to calculate waves with
        Bnd(k).checksum=~isnan(Bnd(k).Ud) & ~isnan(Bnd(k).U);

        Bnd(k).Ud=round(Bnd(k).Ud);
        Bnd(k).Ud(Bnd(k).Ud>359)=0;

        
        
        %     t=Bnd_Forcing(k).time_U(1);
    %     Bnd_Forcing(k).time(1)=t;
    %     ct=1;
    %     
    %     
    %     while t<=Bnd_Forcing(k).time_U(end)
    %         t=t+dt; ct=ct+1;
    % 
    %         %% Find suitable wind time step
    %         r=find(abs(Bnd_Forcing(k).time_U_input-t)<tol,1,'first');  
    %         if ~isempty(r)
    %             Bnd_Forcing(k).time(ct)=t;
    %             Bnd_Forcing(k).U(ct)=Bnd_Forcing(k).U_input(r);
    %             Bnd_Forcing(k).Ud(ct)=Bnd_Forcing(k).Ud_input(r);
    % 
    %         else
    %             Bnd_Forcing(k).time(ct)=t;
    %             Bnd_Forcing(k).U(ct)=NaN;
    %             Bnd_Forcing(k).Ud(ct)=NaN;
    % 
    %         end
    % 
    %         %% Find suitable air temperature time step
    %         r=find(abs(Bnd_Forcing(k).time_ta_input-t)<tol,1,'first');
    %         if ~isempty(r) 
    %             Bnd_Forcing(k).ta(ct)=Bnd_Forcing(k).ta_input(r);
    %         else
    %             Bnd_Forcing(k).ta(ct)=NaN;
    %         end
    % 
    % 
    %         %% Find suitable water temperature time step
    %         r=find(abs(Bnd_Forcing(k).time_tw_raw-t)<tol,1,'first');
    %         if ~isempty(r) 
    %             Bnd_Forcing(k).tw(ct)=Bnd_Forcing(k).tw_input(r);
    %         else
    %             Bnd_Forcing(k).tw(ct)=NaN;
    %         end
    % 
    % 
    %     end
    %     


        

    end
end

end


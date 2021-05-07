%% Parametric wave model KKWave 1.0
%% ------------------------------------------------------------------------
% Original code by Kimmo K Kahma (1993)
% Updated and added coastal runs by Jan-Victor Björkqvist (2019)
% -------------------------------------------------------------------------
% Code available from github????
% Model validation by Johansson et al. (2019)
% For more details, please see the user manual
%% ------------------------------------------------------------------------

clear
close all

addpath('model_files');
addpath('model_files/functions');
addpath('User_files');

%% Set user file from folder User_files
% ------------------------------------------------------------------------
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF1990s;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF2000s;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF2010s;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF2016;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF2017;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF2018;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF2016_nobnd;

%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna1990s;
[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna2000s;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna2010s;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna2016_nobnd;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna2017_nobnd;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna2016;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna2017;
%[Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna2018;
% ------------------------------------------------------------------------

    
%% Open output file
% ------------------------------------------------------------------------
Fn=sprintf('%s/logfiles/KKWave_logfile_%s',Info.folder,Info.name);
fid=fopen(Fn,'w');
write_output('Starting KKWave wave model run',fid,dbstack());
write_output(sprintf('Project folder: %s',Info.folder),fid);
write_output(sprintf('Project name: %s',Info.name),fid);
% ------------------------------------------------------------------------


%% Preprocess the forcing
% ------------------------------------------------------------------------
[Forcing,Bnd_Forcing]=load_forcing(Site,Forcing,Bnd,Bnd_Forcing,fid);
[Site,Bnd]=process_forcing(Info,Site,Forcing,Bnd,Bnd_Forcing,fid);
% ------------------------------------------------------------------------


%% Set initial conditions (including boundaries)
% ------------------------------------------------------------------------
[Info,Site,Bnd,Nesting,dt,g,init]=init_model(fid,Info,Site,Bnd,Nesting);
fp=0; Hs=0; Dw=0; time=0;
% ------------------------------------------------------------------------

%% Boundary wave data
% ------------------------------------------------------------------------
[Bnd, Nesting]=KKWave_boundary(Info,Site,Bnd,Nesting,dt,init,fid);

% Remove boundary wave data if it is outside the validity of directions etc.
% Update the Site.checksum for missing boundary wave data
[Site,Bnd]=nest_boundary(Site,Bnd,Nesting,init,fid); 
% ------------------------------------------------------------------------


%% Wave data for the actual site
% ------------------------------------------------------------------------
write_output(sprintf('Calculating waves for the actual area [%s]',Site.name),fid,dbstack());
for n=1:length(Site.time)
    if Site.checksum(n)
        [Site]=tstep2(Info,Site,Bnd,Nesting,dt,n,g,init);
    else
        [Site]=setnan(Site, n);
    end
    
    if Site.cumchecksum(n) 
        [Hs,fp,Dw,Bnd]=calculate_wave_parameters(Info,Site,Bnd,Nesting,n,Hs,fp,Dw);
    else
        Hs(n)=NaN; fp(n)=NaN; Dw(n)=NaN; for k=1:length(Bnd);Bnd(k).K(n)=0;end
    end
        
    time=time+dt/3600; % Running time in hours
end
% ------------------------------------------------------------------------


%% Save the wave data from the site as boundary for a possible upcoming wave run
% ------------------------------------------------------------------------
if Info.BoundaryRun
    write_boundary_output(Site,Info,Hs,fid)
end
% ------------------------------------------------------------------------


%% Write the wave data as output
% ------------------------------------------------------------------------
write_wave_output(fid,Site,Bnd,Nesting,Info,Hs,fp,Dw);
% ------------------------------------------------------------------------

write_output('Wave model run completed!!!',fid,dbstack());



function [Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_Suomenlinna2017
% function [Forcing] = KKWave_User_GoF

%% General info about the run
Info.folder=pwd; % Project folder
Info.name='Suomenlinna2018'; % Project name
Info.dt=1*3600; %Time step in seconds
Info.relaxtime=6*3600; %Wind relax time in seconds

Info.depth=22;

%% Logical flags
Info.BoundaryOutput=0; % Output the boundary data of this run
Info.BoundaryRun=0; % Output the data from the final site as bounadry data for possible nested runs
Info.Coastal=1; % This is a coastal run (see user manual for details)

% Create a dummy boundary with 0 energy and direction. This option also
% overrides the Nesting settings and sets non-physical valid directions.
% The dummy boundary information will therefore never be used.
Info.IgnoreBoundary=0; 



%% Main site data
Site.name=Info.name;
% Suomenlinna 60 07.400 N  24 58.350 E
x=load(sprintf('%s/fetch/Suomenlinna_fetch.txt',Info.folder));
Site.X=x(:,2)';
Site.Xeff=Site.X;

% Wave direction as a function of the wind (slanting fetch)
%           0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300 310 320 330 340 350
Site.DX= [0:10:350];

Site.att=1;
Site.wind_att=1; % Attenuation factor for the forcing wind speed



%% Forcing data for the main area
Forcing.wind_file=sprintf('%s/wind/Wind_Harmaja_1h_2018.asc',Info.folder); % Wind data
Forcing.ta_file=sprintf('%s/Ta/Ta_Harmaja_1h_2018.asc',Info.folder); % Air temperature data
Forcing.tw_file=sprintf('%s/Tw/Tw_Harmaja_1h_2018.asc',Info.folder); % Water temperature data



%% Boundary data
Info.BoundaryInput=sprintf('%s/bnd/BND_GoF2018.mat',Info.folder);

if ~isfield(Info,'BoundaryInput') | ~Info.BoundaryInput
    %% Boundary area 1
    Bnd(1).name='Eastern_GoF';
    %           0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300 310 320 330 340 350
    Bnd(1).X=[ 29  28  26  32  35  42  90 163 148 160 141 154 114  67  46  42  40  50  50  50  44  48  67  87  87  87  87  59  39  40  35  31  23  21  24  26];
    %Bnd(1).X=[Bnd(1).X,Bnd(1).X(1)];
        
    Bnd_Forcing(1).wind_file=sprintf('%s/wind/Wind_Kalbadagrund_1h_2016.asc',Info.folder); % Wind data
    Bnd_Forcing(1).ta_file=sprintf('%s/Ta/Ta_Kalbadagrund_1h_2016.asc',Info.folder); % Air temperature data
    Bnd_Forcing(1).tw_file=sprintf('%s/Tw/Tw_LL7mean_1h_2016.asc',Info.folder); % Water temperature data


    %% Boundary area 2
    Bnd(2).name='NBP';
    %           0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300 310 320 330 340 350
    Bnd(2).X=[ 29  28  26  32  35  38  87  87  87  87  87  87  87  49  46  42  40  50  50  50  44  48  67 137 370 503 300  59  39  40  35  31  23  21  24  26];
    %Bnd(2).X=[Bnd(2).X,Bnd(2).X(1)];
    
    Bnd_Forcing(2).wind_file=sprintf('%s/wind/Wind_Uto_1h_2016.asc',Info.folder); % Wind data
    Bnd_Forcing(2).ta_file=sprintf('%s/Ta/Ta_Uto_1h_2016.asc',Info.folder); % Air temperature data
    Bnd_Forcing(2).tw_file=sprintf('%s/Tw/Tw_LL7mean_1h_2016.asc',Info.folder); % Water temperature data
else
    % If boundary data are being loaded
    Bnd=[];
    Bnd_Forcing=[];
end

%% Nesting options
% Suomenlinna
Nesting(1).valid_dir=[0 360];
%a=load(sprintf('%s/attenuations/Suomenlinna_energy_attenuations.txt',Info.folder));
load(sprintf('%s/attenuations/KKW_att_Suomenlinna_Ud.mat',Info.folder),'K2');
%Nesting(1).att=a(:,2);
Nesting(1).att=K2(:,1);

Nesting(1).BoundaryDelay=0; % Multiples of dt it takes for the boundary waves to arrive

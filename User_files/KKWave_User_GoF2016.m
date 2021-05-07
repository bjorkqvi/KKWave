function [Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF2016
% function [Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting] = KKWave_User_GoF2016

%% General info about the run
Info.folder=pwd; % Project folder
Info.name='GoF2016'; % Project name
Info.dt=1*3600; %Time step in seconds
Info.relaxtime=6*3600; %Wind relax time in seconds

Info.depth=62;

%% Logical flags
Info.BoundaryOutput=1; % Output the boundary data of this run
Info.BoundaryRun=1; % Output the data from the final site as bounadry data for possible nested runs
Info.Coastal=0; % This is a coastal run (see user manual for details)

% Create a dummy boundary with 0 energy and direction. This option also
% overrides the Nesting settings and sets non-physical valid directions.
% The dummy boundary information will therefore never be used.
Info.IgnoreBoundary=0; 


%% Main site data
Site.name=Info.name;
% Helsinki 59 57.9 N  25 14.11 E
%            0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300 310 320 330 340 350
Site.X=   [ 29  28  26  32  35  38  87  87  87  87  87  87  87  49  46  42  40  50  50  50  44  48  67  87  87  87  87  59  39  40  35  31  23  21  24  26];
Site.Xeff=[500 500 500 500 500 500  87  87  87  87  87  87  87  49 500 500 500 500 500 500 500 500 500  87  87  87  87 500 500 500 500 500 500 500 500 500];

% Wave direction as a function of the wind (slanting fetch)
%           0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300 310 320 330 340 350
Site.DX=   [0  10  20  30  40  60  70  70  80  90  90 100 100 100 120 130 150 160 190 190 200 210 230 240 250 250 250 250 250 250 300 300 310 330 340 350];

Site.att=0.9; % Attenuation factor for swell because
Site.wind_att=0.8; % Attenuation factor for the forcing wind speed


%% Forcing data for the main area
Forcing.wind_file=sprintf('%s/wind/Wind_Kalbadagrund_1h_2016.asc',Info.folder); % Wind data
Forcing.ta_file=sprintf('%s/Ta/Ta_Kalbadagrund_1h_2016.asc',Info.folder); % Air temperature data
Forcing.tw_file=sprintf('%s/Tw/Tw_LL7mean_1h_2016.asc',Info.folder); % Water temperature data


%% Boundary data
%Info.BoundaryInput='BND_for_GoF.mat';


if ~isfield('Info','BoundaryInput') | ~Info.BoundaryInput
    %% Boundary area 1
    Bnd(1).name='Eastern_GoF';
    %           0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300 310 320 330 340 350
    Bnd(1).X=[ 29  28  26  32  35  42  90 163 148 160 141 154 114  67  46  42  40  50  50  50  44  48  67  87  87  87  87  59  39  40  35  31  23  21  24  26];
    %Bnd(1).X=[Bnd(1).X,Bnd(1).X(1)];
    Bnd(1).wind_att=0.8;
        
    Bnd_Forcing(1).wind_file=sprintf('%s/wind/Wind_Kalbadagrund_1h_2016.asc',Info.folder); % Wind data
    Bnd_Forcing(1).ta_file=sprintf('%s/Ta/Ta_Kalbadagrund_1h_2016.asc',Info.folder); % Air temperature data
    Bnd_Forcing(1).tw_file=sprintf('%s/Tw/Tw_LL7mean_1h_2016.asc',Info.folder); % Water temperature data


    %% Boundary area 2
    Bnd(2).name='NBP';
    %           0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300 310 320 330 340 350
    Bnd(2).X=[ 29  28  26  32  35  38  87  87  87  87  87  87  87  49  46  42  40  50  50  50  44  48  67 137 370 503 300  59  39  40  35  31  23  21  24  26];
    %Bnd(2).X=[Bnd(2).X,Bnd(2).X(1)];
    Bnd(2).wind_att=0.8;
    
    Bnd_Forcing(2).wind_file=sprintf('%s/wind/Wind_Uto_1h_2016.asc',Info.folder); % Wind data
    Bnd_Forcing(2).ta_file=sprintf('%s/Ta/Ta_Uto_1h_2016.asc',Info.folder); % Air temperature data
    Bnd_Forcing(2).tw_file=sprintf('%s/Tw/Tw_LL7mean_1h_2016.asc',Info.folder); % Water temperature data
else
    % If boundary data are being loaded
    Bnd=[];
    Bnd_Forcing=[];
end

%% Nesting options
Nesting(1).valid_dir=[60 110]; % Propagation to the site only from these directions
Nesting(1).att=0.5; % Attenuation factor because of islands, directional spread etc.

Nesting(2).valid_dir=[220 270]; % Propagation to the site only from these directions
Nesting(2).att=0.4; % Attenuation factor because of islands, directional spread etc.

% Multiples of dt it takes for the boundary waves to arrive
Nesting(1).BoundaryDelay=8; % Tp=7s X=150 km
Nesting(2).BoundaryDelay=10; % Tp=7s X=200 km



function [E,fp,XP,XmX,XmF,Xmt] = wgrowth2(X,u,dt,EP,P)
%function [E,fp,XP] = wgrowth(X,u,dt,EP,P)
% X = The physical fetch [m]
% u = The wind speed at 10 metre height [m]
% dt = The model time step [s]
% EP = The wave energy from the previous time step [m^2]
% P = Coeffeicients for the wave growth relations

g=9.82; % Acceleration caused by gravity [m/s^2]

% Coefficients for the growth relation of the dimensionless peak freqeuncy
% fp=a2*X^a1
a1=P(1); a2=P(2); 

% Coefficients for the growth relation of the dimensionless energy
% E=b2*X^b1
b1=P(3); b2=P(4);


%% 1) Estimating the relevant fetch based on fetch limited growth
% This is simply the dimensionless physical fetch
XmX=g*X/(u*u);

%% 2) Estimating the relevant fetch based on a fully developed sea
% The value U19.5/cp=0.87 determined by Pierson and Moskowitz (1964) has been reduced to U10/cp=0.82 
XmF=(0.82/(a2*2*pi))^(1/a1);

%% 3) Estimating the relevant fetch based on duration limited growth
if EP > 0
    % Dimensionless fetch for the energy from the previous time step and
    % the wind speed from the current time step
    Emev=g*g*EP/u^4;
    Xmev=(Emev/b2)^(1/b1);
    
    % Use the fp growth relation to calculate the dimensionless duration it would have
    % taken the waves to travel the (dimensionless) fetch Xmev
    tmev=(4*pi*a2/(a1+1))*Xmev^(a1+1); % This is the integral of the dimensionless 1/cg from 0 the Xmev
else
    tmev = 0; % It has taken 0 second to grow the 0 energy from the last time step
end

% Use the fp growth relation to determine the dimensionless distance that the waves
% travel in tm seconds
tm = tmev + g*dt/u;
Xmt = (tm*(a1+1)/(4.0*pi*a2))^(1/(a1+1)); % This is the inverse of determining tmev above


%% Calculating the wave parameters
% The relevant dimensionless fetch is the minimum of the ones determined by the three
% restrictions
Xm=min([XmX,XmF,Xmt]);

% The dimensionless energy and peak freqeuncy
Em  = b2*Xm^b1;
fpm = a2*Xm^a1;

% The dimensional energy, peak frequency, and releavant fetch
E = Em*u^4/(g*g);
fp= g*fpm/u;
XP=Xm*u*u/g;

end

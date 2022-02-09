function Bnd=tstep2_boundary(Site,Bnd,dt,n,k)
%function Bnd=tstep2_boundary(Site,Bnd,dt,n,k)

if Bnd(k).checksum(n) % Dont calculate waves if the wind speed or direction is NaN
    %% Calculate the wave direction
    Bnd(k).Dw(n) = Bnd(k).Ud(n);
    U=Bnd(k).U(n);

    a = pntr(Bnd(k).Dw(n)); % Pointer for the direction dependent fetch-vector

    %% Calculate the waves energy and peak frequency
    % In practise the air and water temperature is the same as for
    % the actual site and this should be a good enough
    % approximation

    % This routine could be improved by calculating the waves in
    % the boundary area with the same routine as for the actual
    % site

    % Account for the role of the stratification
    [Rb, P]=BulkRichardson(Bnd(k).ta(n),Bnd(k).tw(n),Bnd(k).U(n)); 


    % Set fetch from km -> m and remove fetch of the actual site
%         try
        X=1000*(Bnd(k).X(a)-Site.X(a)); 
%         catch
%             keyboard
%         end
    [Bnd(k).E(n),Bnd(k).fp(n)] = wgrowth(X,U,dt,0,P);
else
    Bnd(k).E(n)=NaN;
    Bnd(k).fp(n)=NaN;
    Bnd(k).Dw(n)=NaN;


end
   
   
      
end
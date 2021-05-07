function [Bnd, Nesting]=KKWave_boundary(Info,Site,Bnd,Nesting,dt,init,fid)
% function Bnd=KKWave_boundary((Info,Site,Forcing,Bnd,Bnd_Forcing,Nesting,dt,fid)

if Info.IgnoreBoundary
    write_output('Ignoring all boundary conditions and creating a dummy 0 energy boundary!',fid,dbstack());
    clear Bnd
    Bnd(1).name='0_energy_dummy';
    Bnd(1).time=Site.time;
    Bnd(1).U=ones(1,length(Site.U))*0;
    Bnd(1).Ud=ones(1,length(Site.Ud))*0;
    Bnd(1).ta=ones(1,length(Site.ta))*5;
    Bnd(1).tw=ones(1,length(Site.tw))*5;
    Bnd(1).X=ones(1,length(Site.X));
    
    Bnd(1).E=ones(1,length(Site.U))*init.E_bnd;
    Bnd(1).fp=ones(1,length(Site.U))*init.fp_bnd;
    Bnd(1).Dw=ones(1,length(Site.U))*init.Dw_bnd;
    
    clear Nesting
    Nesting(1).valid_dir=[-9 -10]; % Set non physical values
    Nesting(1).att=ones(length(Site.X),1);
    Nesting(1).BoundaryDelay=1;
    
    
else
    
    if Info.BoundaryInput
        %% Load boundary data from a previous run
        write_output(sprintf('Loading boundary wave data << %s', Info.BoundaryInput),fid, dbstack());
        
        load(Info.BoundaryInput,'Bnd');

       if length(Bnd)~=length(Nesting)
           error('Number of boundary areas and number of nesting information not equal!');
       end
    else
       if length(Bnd)~=length(Nesting)
           error('Number of boundary areas and number of nesting information not equal!');
       end

        %% Calculate boundary wave data
        write_output('Calculating boundary wave conditions',fid,dbstack());
        for k=1:length(Bnd) % Loop through the different boundary areas
            write_output(sprintf('# Boundary area [%s]',Bnd(k).name),fid); 
            for n=2:length(Site.time)
                Bnd=tstep2_boundary(Site,Bnd,dt,n,k); 
            end
        end
        %% Save boundary wave data if requested
        if Info.BoundaryOutput
            Fn=sprintf('bnd/BND_for_%s.mat',Info.name);
            save(Fn,'Bnd');
            write_output(sprintf('Saving boundary wave data >> %s', Fn),fid,dbstack());
        end
    end

end

end
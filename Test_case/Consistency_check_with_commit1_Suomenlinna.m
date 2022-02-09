%% This script checks if the results are consistent with that of the first commit in 11.10.2019 for the year 2016 (GoF and Suomenlinna)
%% If this test is not passed, then something might be wrong with the code modifications unless you changed something on purpose
clear
close all

%% Test GoF
%% Load original commit files
fprintf('###Testing Suomenlinna data for 2016\n');
fprintf('>>Loading data from commit1 (Test_case/)...\n');
gofc1=load('KKW_Suomenlinna2016.mat');
fprintf('>>Loading current data from data from wave_output...\n');
gof=load('../wave_output/KKW_Suomenlinna2016.mat');

% Check basic variables
Fn=fieldnames(gofc1);

for n=1:length(Fn)
    P=Fn{n};
    if ~isstruct(gofc1.(P))

        fprintf('%s... ',P);

        testgof.(P)=max(abs(gof.(P)-gofc1.(P)));
        if testgof.(P)>2*eps
            warning('\nGoF %s test failed! Max diff %.5f\n',P,testgof.(P))
        else
            fprintf('Ok!\n');
        end
    else
        fprintf('#Checking struct %s...\n',P);
        switch P
            case 'Site'
                Fn2=fieldnames(gofc1.(P));
                for k=1:length(Fn2)
                    P2=Fn2{k};
                    if isfloat(gofc1.(P).(P2))
                        fprintf('%s.%s... ',P,P2);
                            testgof.(P).(P2)=max(abs(gof.(P).(P2)-gofc1.(P).(P2)));
                            if testgof.(P).(P2)>2*eps
                                warning('\nGoF %s.%s test failed! Max diff %.5f\n',P,P2,testgof.(P).(P2))
                            else
                                fprintf('Ok!\n');
                            end
                        
                    end
                end
                
            otherwise
                Fn2=fieldnames(gofc1.(P));
                for ll=1:length(gofc1.(P))
                    for k=1:length(Fn2)
                    P2=Fn2{k};
                    if isfloat(gofc1.(P)(ll).(P2))

                        fprintf('%s(%.0f).%s... ',P,ll,P2);
                        testgof.(P).(P2)=max(abs(gof.(P)(ll).(P2)-gofc1.(P)(ll).(P2)));
                        if testgof.(P).(P2)>2*eps
                            warning('\nGoF %s.%s test failed! Max diff %.5f\n',P,P2,testgof.(P)(ll).(P2))
                        else
                            fprintf('Ok!\n');
                        end
                    end

                    end
                end

                
                
        end
        
        
        
    end
end
   





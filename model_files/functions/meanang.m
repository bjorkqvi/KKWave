% This program calculates the vector-mean of a sample
%
% Input options:
% 'deg'  0-360, 0 = North
% 'rad' 0-2*pi, 0 = East
%
% Output:
% M = the mean angle
% Q = The length of the mean vector
% function M = meanang(A,W,type)

function [M, Q]= meanang(A,W,type)

if nargin==2 % No weight defined
    type=W;
    W=A*0+1;
end

switch type
    case 'deg'
        %~ disp('using deg values');	
        S=mean(mean(sin(A*pi/180).*W));
        C=mean(mean(cos(A*pi/180).*W));

        % Change very small values because according to Octave sin(pi)=1.2246e-16
        S(abs(S)<eps)=0;
        C(abs(C)<eps)=0;
        
        Q=norm([S,C]);
        M=180/pi*atan2(S,C);

        % Force the result to be a positive angle
        M=max(mod(M,360));


    case 'rad'
        %~ disp('using rad values');
        S=mean(mean(sin(A).*W));
        C=mean(mean(cos(A).*W));
        % Change very small values because according to Octave sin(pi)=1.2246e-16
        S(abs(S)<eps)=0;
        C(abs(C)<eps)=0;
        Q=norm([S,C]);
        M=atan2(S, C);


    case 'test'
        disp('Testing the function using deg values...');
        testMatrix = {[0 180],  0, [90 270], 0,  [0 90 180 270], 0, [0 90] ,45, [0 45 90], 45, [0 180 270], 270};
        ct=1;
        for n=1:length(testMatrix)/2
            test = vectormean(testMatrix{ct}, 'deg');
            if test ~= testMatrix{ct+1}
                disp(testMatrix{ct});
                error(sprintf('Test failed! vectormean of matrix returned %f. Expecting %f', test, testMatrix{ct+1}));
            end
            ct=ct+2;
        end
        disp('All tests ok!');

    otherwise
        disp('use type deg or rad');	


end

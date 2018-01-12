function [f,P1] = TauFFT(Table,N)
% A function to compute the sigle-sided spectrum of some oscillating flow
%   property in a Tau unsteady simulation (eg. CL).

% 'Table':  Table of values generated from solution.dat file. Use
%   'ExtractPvals.m' function. 
% 'N': Number of bins to to split the time domain into.

% 'P1' Single-sided spectrum of unsteady 


    if mod(length(Table.thistime),N) ~=0
        BinLength = int32(length(Table.thistime)/N)-1;
    else
        BinLength = int32(length(Table.thistime)/N);
    end

    for n=1:N
        % choose which flow variable to use here.
            Bin(:,n) = Table.C0x2Dlift(BinLength*(n-1)+1:BinLength*n);
    end


    %------- Perform FFT on each Bin -------%

    T = Table.thistime(1); % Sampling period 
    Fs = 1/T;               % Sampling frequency                                     
    L = BinLength;          % Length of signal
    t = (0:L-1)*T;          % Time vector

    for n=1:N
            Y(:,n) = abs(fft(Bin(:,n)));
            P2(:,n) = Y(:,n)/double(L);          % Compute the two-sided spectrum P2.
            P1(:,n) = P2(1:L/2+1,n);
            P1(2:end-1,n) = 2*P1(2:end-1,n);
    end

    if mod(BinLength,2) ==1
        f = Fs*(0:(double(L)/2)+1)/double(L);     % Define the frequency domain f
    else f = Fs*(0:(double(L)/2))/double(L);
    end
end


%------- Script to postprocess unsteady results --------%

clear all
close all
Case_D = ExtractPvals('l4/Case_D/run01Iridis/Sol/solution.monitor.pval.unsteady.dat');
Case_C = ExtractPvals('l4/Case_C/run01/Sol/solution.monitor.pval.unsteady.dat');
Case_B = ExtractPvals('l4/Case_B/run02/Sol/solution.monitor.pval.unsteady.dat');
Case_A = ExtractPvals('l4/Case_A/run02/Sol/solution.monitor.pval.unsteady.dat');

ThisCase = Case_D;

%------- Break simulation into N bins -------%
for N = 4:2:80
    clear Bin;
    clear Y;
    clear P2;
    clear P1;

if mod(length(ThisCase.thistime),N) ~=0
    BinLength = int32(length(ThisCase.thistime)/N)-1;
else
    BinLength = int32(length(ThisCase.thistime)/N);
end

for n=1:N
        Bin(:,n) = ThisCase.C0x2Dlift(BinLength*(n-1)+1:BinLength*n);
end
 

%------- Perform FFT on each Bin -------%

T = ThisCase.thistime(1); % Sampling period 
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

figure(4)
hold on
plot(N,f(find(P1(:,N-1) == max(P1(:,N-1)),1)),'.b');
xlabel('Number of bins','Interpreter','latex')
ylabel('Peak frequency of penultimate bin (Hz)','Interpreter','latex')
title('Plot of peak spectral value of (N-1)th bin for varying N for Case D')
end

%--------- Plot section ---------%

figure(1)
semilogy(Case_A.thistime,Case_A.Rrho)
hold on 
semilogy(Case_B.thistime,Case_B.Rrho)
semilogy(Case_C.thistime,Case_C.Rrho)
semilogy(Case_D.thistime,Case_D.Rrho)
lgd = legend('Case A', 'Case B', 'Case C', 'Case D');
set(lgd, 'Interpreter', 'latex')
title('Time history of Rrho for each test case', 'Interpreter', 'latex')
xlabel('Time (s)', 'Interpreter', 'latex')
ylabel('Rrho', 'Interpreter', 'latex')

figure(2)
hold on
plot(ThisCase.thistime,ThisCase.C0x2Dlift,'.')
% plot(Case_B.thistime,Case_B.C0x2Dlift,'.')
% plot(Case_C.thistime,Case_C.C0x2Dlift,'.')
xlabel('Simulation time (s)','Interpreter','latex')
ylabel('$$C_L$$','Interpreter','latex')
title('Time history of CL for Case D')
% title('Final C_L peak for Cases B-D')
 xlim([7 7.35])
 ylim([0.9 1.041])
% lgd = legend('Case B', 'Case C', 'Case D');
% set(lgd, 'Interpreter', 'latex')
tvert = linspace(min(ThisCase.C0x2Dlift),max(ThisCase.C0x2Dlift));
for n=1:N-1
    %plot(zeros(1,100)+ThisCase.thistime(n*BinLength),tvert,'--k');
end

figure(3)
hold on
plot(f,P1(:,N/2:N-1))
f(find(P1(:,N-1) == max(P1(:,N-1)),1));
xlim([0,20])
xlabel('Frequency (Hz)','Interpreter','latex')
ylabel('Amplitude','Interpreter','latex')
title('Spectra of bins N/2 to N-1 for Case D')
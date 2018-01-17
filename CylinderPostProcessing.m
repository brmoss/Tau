%------- Script to postprocess unsteady results --------%

clear all
close all
Case_D = ExtractPvals('l4/Case_D/run01Iridis/Sol/solution.monitor.pval.unsteady.dat');
Case_C = ExtractPvals('l4/Case_C/run01/Sol/solution.monitor.pval.unsteady.dat');
Case_B = ExtractPvals('l4/Case_B/run02/Sol/solution.monitor.pval.unsteady.dat');
Case_A = ExtractPvals('l4/Case_A/run02/Sol/solution.monitor.pval.unsteady.dat');

ThisCase = Case_D;

%------- Break simulation into N bins -------%
for N = 4:80
    [f,P1, BinLength] = TauFFT(ThisCase,N);

figure(4)
hold on
plot(N,f(find(P1(:,N-1) == max(P1(:,N-1)),1)),'ob');
xlabel('Number of bins','Interpreter','latex')
ylabel('Peak frequency of penultimate bin (Hz)','Interpreter','latex')
title('Plot of peak spectral value of (N-1)th bin for varying N for Case D','Interpreter','latex')
end

%--------- Plot section ---------%

N=8;
[f,P1, BinLength] = TauFFT(ThisCase,N);

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
title('Time history of CL for Case D','Interpreter','latex')
% title('Final C_L peak for Cases B-D')
%  xlim([7 7.35])
%  ylim([0.9 1.041])
% lgd = legend('Case B', 'Case C', 'Case D');
% set(lgd, 'Interpreter', 'latex')
tvert = linspace(min(ThisCase.C0x2Dlift),max(ThisCase.C0x2Dlift));
for n=1:N-1
    plot(zeros(1,100)+ThisCase.thistime(n*BinLength),tvert,'--k');
end


figure(3)
hold on
plot(f,P1(:,N/2:N-1))
f(find(P1(:,N-1) == max(P1(:,N-1)),1));
xlim([0,20])
xlabel('Frequency (Hz)','Interpreter','latex')
ylabel('Amplitude','Interpreter','latex')
title('Spectra of bins N/2 to N-1 for Case D (N=8)','Interpreter','latex')
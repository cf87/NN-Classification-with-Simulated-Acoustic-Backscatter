%Creates new water-sediment realizations saved as text files (to later be
% imported by COMSOL to set up the geometry of the PDE)

N=1000;
rL=10;
rms=.02; % 2 cm
cl=.02;
x = linspace(-rL/2,rL/2,N);
F = exp(-x.^2/(cl^2/2)); % Gaussian filter
%%
for realizationNum = 1:100
    
    
    interface_name = sprintf('1D-relief-RMS-%.2f-CL-%.2f_%03d', rms, cl, realizationNum);
    fid=fopen(sprintf('%s.txt', interface_name),'w');
    Z = rms.*randn(1,N); % uncorrelated Gaussian random rough surface distribution with mean 0 and standard deviation h
    f = sqrt(2/sqrt(pi))*sqrt(rL/N/cl)*ifft(fft(Z).*fft(F)); %correlation of surface using convolution (faltung), inverse Fourier transform and normalizing prefactors
    
   
    % autocovariance function calculation
    c=xcov(f,'coeff');  % the autocovariance function
    acf=c(N:2*N-1);     % right-sided version
    
    % correlation length calculation
    k = 1;
    
    while (acf(k) > 1/exp(1))
        k = k + 1;
    end
    
    cl_true = 1/2*(x(k-1)+x(k)-2*x(1)); % the correlation length
    
    fprintf(fid, '*** %s, RMS Height = %f, Correlation Length = %f\n ', interface_name, h, cl_true);
    fprintf(fid, '%10s\t %10s\t %10s\n', 'x', 'f', 'acf');
    fprintf(fid, '%2.8f\t %2.8f\t %2.8f\n', [x+max(x); f; acf] );
    fclose(fid);
    
end

function u_llr = polar_SC_decode(initial_llr)
    global PCparams;
    N = PCparams.N;
    n = PCparams.n;
    PCparams.L = zeros(N,n+1);
    PCparams.B = zeros(N,n+1);
    PCparams.L(:,n+1) = initial_llr';
    
    for phi = 0:N-1
        updateL(n,phi);
        if PCparams.FZlookup(phi+1) == 0
            PCparams.B(phi+1,1) =  0;
        else
            if PCparams.L(phi+1,1)<0
                PCparams.B(phi+1,1) = 1;
            else
                PCparams.B(phi+1,1) = 0;
            end
        end
        if mod(phi,2)==1
            updateB(n,phi);
        end
    end
    
    u_llr = PCparams.L(:,1);
    
end
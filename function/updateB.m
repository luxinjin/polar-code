function updateB(lambda,phi)
    global PCparams;
    n = PCparams.n;
    
    psi = floor(phi/2);
    if mod(phi,2)~=0
        for omega = 0:2^(n-lambda)-1
            PCparams.B(psi+2*omega*2^(lambda-1)+1,n+2-lambda) = xor(PCparams.B(phi-1+omega*2^(lambda)+1,n+1-lambda),PCparams.B(phi+omega*2^(lambda)+1,n+1-lambda));
            PCparams.B(psi+(2*omega+1)*2^(lambda-1)+1,n+2-lambda) = PCparams.B(phi+omega*2^(lambda)+1,n+1-lambda);
        end
        if mod(psi,2)~=0
            updateB(lambda-1,psi);
        end
    end
end
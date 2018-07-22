function [u_llr,c_llr] = polar_BP_decode(initialLLRs,BP_ITER_NUM)
    
    global PCparams;
    n = PCparams.n;
    N = PCparams.N;
   
    L = zeros(N,n+1);
    R = zeros(N,n+1);
    inf_num = 1000;
    L(:,n+1) = initialLLRs';
    R(PCparams.FZlookup==0,1) = inf_num;
    
    for iter = 1:BP_ITER_NUM
        
        for lambda = 1:n
            for phi = 0:2^lambda-1
                psi = floor(phi/2);
				for omega = 0:2^(n-lambda)-1
					if mod(phi,2)==0	
						L(phi+omega*2^lambda+1,n+1-lambda)= fFunction(L(psi+2*omega*2^(lambda-1)+1,n+2-lambda),L(psi+(2*omega+1)*2^(lambda-1)+1,n+2-lambda)+R(phi+1+omega*2^lambda+1,n+1-lambda));
					else
						L(phi+omega*2^lambda+1,n+1-lambda)= L(psi+(2*omega+1)*2^(lambda-1)+1,n+2-lambda)+fFunction(L(psi+2*omega*2^(lambda-1)+1,n+2-lambda),R(phi-1+omega*2^lambda+1,n+1-lambda));
					end
				end
            end
        end
        
        for lambda = n:-1:1
            for phi = 0:2^lambda-1
				psi = floor(phi/2);
                if mod(phi,2)~=0	
                    for omega = 0:2^(n-lambda)-1
						R(psi+2*omega*2^(lambda-1)+1,n+2-lambda)= fFunction(L(psi+(2*omega+1)*2^(lambda-1)+1,n+2-lambda)+R(phi+omega*2^lambda+1,n+1-lambda), R(phi-1+omega*2^lambda+1,n+1-lambda));
						R(psi+(2*omega+1)*2^(lambda-1)+1,n+2-lambda)= R(phi+omega*2^lambda+1,n+1-lambda)+fFunction(L(psi+(2*omega)*2^(lambda-1)+1,n+2-lambda),R(phi-1+omega*2^lambda+1,n+1-lambda));
					end
				end
            end
        end
        
    end
    
    %è®¡ç®—æœ?»ˆè¾“å‡ºllr
    u_llr = L(:,1)+R(:,1);
    c_llr = R(:,n+1);
end
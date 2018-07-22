function [u_llr, c_llr] = polar_SCAN_decode(y_llr,iter_num)
    %初始化PCparams.L 和 PCparams.B
    global PCparams;
    N = PCparams.N;
    n = PCparams.n;
    
    plus_infinity = 1000;
    PCparams.L = zeros(N,n+1);%left message
    PCparams.B = zeros(N,n+1);%right message
    PCparams.L(:,n+1) = y_llr';%initial L
    PCparams.B(PCparams.FZlookup==0,1) = plus_infinity;%initial B

    
    %主循环
    for ii = 1:iter_num
        for phi = 0:N-1
            updateLLRMap(n,phi);

            if mod(phi,2)~=0
                %修订=============================
                 %PCparams.B(phi:phi+1,1) =  PCparams.B(phi:phi+1,1)+0.1*PCparams.L(phi:phi+1,1);
                 %================================
                updateBitMap(n,phi);          
            end
        end
        %PCparams.B =  PCparams.B+PCparams.L;
    end
       
    %输出最终的左信息u_llr和右信息c_llr
    u_llr = PCparams.L(:,1)+PCparams.B(:,1);
    
    c_llr = PCparams.B(:,n+1);
    
    
end

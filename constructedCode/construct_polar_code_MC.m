%使用蒙特卡洛方法构造polar code
%panzhipeng
%zhipengpan10@163.com
function construct_polar_code_MC(N,design_snr_dB)
    M = 1e7; %simulation nums
    n = ceil(log2(N)); 
    NN = 2^n;
    if(NN~=N)
        fprintf('The num N must be the power of 2!');
        return;
    end
    file_name = sprintf('PolarCode_block_length_%d_designSNR_%.2fdB_method_MC.txt',N,design_snr_dB);
    fid = fopen(file_name,'w+');
    
    global LB;
    LB = struct(  'L', zeros(N,n+1), ...
                  'n', n, ...
                  'B', zeros(N,n+1));
    z = zeros(1,N); 
    design_snr_num = 10^(design_snr_dB/10);
    d = zeros(1,N);
    for iii = 1:M
       y = -sqrt(design_snr_num)+randn(N,1);
       initial_llr = -2*y*sqrt(design_snr_num);
       LB.L(:,n+1) = initial_llr;
       for phi = 0:N-1
        updateL(n,phi);
        if LB.L(phi+1,1)<0
            d(phi+1) = 1;
        else
            d(phi+1) = 0;
        end
       end
       
       z = z+d;
    end
    
    z = z/M
    [~,indices] = sort(z,'ascend');
    for ii = 1:length(z)
        fprintf(fid,'%d\r\n',indices(ii));
    end
    fclose(fid);
end

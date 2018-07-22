function initPC(N,K,construction_method,design_snr_dB,sigma,crc_size) 
%       USAGE:
%            N  -  Blocklength; (*immediately adjusted to the least power-of-2 >=N*)
% 
%            K  -  Message length (Rate = K/N); 
global PCparams;

% Adjust N & n to the next power of 2, incase supplied N is not a power-of-2.
n = ceil(log2(N)); 
N = 2^n;

PCparams = struct('N', N, ...
                  'K', K, ...
                  'n', n, ...
                  'FZlookup', zeros(1,N), ...
                  'L', zeros(N,n+1), ...
                  'B', zeros(N,n+1),...
                  'bitreversedindices',zeros(N,1),...
				  'crc_size',0);
				  
for index = 1 : N
	PCparams.bitreversedindices(index) = bin2dec(wrev(dec2bin(index-1,n)));
end


if crc_size ~= 0
    PCparams.crc_size = crc_size;
	PCparams.crc_matrix = floor(2*rand(PCparams.crc_size, K));
end


    switch construction_method
        case 0
            constructed_code_file_name = sprintf('constructedCode\\PolarCode_block_length_%d_designSNR_%.2fdB_method_BhattaBound.txt',N,design_snr_dB);
        case 1
            constructed_code_file_name = sprintf('constructedCode\\PolarCode_block_length_%d_sigma_%.2f_method_GA.txt',N,sigma);
    end
            
    
    %should first use construct_polar_code(n) to construct the polar code
    indices = load(constructed_code_file_name);
    PCparams.FZlookup = zeros(1,N);
    if PCparams.crc_size == 0
        PCparams.FZlookup(indices(1:K)) = -1;
    else
        PCparams.FZlookup(indices(1:K+PCparams.crc_size)) = -1;
    end
    
    

end

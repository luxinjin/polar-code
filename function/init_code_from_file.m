%infobits-----message
%N-----code length

function init_code_from_file(K,N,sigma) 
    global PCparams;

    file_name = sprintf('PolarCode_block_length_%d_sigma_%.2f_method_GA.txt',N,sigma);
    %should first use construct_polar_code(n) to construct the polar code
    indices = load(file_name);
    PCparams.FZlookup = zeros(1,N);
    if PCparams.crc_size == 0
        PCparams.FZlookup(indices(1:K)) = -1;
    else
        PCparams.FZlookup(indices(1:K+PCparams.crc_size)) = -1;
    end
    
end
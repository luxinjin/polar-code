function continuePaths_FrozenBit(phi)
     global PCparams;       
    for l_index = 0 : PCparams.list_size -1

        if PCparams.activePathArray(l_index + 1) == 0
            continue;
        end

        l_index_1 = getArrayPointer_C(PCparams.n, l_index);
        PCparams.c_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1, mod(phi, 2) + 1) = 0;
       
        PCparams.llr_path_metric(l_index_1 + 1) = PCparams.llr_path_metric(l_index_1 + 1) ...
                + log(1 + exp(-PCparams.llr_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1)));
        
    end

end
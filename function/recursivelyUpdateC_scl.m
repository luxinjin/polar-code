function recursivelyUpdateC_scl(lambda, phi)
global PCparams;
    if mod(phi, 2) == 0
        disp('Error: phi should always be odd in this function call');
    end
    psi = floor(phi/2);

    for l_index = 0 : PCparams.list_size - 1
        if PCparams.activePathArray(l_index + 1) == 0
            continue;
        end

        l_index_1 = getArrayPointer_C(lambda, l_index);
        l_index_2 = getArrayPointer_C(lambda - 1, l_index);

        p_index_1 = PCparams.lambda_offset(lambda + 1) + PCparams.list_offset(l_index_1 + 1)  + 1;
        p_index_2 = PCparams.lambda_offset(lambda) + PCparams.list_offset(l_index_2 + 1)  +  1;

        for beta = 0: 2^(PCparams.n - lambda) - 1
            PCparams.c_scl(p_index_2 + 2*beta, mod(psi, 2) + 1) = ...
                mod( PCparams.c_scl(p_index_1 + beta, 1) + ...
                PCparams.c_scl(p_index_1 + beta, 2),  2);
            PCparams.c_scl(p_index_2 + 2 * beta + 1, mod(psi, 2) + 1) = ...
                PCparams.c_scl(p_index_1 + beta, 2);
        end

    end

    if mod(psi, 2) == 1
        recursivelyUpdateC_scl(lambda - 1, psi);
    end

end
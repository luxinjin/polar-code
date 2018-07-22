function recursivelyCalcP_scl(lambda, phi)
     
   global PCparams;
    if lambda == 0
        return;
    end

    psi = floor(phi/2);
    if mod(phi, 2) == 0
        recursivelyCalcP_scl(lambda - 1, psi);
    end

   
    p_index_3_base_list = zeros(PCparams.list_size, 1);
    l_index_1_list = zeros(PCparams.list_size, 1);
    for l_index = 0 : PCparams.list_size - 1
        if PCparams.activePathArray(l_index + 1) == 0
            continue;
        end
        l_index_1_list(l_index+1) = getArrayPointer_P(lambda, l_index);
        l_index_2 = getArrayPointer_P(lambda - 1, l_index);
        l_index_3 = getArrayPointer_C(lambda, l_index);

        p_index_1_base = PCparams.lambda_offset(lambda) + PCparams.list_offset(l_index_2 + 1) + 1;
        p_index_3_base_list(l_index+1) = PCparams.lambda_offset(lambda + 1) + PCparams.list_offset(l_index_1_list(l_index+1) + 1) + 1;
        c_index_3_base = PCparams.lambda_offset(lambda + 1) + PCparams.list_offset(l_index_3 + 1) + 1;
        for beta = 0: 2^(PCparams.n - lambda) - 1
            p_index_1 = p_index_1_base + 2 * beta;
            p_index_2 = p_index_1_base + 2 * beta + 1;
            p_index_3 = p_index_3_base_list(l_index+1) + beta;
            if mod(phi, 2) == 0
               
                if max( abs(PCparams.llr_scl ( p_index_1)), abs(PCparams.llr_scl ( p_index_2)) ) < 40
                    PCparams.llr_scl(p_index_3) = log( (exp( PCparams.llr_scl ( p_index_1) + PCparams.llr_scl ( p_index_2)) + 1) ...
                        /(exp( PCparams.llr_scl ( p_index_1))  + exp( PCparams.llr_scl ( p_index_2))) );
                else
                    PCparams.llr_scl(p_index_3) = sign( PCparams.llr_scl ( p_index_1)) * sign(PCparams.llr_scl ( p_index_2)) * min(abs(PCparams.llr_scl ( p_index_2)), abs(PCparams.llr_scl ( p_index_1)));
                end
               
            else
                u_p = PCparams.c_scl( c_index_3_base + beta, 1);
                
                PCparams.llr_scl(p_index_3) = (-1)^u_p * PCparams.llr_scl(p_index_1) +  PCparams.llr_scl(p_index_2);
                
            end
        end
    end

  

end
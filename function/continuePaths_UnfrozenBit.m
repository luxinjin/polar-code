function    continuePaths_UnfrozenBit(phi)
    global PCparams;        
    probForks = -realmax * ones(PCparams.list_size, 2);
    index = 0;
    for l_index = 0 : PCparams.list_size - 1

        if PCparams.activePathArray(l_index + 1)
            l_index_1 = getArrayPointer_P(PCparams.n, l_index);
            
        % computing negative of path metric so that an
        % ascending order can be used for sorting
        probForks(l_index + 1, 1) =  - (PCparams.llr_path_metric(l_index_1 + 1) ...
            + log(1 + exp(-PCparams.llr_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1))));
        probForks(l_index + 1, 2) =  - ( PCparams.llr_path_metric(l_index_1 + 1) ...
            + log(1 + exp(PCparams.llr_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1))));
            
            index = index + 1;

        end
    end

    rho = min(2*index, PCparams.list_size);
    contForks = zeros(PCparams.list_size, 2);
    prob = sort(probForks(:), 'descend');

    threshold = prob(rho);
    num_populated = 0;
    for l_index = 0 : PCparams.list_size - 1
        for j_index = 1 : 2
            if num_populated == rho
                break;
            end
            if  probForks(l_index + 1, j_index) > threshold
                contForks(l_index + 1, j_index) = 1;
                num_populated = num_populated + 1;
            end
        end
    end

    if num_populated < rho
        for l_index = 0 : PCparams.list_size - 1
            for j_index = 1 : 2
                if num_populated == rho
                    break;
                end
                if  probForks(l_index + 1, j_index) == threshold
                    contForks(l_index + 1, j_index) = 1;
                    num_populated = num_populated + 1;
                end
            end
        end
    end


    for l_index = 0 : PCparams.list_size - 1
        if PCparams.activePathArray(l_index + 1) == 0
            continue;
        end

        if (contForks(l_index + 1, 1) == 0) && ( contForks(l_index + 1, 2) == 0)
            killPath(l_index);
        end
    end

    for l_index = 0 : PCparams.list_size - 1
        if (contForks(l_index + 1, 1) == 0) && ( contForks(l_index + 1, 2) == 0)
            continue;
        end
        l_index_1 = getArrayPointer_C(PCparams.n, l_index);
        if (contForks(l_index + 1, 1) == 1) && ( contForks(l_index + 1, 2) == 1)
            PCparams.c_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1, mod(phi,2) + 1) = 0;
            PCparams.i_scl(l_index_1 + 1, phi + 1) = 0;

            l_p = clonePath(l_index);

            l_index_2 = getArrayPointer_C(PCparams.n, l_p);
            PCparams.i_scl(l_index_2 + 1, 1 : phi) = PCparams.i_scl(l_index_1 + 1, 1 : phi);
            PCparams.c_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_2 + 1) + 1, mod(phi,2) + 1) = 1;
            PCparams.i_scl(l_index_2 + 1, phi + 1) = 1;
            
            PCparams.llr_path_metric(l_index + 1) = PCparams.llr_path_metric(l_index + 1) ...
                + log(1 + exp(-PCparams.llr_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1)));
            PCparams.llr_path_metric(l_p + 1) = PCparams.llr_path_metric(l_p + 1) ...
                + log(1 + exp(PCparams.llr_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_2 + 1) + 1)));
            

        else
            if contForks(l_index + 1, 1) == 1
                PCparams.c_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1, mod(phi,2) + 1) = 0;
                PCparams.i_scl(l_index_1 + 1, phi + 1) = 0;
                
                PCparams.llr_path_metric(l_index + 1) = PCparams.llr_path_metric(l_index + 1) ...
                        + log(1 + exp(-PCparams.llr_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1)));
                
            else
                PCparams.c_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1, mod(phi,2) + 1) = 1;
                PCparams.i_scl(l_index_1 + 1, phi + 1) = 1;
                
                PCparams.llr_path_metric(l_index + 1) = PCparams.llr_path_metric(l_index + 1) ...
                        + log(1 + exp(PCparams.llr_scl(PCparams.lambda_offset(PCparams.n + 1) + PCparams.list_offset(l_index_1 + 1) + 1)));
                
            end
        end

    end

end
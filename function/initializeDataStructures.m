function initializeDataStructures()
     
    global PCparams;
    
    PCparams.inactivePathIndices = zeros(PCparams.list_size,1);
    PCparams.inactivePathIndicesSize = 0;
    % the above two variables are used to define a stack

    PCparams.activePathArray =  zeros(PCparams.list_size,1);
    PCparams.pathIndexToArrayIndex = zeros(PCparams.n  + 1, PCparams.list_size);

    PCparams.inactiveArrayIndices = zeros(PCparams.n  + 1, PCparams.list_size);
    PCparams.inactiveArrayIndicesSize = zeros(PCparams.n + 1, 1);
    % the above two variables are used to define a vector of stacks

    PCparams.arrayReferenceCount = zeros(PCparams.n  + 1, PCparams.list_size);

   
    PCparams.llr_scl = zeros(PCparams.list_size * (2 * PCparams.N - 1), 1);
    PCparams.llr_path_metric =  zeros(PCparams.list_size, 1);
  

    PCparams.c_scl = zeros(PCparams.list_size * (2 * PCparams.N - 1), 2);
    PCparams.i_scl = zeros(PCparams.list_size, PCparams.N);
    
    PCparams.lambda_offset = (2.^( PCparams.n - (0:  PCparams.n)) - 1);
    PCparams.list_offset = (0:PCparams.list_size)*(2 *  PCparams.N - 1);    

    for lambda = 0 : PCparams.n
        for i_list = 0 : PCparams.list_size - 1
            PCparams.inactiveArrayIndices(lambda + 1, i_list + 1) = i_list;
        end
        PCparams.inactiveArrayIndicesSize(lambda + 1) = PCparams.list_size;
    end

    for i_list = 0 : PCparams.list_size - 1
        PCparams.activePathArray(i_list + 1) = 0;
        PCparams.inactivePathIndices(i_list + 1) = i_list;
    end

    PCparams.inactivePathIndicesSize  = PCparams.list_size;
            
end
function killPath(l_index)
    global PCparams;
    %the path is active or not, should operate both the array activePathArray and
    %stack inactivePathIndices
    PCparams.activePathArray(l_index + 1) = 0;
    PCparams.inactivePathIndices(PCparams.inactivePathIndicesSize + 1) = l_index;
    PCparams.inactivePathIndicesSize = PCparams.inactivePathIndicesSize  + 1;
    
    PCparams.llr_path_metric(l_index + 1) = 0;
    
    for lambda = 0 : PCparams.n
        s = PCparams.pathIndexToArrayIndex(lambda + 1, l_index + 1);
        PCparams.arrayReferenceCount(lambda + 1, s + 1) = PCparams.arrayReferenceCount(lambda + 1, s + 1) - 1;
        if PCparams.arrayReferenceCount(lambda + 1, s + 1) == 0
            PCparams.inactiveArrayIndices(lambda + 1, PCparams.inactiveArrayIndicesSize(lambda + 1) + 1) = s;
            PCparams.inactiveArrayIndicesSize(lambda + 1)  = PCparams.inactiveArrayIndicesSize(lambda + 1)  + 1;
        end
    end
end
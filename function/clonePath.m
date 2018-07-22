function l_p_index = clonePath(l_index)
    global PCparams;
    
    l_p_index = PCparams.inactivePathIndices(PCparams.inactivePathIndicesSize);
    PCparams.inactivePathIndicesSize = PCparams.inactivePathIndicesSize - 1;
    PCparams.activePathArray(l_p_index + 1) = 1; %pop a new path

    
    PCparams.llr_path_metric(l_p_index + 1) = PCparams.llr_path_metric(l_index + 1);
    
%make the new path l_p_index reference the same arrays as l_index
    for lambda = 0 : PCparams.n
        s = PCparams.pathIndexToArrayIndex(lambda + 1, l_index + 1);
        PCparams.pathIndexToArrayIndex(lambda + 1, l_p_index + 1) = s;
        PCparams.arrayReferenceCount(lambda + 1, s + 1) = PCparams.arrayReferenceCount(lambda + 1, s + 1) + 1;
    end
end
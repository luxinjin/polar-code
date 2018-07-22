function [s_p] = getArrayPointer_P(lambda, l_index)
    global PCparams;
    s = PCparams.pathIndexToArrayIndex(lambda + 1, l_index + 1);
    m = PCparams.n;
    if PCparams.arrayReferenceCount(lambda + 1, s + 1) == 1
        s_p = s;
    else
        % do the copy of s to s_p
        s_p = PCparams.inactiveArrayIndices(lambda + 1, PCparams.inactiveArrayIndicesSize(lambda + 1));
        i_s_p = PCparams.lambda_offset(lambda + 1) + PCparams.list_offset(s_p + 1) + 1: ...
            PCparams.lambda_offset(lambda + 1) + PCparams.list_offset(s_p + 1) + 2^(m - lambda);
        i_s = PCparams.lambda_offset(lambda + 1) + PCparams.list_offset(s + 1) + 1: ...
            PCparams.lambda_offset(lambda + 1) + PCparams.list_offset(s + 1) + 2^(m - lambda);
        PCparams.c_scl(i_s_p, :) = PCparams.c_scl(i_s, :);
        
        PCparams.llr_scl(i_s_p) = PCparams.llr_scl(i_s);
        
        PCparams.inactiveArrayIndicesSize(lambda + 1) = PCparams.inactiveArrayIndicesSize(lambda + 1) - 1;
        PCparams.arrayReferenceCount(lambda + 1, s + 1) = PCparams.arrayReferenceCount(lambda + 1, s + 1) - 1;
        PCparams.arrayReferenceCount(lambda + 1, s_p + 1) = 1;
        PCparams.pathIndexToArrayIndex(lambda + 1, l_index + 1) = s_p;
    end
end
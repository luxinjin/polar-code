function index = get_i_scl(lambda, beta, list_index)
    global PCparams;
    lambda_offset = PCparams.lambda_offset;
    list_offset = PCparams.list_offset ;
    index = beta + lambda_offset(lambda + 1) + list_offset(list_index + 1);
end
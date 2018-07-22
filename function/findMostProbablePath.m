function [l_p_index] = findMostProbablePath(is_crc_check)
    global PCparams;        
    l_p_index = 0; 
    p_max = realmax;
	path_with_crc = 0;
    for l_index = 0 : PCparams.list_size -1

        if PCparams.activePathArray(l_index + 1) == 0
            continue;
        end   
		c_index = getArrayPointer_C( PCparams.n, l_index);
		if (is_crc_check) && (PCparams.crc_size ~= 0)
			a = PCparams.i_scl(c_index+1,:);
			u = a(PCparams.FZlookup == -1);
			if crc_check(u) == 0
				continue;
			end
		end
		path_with_crc = 1;
        if p_max > PCparams.llr_path_metric(l_index + 1)
            p_max = PCparams.llr_path_metric(l_index + 1);
            l_p_index = l_index;
        end
        
    end
	if (is_crc_check) && (path_with_crc == 0) % no path with crc check found
		l_p_index = findMostProbablePath(0);
	end
    

end
function [u_llr] = polar_SCL_decode(llr, list_size)
            global PCparams;
            PCparams.list_size = list_size;
            
            initializeDataStructures();
            l_index = assignInitialPath();
            s_index = getArrayPointer_P(0, l_index);
            PCparams.llr_scl( (get_i_scl(0, 0, s_index) + 1) : (get_i_scl(0, PCparams.N - 1, s_index) + 1) ) = llr;
            
            for phi = 0 : PCparams.N - 1
                
                recursivelyCalcP_scl(PCparams.n, phi);
                
                if PCparams.FZlookup(phi + 1) == 0
                    continuePaths_FrozenBit(phi);
                else
                    continuePaths_UnfrozenBit(phi);
                end
                
                if mod(phi, 2) == 1
                    recursivelyUpdateC_scl(PCparams.n, phi);
                end
                
            end
            
            l_index = findMostProbablePath(1);
            c_m = getArrayPointer_C(PCparams.n, l_index);
            info = PCparams.i_scl(c_m+1,:);
            %u = info(PCparams.FZlookup == -1);
            %in order to make the function interface with the main
            %function, we let the hard decision of the info change to the
            %soft decision. note that this soft decision is not really the
            %true soft decision.
            u_llr = (1-2*info);
        end
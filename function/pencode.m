function y=pencode(u, F_kron_n) 


global PCparams;


x = PCparams.FZlookup;
if PCparams.crc_size ~=0
	crc = mod(PCparams.crc_matrix*u', 2)';
else
	crc = [];
end
u = [u crc];
x (x == -1) = u; % -1's will get replaced by message bits below
x = x(PCparams.bitreversedindices+1);
y = mod(x*F_kron_n,2);

end
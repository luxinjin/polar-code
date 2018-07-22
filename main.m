%polar encoder and SC, BP , SCAN decoder for awgn channel
%panzhipeng
clear; tic;
global PCparams;
addpath('function');


N = 256;
K = 128;
Rc = K/N;
Rm = 1;%BPSK
ebn0 = 1:0.5:3;
ebn0_num = 10.^(ebn0/10);
SNR = ebn0 + 10*log10(Rc*Rm) + 10*log10(2); %ÊµÊýÐÅºÅ+ 10*log10(2)
SNR_num = 10.^(SNR/10);

design_snr_dB = 0;%parameter for constucted polar code using BA construction method
sigma = 0.9;%parameter for constucted polar code using GA construction method

min_frame_errors = 10;%30
min_frame_num = 10000;
max_frame_num = 1e7;

construction_method = input('choose polar code construction method (need run the file in constructed fold firstly to constructed the code): 0---BhattaBound  1---GA\n');
decoding_method = input('choose the decoding method: 0---SC  1---BP  2---SCAN  3---SCL 4---SSC\n');

switch decoding_method
    case 0
        crc_size = 0;
        initPC(N,K,construction_method,design_snr_dB,sigma,crc_size);
        
    case 1
        bp_iter_num = input('input the iternum of the BP: at least 40 \n');
        crc_size = 0;
        initPC(N,K,construction_method,design_snr_dB,sigma,crc_size);
    case 2
        scan_iter_num = input('input the iternum of the SCAN: at least 1 \n');
        crc_size = 0;
        initPC(N,K,construction_method,design_snr_dB,sigma,crc_size);
    case 3
        scl_list_size = input('input the list size of the SCL: at least 1 \n');
        crc_size = input('input the crc size of the SCL: at least 0 \n');
        initPC(N,K,construction_method,design_snr_dB,sigma,crc_size);
    case 4
        crc_size = 0;
        initPC(N,K,construction_method,design_snr_dB,sigma,crc_size);
        [decoder_tree_initial, G_set, B_set] = intial_tree_G( );

    otherwise
        disp('invalid input!!!');
        bp_iter_num = 60;
        scan_iter_num = 8;
        scl_list_size = 4;
        crc_size = 0;
end



n = PCparams.n;
F = [1 0;1 1];
B=1;
for ii=1:n
    B = kron(B,F);
end
F_kron_n = B;

FER = zeros(1,length(ebn0));
BER = zeros(1,length(ebn0));
bpsk_FER=zeros(1,length(ebn0));       
bpsk_BER=zeros(1,length(ebn0));   

for j = 1:length(ebn0)
	fprintf('\n Now running:%f  [%d of %d] \n\t Iteration-Counter: %53d',ebn0(j),j,length(ebn0),0);
	tt=tic();
	for l = 1:max_frame_num
		
        de_bpsk = zeros(1,N);
        u=randi(2,1,K)-1; %Bernoulli(0.5);
		x=pencode(u,F_kron_n);
        tx_waveform=bpsk(x);
        rx_waveform=awgn(tx_waveform,SNR(j),'measured');
        de_bpsk(rx_waveform>0)=1;
        
        nfails = sum(de_bpsk ~= x);
        bpsk_FER(j) = bpsk_FER(j) + (nfails>0);
        bpsk_BER(j) = bpsk_BER(j) + nfails;
        
	
        initia_llr = -2*rx_waveform*SNR_num(j);
	
        switch decoding_method
            case 0
                [u_llr] = polar_SC_decode(initia_llr);
            case 1
                [u_llr,~] = polar_BP_decode(initia_llr,bp_iter_num);
            case 2
                [u_llr,~] = polar_SCAN_decode(initia_llr,scan_iter_num);
             case 3
                [u_llr] = polar_SCL_decode(initia_llr,scl_list_size);      
              case 4
                u_hard_decision = polar_SSC_decode(decoder_tree_initial, G_set, B_set, initia_llr);
                u_llr = 1-2*u_hard_decision;
        end
        if PCparams.crc_size
            uhat_crc_llr = u_llr(PCparams.FZlookup == -1)';
            uhat_llr = uhat_crc_llr (1:PCparams.K);
        else
            uhat_llr = u_llr(PCparams.FZlookup == -1)';
        end
		uhat = zeros(1,K);
        uhat(uhat_llr<0) =1;

		nfails = sum(uhat ~= u);
        FER(j) = FER(j) + (nfails>0);
        BER(j) = BER(j) + nfails;
		if mod(l,20)==0
            for iiiii=1:53
                fprintf('\b');
            end
            fprintf(' %7d   ---- %7d FEs, %7d BEs found so far',l,FER(j),BER(j));
        end
		if l>=min_frame_num && FER(j)>=min_frame_errors  %frame errors, sufficient to stop
            break;
        end
	end

        FER(j) = FER(j)/l;
        BER(j) = BER(j)/(K*l);
        
        bpsk_BER(j) = bpsk_BER(j)/(N*l);
        bpsk_FER(j) = bpsk_FER(j)/l;

        fprintf('\n\t Total time taken: %.2f sec (%d samples)',toc(tt),l);
end



semilogy(ebn0,BER,'bs-','LineWidth',1.5,'MarkerSize',6)
xlabel('Eb/No (dB)')
hold on;

semilogy(ebn0,FER,'gs:','LineWidth',1.5,'MarkerSize',6)
hold on;

semilogy(ebn0,bpsk_BER,'rv-','LineWidth',1.5,'MarkerSize',6)
hold on;

semilogy(ebn0,bpsk_FER,'rv:','LineWidth',1.5,'MarkerSize',6)


grid on;
legend('PC SCL-8-16 BER','PC SCL-8-16 FER','BPSK BER','BPSK FER');



toc


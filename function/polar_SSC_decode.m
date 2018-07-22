function u_hat = polar_SSC_decode(decoder_tree_initial, G, B, LLR)

%======================================
%============遍历树开始===================
global PCparams;
n=PCparams.n;
u_hat = zeros(1,2^(n+1)-1);%初始化译码比特

node_index = 1; %取第一个节点，即根节点
decoder_tree = decoder_tree_initial;
decoder_tree{node_index}{2} = LLR; %初始化根节点的LLR
while decoder_tree{1}{7}~=2
    
    if decoder_tree{node_index}{7} == 0  && decoder_tree{node_index}{4} ~=-1 %节点未激活，且不是叶节点
        %1. 计算左子节点的LLR，节点状态=1
        node_llr = decoder_tree{node_index}{2};
        left_node_llr = fFunction( node_llr(1:2:end), node_llr(2:2:end) );
        decoder_tree{node_index}{7} = 1;
        %2. 并取左子节点
        node_index = decoder_tree{node_index}{4};
        decoder_tree{node_index}{2} =  left_node_llr;
        
        continue;
    elseif decoder_tree{node_index}{7} == 0  && decoder_tree{node_index}{4} ==-1 %节点未激活，但是叶节点(叶节点只能是0节点或者1节点)
        % 计算节点的B，节点状态=2
        
        %判断节点类型，计算信息比特；
        layer = floor( log2(node_index) ); %该节点位于哪一层
        layer_num = 2^(n-layer);                 %该层对应L和B的维度
        if decoder_tree{node_index}{1} == 0 %节点类型为0节点
            decoder_tree{node_index}{3} = zeros( 1, layer_num );  
        elseif decoder_tree{node_index}{1} == 1 %节点类型为1节点
            decoder_tree{node_index}{3} = ( decoder_tree{node_index}{2}<0 );
            u_temp = decoder_tree{node_index}{3};
            u_temp = u_temp( B{layer+1}+1 );

            u_hat( node_index*layer_num:(node_index+1)*layer_num-1 ) = mod( u_temp*G{layer+1}, 2 );
          end
        decoder_tree{node_index}{7} = 2;
        % 取父节点
        node_index = decoder_tree{node_index}{6};
        continue;
   
    elseif decoder_tree{node_index}{7} == 1  && decoder_tree{ decoder_tree{node_index}{5} }{7} ==0 %节点激活过一次(肯定不是叶节点），并且右子节点未激活过
        %计算右子节点L
        right_node_index = decoder_tree{node_index}{5};
        left_node_index = decoder_tree{node_index}{4};
        node_llr = decoder_tree{node_index}{2};
        right_node_llr =  node_llr(1:2:end).*( 1-2* decoder_tree{left_node_index}{3} ) + node_llr(2:2:end);
        decoder_tree{right_node_index}{2} = right_node_llr;
        %取右子节点
         node_index =  right_node_index;
         continue;
    elseif decoder_tree{node_index}{7} == 1 && decoder_tree{ decoder_tree{node_index}{5} }{7} ==2 %节点激活过一次(肯定不是叶节点），并且右子节点激活过两次
        %计算该节点的B, 节点状态=2；
        right_node_index = decoder_tree{node_index}{5};
        left_node_index = decoder_tree{node_index}{4};
        
        decoder_tree{node_index}{3}(1:2:end) = xor( decoder_tree{left_node_index}{3}, decoder_tree{right_node_index}{3} );
        decoder_tree{node_index}{3}(2:2:end) = decoder_tree{right_node_index}{3};
        decoder_tree{node_index}{7} = 2;
        %取父节点
        node_index = decoder_tree{node_index}{6};
         continue;
 
    end 
end
        
     u_hat = u_hat(2^n:end);

end
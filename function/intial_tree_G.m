function [decoder_tree_initial, G, B] = intial_tree_G( )
%函数用于生成译码树结构，以及SSC译码时将用到的G矩阵，和B_N矩阵
%函数在确定采用SSC译码器时调用；
%=============初始化树=================
global PCparams;
n=PCparams.n;
FZlookup = PCparams.FZlookup;
node = cell(1,7);
%node{1} = node_type；节点类型，表示0节点1节点及混合节点，分别用0 1 -1表示
%node{2} = L; 数组，表示L数组
%node{3} = B; 数组，表示B数组
%node{4} = left_node; int型，存放节点索引
%node{5} = right_node; int型，存放节点索引
%node{6} = parent_node; int型，存放节点索引
%node{7} = state ;
%int型，表示当前节点的激活状态，0表示向左走，在1的情况下，判断所有子节点是否为2，若是，则向上走，若不是，向右走， 2表示向上走
%没有父节点或者子节点用-1表示
node_type = -1;
node_num = 2^(n+1)-1;
decoder_tree_initial = cell(1,node_num);
for layer_index = n:-1:0
    for node_index = 2^layer_index:2^(layer_index+1)-1
        if layer_index == n
            node = { -FZlookup(node_index-2^layer_index+1), zeros(1,2^(n-layer_index)), zeros(1,2^(n-layer_index)), -1, -1, floor(node_index/2),0 };   
        elseif layer_index == 0
            if decoder_tree_initial{node_index*2}{1}==0 && decoder_tree_initial{node_index*2+1}{1}==0
                node_type = 0;
            elseif decoder_tree_initial{node_index*2}{1}==1 && decoder_tree_initial{node_index*2+1}{1}==1
                node_type = 1;
            else
                node_type = -1;
            end
             node = {node_type, zeros(1,2^(n-layer_index)), zeros(1,2^(n-layer_index)), node_index*2, node_index*2+1, -1, 0};
        else
            %判断左右子节点是否都是0节点或者是否都是1节点
            if decoder_tree_initial{node_index*2}{1}==0 && decoder_tree_initial{node_index*2+1}{1}==0
                node_type = 0;
            elseif decoder_tree_initial{node_index*2}{1}==1 && decoder_tree_initial{node_index*2+1}{1}==1
                node_type = 1;
            else
                node_type = -1;
            end
            node = {node_type, zeros(1,2^(n-layer_index)), zeros(1,2^(n-layer_index)), node_index*2, node_index*2+1, floor(node_index/2),0};       
        end
        decoder_tree_initial{node_index} = node;
    end
end

%=============初始化树完毕=================

%=============精简树开始==================
%经验证算法复杂度减少( 300.64 -  74.57 )/300.64 = 75.2%
%算法步骤：
%从根节点开始，遍历节点，判断类型，如果节点为0节点或者为1节点，则置节点为叶节点
%相当于把树枝砍断
for ii = 1:node_num
    if decoder_tree_initial{ii}{1} == 0 || decoder_tree_initial{ii}{1} == 1
        decoder_tree_initial{ii}{4} = -1;
        decoder_tree_initial{ii}{5} = -1;
    end
end

%=============精简树完毕==================

%============预存G_n~G_1=================
%G{1}表示layer=0-->G{n}表示layer=n-1 G{n+1}表示layer = n
%预存bitreversedindices B{1}表示layer=0的bitreversedindices-->B{n}表示layer=n-1
F = [1 0; 1 1];
GG = 1;
G = cell(1,n+1);
B = cell(1,n+1);
for ii = 1:n
    GG =kron(GG,F);
    bitreversedindices = zeros(1,2^ii);
    for index = 1 : 2^ii
        bitreversedindices(index) = bin2dec(wrev(dec2bin(index-1,ii)));
    end
    B{n-ii+1} = bitreversedindices;
    G{n-ii+1} = GG;
end
G{n+1} =1;
B{n+1} = 0;
end
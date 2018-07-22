# Matlab simulation for polar codes

***本程序只供学习交流使用，请勿用于商业目的。***

***注：本程序代码包含了 SC SCL BP SCAN和SSC译码算法***

## 程序说明

1. polar码基本原理v1.docx叙述了polar码的基本原理

1. 本程序给出一个主函数示例main,用户输入选择译码算法，以及译码参数
常用参数：
    - N: 码长，需为2的幂次   
    - K: 信息位长度
    - 码字构造参数: 
        - design SNR: BA 构造方法的参数值
        - sigma: GA构造方法的初始值
    - SC译码时无参数
    - SCL译码时要求输入List大小和CRC校验位数
    - BP译码时要求输入迭代次数，一般为40；
    - SCAN译码要求输入迭代次数，一般为1-4；
    - SCL的CRC校验生成用了随机校验矩阵的方法，实验结果显示与标准CRC校验性能一致
    - SSC算法为SC算法的简化算法，速度提升明显



2. initPC是polar码初始化程序，主要构建Polar的数据结构，包括了：
    - N: 码长
    - K: 信息位长(code rate $R = \frac{K}{N}$)
    - n: $\log_2(N)$
    - FZlookup: $N$长向量，为0表示为frozen bits位置，为-1表示信息比特位置
    - L: 用于存储运算过程中的左信息值（算法中的L矩阵）
    - B: 用于存储运算过程中的右信息值（算法中的B矩阵）
    - bitreversedindices: 等效于$G= B\times F^{\otimes n}$中的$B$
    - 其中FZlookup是Frozen Bits的位置构造的码字针对的是$G= B\times F^{\otimes n}$生成矩阵，而非$G= F^{\otimes n}$ (这两种形式都很常用，但一定要弄清楚)

    **注意这里没有考虑memory简化，因此大小都为$N\times(n+1)$**


3. pencode是编码程序。引入crc校验时，需要将crc校验信息当成是信息的一部分进行编码

4. polar_SC_decode是SC译码算法

5. polar_BP_decode是BP译码算法 

6. polar_SCAN_decode是SCAN译码算法

7. polar_SCL_decode是SCL译码算法

8. polar_SSC_decode是SC算法的简化算法

9. 所有的译码程序的迭代因子图都如下图所示。
![image](https://github.com/ZhipengPan/polar-code/blob/master/polar-factor.jpg)

10. constructedCode文件夹下的construct_polar_code_GA函数为高斯近似polar码构造方法，construct_polar_code_Ba为巴氏参数界构造方法。

## 仿真结果：
仿真结果位于result文件夹中
![image](https://github.com/ZhipengPan/polar-code/blob/master/result/result_256_128.png)

## 参考文献

[1]	Arikan E. Channel Polarization: A Method for Constructing Capacity-Achieving Codes for Symmetric Binary-Input Memoryless Channels[J]. IEEE Transactions on Information Theory, 2009, 55(7):3051-3073.

[2]	Massey J L. Capacity, Cutoff Rate, and Coding for a Direct-Detection Optical Channel[J]. IEEE Transactions on Communications, 1981, 29(11):1615-1621.

[3]	Hassani S H, Urbanke R. On the scaling of polar codes: I. The behavior of polarized channels[C]// IEEE International Symposium on Information Theory Proceedings. IEEE, 2010:874-878.

[4]	Mori R, Tanaka T. Performance of polar codes with the construction using density evolution[J]. IEEE Communications Letters, 2009, 13(7):519-521.

[5]	Tal I, Vardy A. How to Construct Polar Codes[J]. IEEE Transactions on Information Theory, 2013, 59(10):6562-6582.

[6]	Trifonov P. Efficient Design and Decoding of Polar Codes[J]. IEEE Transactions on Communications, 2012, 60(11):3221-3227.

[7]	Vangala H, Viterbo E, Hong Y. A Comparative Study of Polar Code Constructions for the AWGN Channel[J]. Mathematics, 2015.

[8]	Sun S, Zhang Z. Designing Practical Polar Codes Using Simulation-Based Bit Selection[J]. IEEE Journal on Emerging & Selected Topics in Circuits & Systems, 2017, PP(99):1-1.

[9]	Korada S B, Şaşoǧlu E, Urbanke R. Polar Codes: Characterization of Exponent, Bounds, and Constructions[J]. Information Theory IEEE Transactions on, 2010, 56(12):6253-6264.

[10]	Tal I, Vardy A. List Decoding of Polar Codes[J]. IEEE Transactions on Information Theory, 2015, 61(5):2213-2226.

[11]	Balatsoukas-Stimming A, Parizi M B, Burg A. LLR-Based Successive Cancellation List Decoding of Polar Codes[J]. IEEE Transactions on Signal Processing, 2015, 63(19):5165-5179.

[12]	Niu K, Chen K. CRC-Aided Decoding of Polar Codes[J]. IEEE Communications Letters, 2012, 16(10):1668-1671.

[13]	Li B, Shen H, Tse D. An Adaptive Successive Cancellation List Decoder for Polar Codes with Cyclic Redundancy Check[J]. IEEE Communications Letters, 2012, 16(12):2044-2047.

[14]	Niu K, Chen K. Stack decoding of polar codes[J]. Electronics Letters, 2012, 48(12):695-697.

[15]	Fayyaz U U, Barry J R. Polar codes for partial response channels[C]// IEEE International Conference on Communications. IEEE, 2013:4337-4341.

[16]	Fayyaz U U, Barry J R. Low-Complexity Soft-Output Decoding of Polar Codes[J]. IEEE Journal on Selected Areas in Communications, 2014, 32(5):958-966.

[17]	Arikan E. A performance comparison of polar codes and Reed-Muller codes[J]. Communications Letters IEEE, 2008, 12(6):447-449.


## 联系作者
潘志鹏

湖南，长沙

邮件：zhipengpan10@163.com panzhipeng10@nudt.edu.cn


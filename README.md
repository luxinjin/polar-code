# polar-code

本程序只供学习交流使用，请勿用于商业目的。


1. 本程序给出一个主函数示例main,用户输入选择译码算法，以及译码参数
常用参数：
N:码长，需为2的幂次   K信息位长度
SC译码时无参数
BP译码时，迭代次数为60；
SCAN译码，迭代次数为1-8；
SCL译码时，listsize为1-4， crcsize为0,8,16等 CRC check用了随机校验矩阵的方法 实验结果显示与标准CRC校验带来的性能提升一致
SSC算法为SC算法的简化算法，速度快了许多
注：由于版权原因 本程序代码只公布了 SC SCL 和SSC算法，如有需要BP和SCAN算法的请私信底部邮件


2.initPC是polar码初始化程序，主要构建Polar的数据结构，包括了N，K，n，FZlookup，L，B，bitreversedindices。其中FZlookup是Frozen Bits的位置

构造的码字针对的是G= B*F^(kron n)（尤其注意和G= F^(kron n)的区别） L是llr，B是Bit位置（注意这里没有考虑memory简化，因此大小都为N*（n+1））；
bitreversedindices是bit翻转对应的位置

3.pencode是编码程序
引入crc校验时，需要将crc校验信息当成是信息的一部分进行编码

4.polar_SC_decode是SC译码算法

5.polar_BP_decode是BP译码算法

6.polar_SCAN_decode是SCAN译码算法

7.polar_SCL_decode是SCL译码算法

8.polar_SSC_decode是SC算法的简化算法

9.所有的译码程序的迭代因子图都为图1所示。

10.constructedCode文件夹下的construct_polar_code_GA函数为高斯近似polar码构造方法，construct_polar_code_Ba为巴士参数界构造方法。
construct_polar_code_MC为蒙特卡洛构造方法（目前有问题。）。

潘志鹏
湖南，长沙
邮件：zhipengpan10@163.com panzhipeng10@nudt.edu.cn
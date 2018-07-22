# polar-code

***本程序只供学习交流使用，请勿用于商业目的。***

***注：由于版权原因 本程序代码只公布了 SC SCL 和SSC算法，如有需要BP和SCAN算法的请私信底部邮件***

## 程序说明
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
    - 



2. initPC是polar码初始化程序，主要构建Polar的数据结构，包括了：
    - N: 码长
    - K: 信息位长(code rate $R = \frac{K}{N}$)
    - n: $\log_2(N)$
    - FZlookup: `$N$`长向量，为0表示为frozen bits位置，为-1表示信息比特位置
    - L: 用于存储运算过程中的左信息值（算法中的L矩阵）
    - B: 用于存储运算过程中的右信息值（算法中的B矩阵）
    - bitreversedindices: 等效于`$G= B\times F^{\otimes n}$`中的`$B$`
    - 其中FZlookup是Frozen Bits的位置构造的码字针对的是`$G= B\times F^{\otimes n}$`生成矩阵，而非`$G= F^{\otimes n}$` (这两种形式都很常用，但一定要弄清楚)
    
    **注意这里没有考虑memory简化，因此大小都为`$N\times(n+1)$`**


3. pencode是编码程序。引入crc校验时，需要将crc校验信息当成是信息的一部分进行编码

4. polar_SC_decode是SC译码算法

5. polar_BP_decode是BP译码算法 (如有需要，请邮件)

6. polar_SCAN_decode是SCAN译码算法 (如有需要，请邮件)

7. polar_SCL_decode是SCL译码算法

8. polar_SSC_decode是SC算法的简化算法

9. 所有的译码程序的迭代因子图都如下图所示。
![image](E:/YoudaoLocalFile/zhipengpan10@163.com/figure/polar-factor.jpg)

10. constructedCode文件夹下的construct_polar_code_GA函数为高斯近似polar码构造方法，construct_polar_code_Ba为巴氏参数界构造方法。

#### 仿真结果：
仿真结果位于***result***文件夹中
![image](E:/YoudaoLocalFile/zhipengpan10@163.com/figure/result_256_128.png)

## 联系作者
潘志鹏

湖南，长沙

邮件：zhipengpan10@163.com panzhipeng10@nudt.edu.cn
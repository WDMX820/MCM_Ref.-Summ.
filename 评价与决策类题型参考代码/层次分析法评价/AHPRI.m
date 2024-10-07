%function RI=AHPRI(n)
%利用MATLAB求随机一致性指标;
i=0;CI=0;A=zeros(n);
while i<1000   %循环1000次
    for l=1:n   %构造的正互反矩阵对角元素为1
        A(l,l)=1;
    end
    for j=1:n-1    %设置正互反矩阵中其余元素的随机性
        for k=j+1:n
            a=randint(1,1,[2,9]);
            x=rand(1);    %根据rand函数取随机数按照正态分布
            if x<6/17     %从而构造if语句进行相关元素的赋值
                A(j,k)=a;
            elseif 6/17<=x<6.5/17
                A(j,k)=1;
            else
                A(j,k)=1/a;
            end
            A(k,j)=1/A(j,k);  %将A矩阵中对称位置的元素取倒数
        end
    end
    [V,D]=eig(A);       %求A矩阵的特征值
    x=max(max(D));      %求最大特征值
    ci=(x-n)/n-1;       %求A矩阵对应的一致性指标
    CI=CI+ci;
    i=i+1;
end
RI=CI/1000;  %求随机一致性指标
%程序运行的结果：RI = 1.5646207273616

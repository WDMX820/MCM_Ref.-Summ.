


clc
clear
close all

%--------------------------------------------------------------------------
% 产生混沌序列
% dx/dt = sigma*(y-x)
% dy/dt = r*x - y - x*z
% dz/dt = -b*z + x*y

sigma = 16;             % Lorenz 方程参数 a
b = 4;                  %                 b
r = 45.92;              %                 c            

y = [-1,0,1];           % 起始点 (1 x 3 的行向量)
h = 0.01;               % 积分时间步长

k1 = 30000;             % 前面的迭代点数
k2 = 5000;              % 后面的迭代点数 (总样本数)

Z = LorenzData(y,h,k1+k2,sigma,r,b);
X = Z(k1+1:end,1);
X = normalize_1(X);     % 归一化到均值为0，方差1

%--------------------------------------------------------------------------
% 相关参数

t = 5;                  % 时延
d = 4;                  % 嵌入维数
n_tr = 1000;            % 训练样本数
n_te = 1000;            % 测试样本数

%--------------------------------------------------------------------------
% 相空间重构

X = X(1:n_tr+n_te);

[XN_TR,DN_TR] = PhaSpaRecon(X(1:n_tr),t,d);
[XN_TE,DN_TE] = PhaSpaRecon(X(n_tr+1:n_tr+n_te),t,d);

%--------------------------------------------------------------------------
% 训练

P = XN_TR;
T = DN_TR;
spread = 1;         % 此值越大,覆盖的函数值就大(默认为1)
net = newrbe(XN_TR,DN_TR);
ERR1 = sim(net,XN_TR)-DN_TR;
err_mse1 = sqrt(sum(ERR1.^2)/length(ERR1))            

%--------------------------------------------------------------------------
% 多步预测

n_pr = 300;

X_ST = X(n_tr-(d-1)*t:n_tr);
DN_PR = zeros(n_pr,1);
for i=1:n_pr
    XN_ST = PhaSpaRecon(X_ST,t,d);
    DN_PR(i) = sim(net,XN_ST);
    X_ST = [X_ST(2:end);DN_PR(i)];
end
DN_TE = X(n_tr+1:n_tr+n_pr);

%--------------------------------------------------------------------------
% 作图

figure;
subplot(211)
plot(n_tr+1:n_tr+n_pr,DN_TE,'r+-',...
     n_tr+1:n_tr+n_pr,DN_PR,'b-');
title('真实值(+)与预测值(.)')
subplot(212)
plot(n_tr+1:n_tr+n_pr,DN_TE-DN_PR,'k'); grid;
title('预测绝对误差')


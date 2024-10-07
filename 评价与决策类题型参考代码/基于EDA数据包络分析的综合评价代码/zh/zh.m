%function y=zhangyong(x0)
clear
clc
format long g
x0=[2804.5	2924	2991	3301	3508];
n=size(x0,2);
for i=1:n
    x1(i)=sum(x0(1:i));
end
YN=x0(2:n)';
B=[-0.5.*(x1(1:n-1)+x1(2:n)).' ones(n-1,1)];
cap_a=inv(B'*B)*B'*YN;
a=cap_a(1);b=cap_a(2);
cap_x1(1)=x0(1);
for k=1:n-1
    cap_x1(k+1)=(x0(1)-b/a)*exp(-1*a*k)+b/a;
end
cap_x0(1)=cap_x1(1);
for k=1:n-1
    cap_x0(k+1)=cap_x1(k+1)-cap_x1(k);
end
a 
b
y=cap_x0
c1=x0(1)-b/a
c2=b/a
s=30;
error=cap_x0-x0;
error_mean=mean(error);
error_cov=sqrt(cov(error)/n);
origin_cov=sqrt(cov(x0)/n);
C=error_cov/origin_cov
P=sum((error-error_mean)<0.6745*origin_cov)/n
model_x0(1)=x0(1);
model_x1(1)=x0(1);
for t=1:s
    model_x1(t+1)=c1*exp(-1*a*t)+c2;
    model_x0(t+1)=model_x1(t+1)-model_x1(t);
end
model_x0


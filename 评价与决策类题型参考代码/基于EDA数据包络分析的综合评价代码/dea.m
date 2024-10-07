n=size(x',1);m=size(x,1);s=size(y,1); epsilon=10^-10; f=[zeros(1,n) -epsilon*ones(1,m+s) 1]; a=[zeros(1,n+m+s+1)] ;b=[0]; lb=zeros(n+m+s+1,1) ;ub=[];lb(n+m+s+1)=-inf;
for i=1:n;aeq=[x eye(m)  zeros(m,s)  -x(:,i);y zeros(s,m)  -eye(s) zeros(s,1)];beq=[zeros(m,1);y(:,i)];w(:,i)=linprog(f,a,b,aeq,beq,lb,ub);end
w
lambda=w(1:n,:)
theta=w(n+m+s+1,:)
s_minus=w(n+1:n+m,:)
s_plus=w(n+m+1:n+m+s,:)
clear


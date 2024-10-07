function [ SolVecs ] = CCA_zq ( X , M ,ClassNum )
%X        ---ѵ����������������������������ÿ������������������������������������ά����С������β������
%M        ---�洢������������ά��������(������)
%ClassNum ---�����
%SolVecs  ---��õĽ��ƽ�����
%Author   ---½��ꡢ��ǿ������������½���ʦ����������ֱ�ӽ�ȡ������ã� �Ͼ�����ѧ603������ moxibingdao@qq.com

% %����Ϊ��ӸĶ�����
pcafeature=X(1:M(1),:);
TrainImage1=pcafeature;
otherfeature=X(1+M(1):M(1)+M(2),:);
TrainImage2=otherfeature;
cn=ClassNum;
train_NUM=size(X,2)/ClassNum;
N=(train_NUM)*cn;
vec_dim1=M(1);
vec_dim2=M(2);
% %����Ϊ��ӸĶ�����

disp('����Sxx...');
%��Swx
Sxx = zeros(vec_dim1,vec_dim1);
I = eye(vec_dim1);
for i =1:cn
    within_xx = zeros(vec_dim1,vec_dim1);
%    temp = TrainImage1(:,(i-1)*train_NUM + 1:i*train_NUM );
    for j=1:train_NUM
%         x = TrainImage1(:,(i-1)*train_NUM + j) - mean2(TrainImage1(:,(i-1)*train_NUM + 1:i*train_NUM ));
        x = TrainImage1(:,(i-1)*train_NUM + j) - mean(TrainImage1,2);%mean(temp,2);
        within_xx = within_xx + x*x';
    end;
    Sxx = Sxx + within_xx;
end;
Sxx = Sxx ;


disp('����Syy...');
%��Syy
Syy = zeros(vec_dim2,vec_dim2);
I = eye(vec_dim2);
for i =1:cn
    within_yy =  zeros(vec_dim2,vec_dim2);
%     temp = TrainImage2(:,(i-1)*train_NUM + 1:i*train_NUM );
    for j=1:train_NUM
        y = TrainImage2(:,(i-1)*train_NUM + j) - mean(TrainImage2,2);% mean(temp,2);
        within_yy = within_yy + y*y';
    end;
    Syy = Syy + within_yy;
end;
Syy = Syy;

disp('����Lxy...');
%��Lxy
Lxy =  zeros(vec_dim1,vec_dim2);
for i=1:size(TrainImage1,2)
        x = TrainImage1(:,i) - mean(TrainImage1,2);
        y = TrainImage2(:,i) - mean(TrainImage2,2);
%         xclass = ceil(i/train_NUM);%���ͼ�ǵڼ���
%         yclass = ceil(i/train_NUM);
%         x = TrainImage1(:,i) - mean(TrainImage1(:,(xclass-1)*train_NUM+1:xclass*train_NUM),2);
%         y = TrainImage2(:,i) - mean(TrainImage2(:,(yclass-1)*train_NUM+1:yclass*train_NUM),2);
        Lxy = Lxy + x*y';
end;
Lxy = Lxy;
Lyx = Lxy';
disp('Lxy���ȣ�');
dxy = rank(Lxy)

%%%CVs
A = inv(Sxx)*Lxy*inv(Syy)*Lyx;


A=A+0.0000001*(eye(size(A)));;%��ֹ����
[Vec1,lamda1] = eig(A);
% if rank(A)==size(A,1)
% [Vec1,lamda1] = eig(A);
% else
%     A=A+eye(size(A,1))*0.000001;
% end;
B = inv(Syy)*Lyx*inv(Sxx)*Lxy;
%B=B+0.1*eye(size(B));;
[Vec2,lamda2] = eig(B);
% if rank(B)==size(B,1)
% [Vec2,lamda2] = eig(B);
% else
%     B=B+eye(size(B,1))*0.000001;
% end;
% [Vec2,lamda2] = eig(B);
%sort the vectors
lamda1 = diag(lamda1);
[lamda1 ,pos1]=sort(lamda1,'descend'); 
lamda2 = diag(lamda2);
[lamda2 ,pos2]=sort(lamda2,'descend'); 
%���������̹�һ��
for i=1:length(pos1)
    temp1= Vec1(:,pos1(i));
   CVx(:,i) = temp1;
%       CVx(:,i) = temp/sqrt(temp'*Sxx*temp);
    temp2 = Vec2(:,pos2(i));
   CVy(:,i) = temp2;
%       CVy(:,i) = temp/sqrt(temp'*Syy*temp);
end;
alfa=CVx;
beta=CVy;
SolVecs=[ alfa
          beta ];
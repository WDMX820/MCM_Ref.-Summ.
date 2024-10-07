function [ SolVecs ] = GCCA_zq ( X , M ,ClassNum )
%X        ---ѵ����������������������������ÿ������������������������������������ά����С������β������
%M        ---�洢������������ά��������(������)
%ClassNum ---�����
%SolVecs  ---��õĽ��ƽ�����
%Author   ---½��ꡢ��ǿ������������½���ʦ����������ֱ�ӽ�ȡ������ã� �Ͼ�����ѧ603������ moxibingdao@qq.com

% %����Ϊ��ӸĶ�����
cn=ClassNum;
train_NUM=size(X,2)/ClassNum;
N=(train_NUM)*cn;
TrainImage1=X(1:M(1),:);
TrainImage2=X(1+M(1):M(2)+M(1),:);
vec_dim1=M(1);
vec_dim2=M(2);
% %����Ϊ��ӸĶ�����

% %����Ϊ½���ʦ�����ĸ�������ļ���GCCA��һ����
% %������ɢ������
for i= 1:cn
    mean1_in(:,i)=mean(TrainImage1(:,(i-1)*train_NUM+1:i*train_NUM),2);
    mean2_in(:,i)=mean(TrainImage2(:,(i-1)*train_NUM+1:i*train_NUM),2);    
end
Swx=zeros(vec_dim1,vec_dim1);
Swy=zeros(vec_dim2,vec_dim2);
for i=1:cn
    for j=1:train_NUM
        temp1(:,j)=TrainImage1(:,(i-1)*train_NUM+j)-mean1_in(:,i);
        temp2(:,j)=TrainImage2(:,(i-1)*train_NUM+j)-mean2_in(:,i);
    end
    Swx=Swx+temp1*temp1';
    Swy=Swy+temp2*temp2';
end


disp('����Lxy...');
%��Lxy
Lxy =  zeros(vec_dim1,vec_dim2);
for i=1:size(TrainImage1,2)
        x = TrainImage1(:,i) - mean(TrainImage1,2);
        y = TrainImage2(:,i) - mean(TrainImage2,2);
        Lxy = Lxy + x*y';
end;
Lxy = Lxy;
Lyx = Lxy';
disp('Lxy���ȣ�');
dxy = rank(Lxy)

%%%CVs
A = inv(Swx)*Lxy*inv(Swy)*Lyx;
[Vec1,lamda1] = eig(A);
B = inv(Swy)*Lyx*inv(Swx)*Lxy;
[Vec2,lamda2] = eig(B);
%sort the vectors
lamda1 = diag(lamda1);
[lamda1 ,pos1]=sort(lamda1,'descend'); 
lamda2 = diag(lamda2);
[lamda2 ,pos2]=sort(lamda2,'descend'); 
mm=min(length(pos1),length(pos2));
%���������̹�һ��
for i=1:mm
    temp= Vec1(:,pos1(i));
    CVx(:,i) = temp;
    temp = Vec2(:,pos1(i));
    CVy(:,i) = temp;
end;
alfa=CVx;
beta=CVy;
% %����Ϊ½���ʦ�����ĸ�������ļ���DCCA��һ����
SolVecs=[ alfa' beta' ]';
%  ģ���ۺ����۷������Ը�Ӫ��������Ϊ���������������ָ�꣺COD TP TN Chla sd��Ŀǰ����˸�վλ��for 1��8��
%  ����������վλ���ı�8����,��������
function B=Fassess(A)
cod=A(:,1);
tp=A(:,2);
tn=A(:,3);
chla=A(:,4);
sd=A(:,5);
%���ָ�������ȼ���ƶ1����2����3����15����������
ycod2=trimf(cod,[2 3 4]);
ytp2=trimf(tp,[0.015 0.03 0.045]);
ytn2=trimf(tn,[0.2 0.4 0.6]);
ychla2=trimf(chla,[2 10 20]);
ysd2=trimf(sd,[0.5 1 1.5]);
ycod1=trapmf(cod,[0 0 2 3]);
ytp1=trapmf(tp,[0 0 0.015 0.03]);
ytn1=trapmf(tn,[0 0 0.2 0.4]);
ychla1=trapmf(chla,[0 0 2 10]);
ysd1=trapmf(sd,[1 1.5 10 10]);
ycod3=trapmf(cod,[3 4 10 10]);
ytp3=trapmf(tp,[0.03 0.045 10 10]);
ytn3=trapmf(tn,[0.4 0.6 10 10]);
ychla3=trapmf(chla,[10 20 100 100]);
ysd3=trapmf(sd,[0 0 0.5 1]);

%���ָ���Ȩ��,��ȡˮ�ʱ�׼������Ȩ�أ��ȼ����������Ӹ�����׼�ٹ�һ����ע��sd������ָ�����졣
S=[3.00,0.03,0.40,10,1.00];
for i=1:8
    for j=1:4
        if A(i,j)<=S(j)
           W(i,j)=1;
        elseif A(i,j)>S(j)
           W(i,j)=A(i,j)/S(j);
         end
     if A(i,5)>=S(5)
        W(i,5)=1;
     elseif (A(i,5)<S(5))
            W(i,5)=S(5)/A(i,5);
      end
    end
TEMP(i,:)=W(i,1)+W(i,2)+W(i,3)+W(i,4)+W(i,5);
      for j=1:5
          W(i,j)=W(i,j)/TEMP(i,:);
      end
end
                            
%����
for i=1:8
C(i,:)=W(i,:)*[ycod1(i) ycod2(i) ycod3(i);
    ytp1(i) ytp2(i) ytp3(i);
    ytn1(i) ytn2(i) ytn3(i);
    ychla1(i) ychla2(i) ychla3(i);
    ysd1(i) ysd2(i) ysd3(i)];
end
% ���ü�Ȩƽ��ԭ���ģ�����۽�����з���
for i=1:8
    B(i)=(C(i,1)^2+C(i,2)^2*2+C(i,3)^2*3)/(C(i,1)^2+C(i,2)^2+C(i,3)^2);
end    
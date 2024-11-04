%% �����ɱ�-Ч�������ֵ���

clear,clc,close all


N0=3300;
% E_unit=1e-5;%���������� ��kWh
% Esw_data=load('Esw_data.txt');
% �����ֵ��ֵ��
NPV1_data=load('NPV1_points.txt');
NPV1x=NPV1_data(:,1);
NPV1y=NPV1_data(:,2);
NPV1m=max(max(NPV1y));
[row_1,cell_1]=find(NPV1y==max(max(NPV1m)));
% % ���ֵ��ֵ��
% NPV2_data=load('NPV2_points.txt');
% NPV2x=NPV2_data(:,1);
% NPV2y=NPV2_data(:,2);
% NPV2m=max(max(NPV2y));
% [row_2,cell_2]=find(NPV2y==max(max(NPV2m)));

Esw=23.0065;%��kWh

% ����-������ϵ��
ExpandHP=load('��������������.txt');
a1=ExpandHP(1,1);
b1=ExpandHP(1,2);
c1=ExpandHP(1,3);
d1=ExpandHP(1,4);
% ����-������ϵ��
a2=0;
b2=-6.7858325e-5;
c2=0.41;


% �ɱ�Ч��������׵����
% ����
r=0.1; %������
% Bf0=0.65; %��ۣ�Ԫ/kwh��
Bf0=0.6; %��ۣ�Ԫ/kwh��
% Com0=0.006; %�굥λ���з� ��Ԫ/kwh��
Com0=0.006; %�굥λ���з� ��Ԫ/kwh��
% Cin0=865.273; %��λͶ�� ����Ԫ/MW��
% unit=10000; %��Ԫ/��kwh
unitc=0.00001; %ʮ��Ԫ/MW
unit=0.1; %ʮ��Ԫ/��kwh
Bf=Bf0*unit; %��ۣ�Ԫ/kwh��
Com=Com0*unit; %�굥λ���з� ��Ԫ/kwh��
Cin=865.273*unitc; %��λͶ�� ����Ԫ/MW��
% Cin=500.273*unitc; %��λͶ�� ����Ԫ/MW��
m0=50;

% �ɱ�Ч�����ϵ��
A=(Bf-Com)*a1;
B=(Bf-Com)*b1-Bf*a2*Esw;
C=(Bf-Com)*c1-Bf*b2*Esw;

npv_2=ones(m0,3);
for i=1:m0
    npv_2(i,1)=3*A/((1+r)^i);
    npv_2(i,2)=2*B/((1+r)^i);
    npv_2(i,3)=C/((1+r)^i);
end
    npv1=sum(npv_2);
    npv2=npv1(:,3)-Cin;
    NPV_2=[npv1(:,1:2),npv2];
    X=roots(NPV_2);
    Xm=X(2);
%% NPV����
npv=ones(m0,3);
for i=1:m0
    npv(i,1)=A/((1+r)^i);
    npv(i,2)=B/((1+r)^i);
    npv(i,3)=C/((1+r)^i);
end
    NPV1=sum(npv);
    NPV2=NPV1(:,3)-Cin;
    NPV=[NPV1(:,1:2),NPV2];
 save('NPV-analytical.txt','NPV','-ascii');
%% ��ͼ
% ���κ���

k1=NPV_2(1,1);
m1=NPV_2(1,2);
n1=NPV_2(1,3);
x1=0:1:10000;
y1=k1*x1.^2+x1.*m1+n1;
Y1=k1* Xm^2+ Xm*m1+n1;
xx2=round(Xm,-2);
yy2=round(Y1,-2);
yyy2=yy2+0.0005;
[rowx1,cellx1]=size(x1);
liney=zeros(rowx1,cellx1);
figure
plot(x1,y1,'black-','LineWidth', 1);
hold on
plot(x1,liney,'black--','LineWidth', 1);
hold on
plot(Xm,Y1,'r-s','markersize',6,'MarkerFaceColor','r');
text(1380,yyy2,['(',num2str(xx2),',',num2str(yy2),')'],'color','b');
xlabel('Hydropower expansion (MW)');
ylabel('');
legend('Fitted curve','','Optimal size');

% NPV���κ���
k2=NPV(1,1);
m2=NPV(1,2);
n2=NPV(1,3);
x2=0:1:3000;
y2=k2*x2.^3+x2.^2*m2+x2.*n2;
Y2=k2* Xm^3+ Xm^2*m2+ Xm*n2;
T2=y2(1:10:end);
T22=T2';
R2=corrcoef(T2',NPV1y);
error=T2'-NPV1y;
xx1=round(Xm,-2);
yy1=round(Y2,-2);
yyy1=yy1-0.3;
yyy2=yy1+0.7;
yyy3=yy1-12;
save('analyticalNPV_points.txt','T22','-ascii');

figure
plot(NPV1x,NPV1y,'r-*','markersize',4); %����ƽ����ֵ��
% hold on
% plot(NPV2x,NPV2y,'g-+','markersize',4); %��ƽ����ֵ��
hold on
plot(x2,y2,'black-','LineWidth', 1); %������
hold on
plot(NPV1x(row_1),NPV1m,'b-o','markersize',6,'MarkerFaceColor','b'); %�����ֵ���ֵ
text(1000,yyy2,['(',num2str(NPV1x(row_1)),',',num2str(NPV1m),')'],'color','b');
hold on
plot(Xm,Y2,'b-s','markersize',6,'MarkerFaceColor','b'); %�������ֵ
text(1000,yyy1,['(',num2str(xx1),',',num2str(yy1),')'],'color','b');
% hold on
% plot(NPV2x(row_2),NPV2m,'b-p','markersize',8,'MarkerFaceColor','b'); %���ֵ���ֵ
% text(700,yyy3,['(',num2str(NPV2x(row_2)),',',num2str(NPV2m),')'],'color','b');
xlabel('Hydropower expansion (MW)');
ylabel('NPV (billion CNY)');
legend('Numerical points','Fitted curve','Numerical optimal size','Calculated optimal size');

x3=0:1:3000;
[row3,cell3]=size(x3);
y3=zeros(row3,cell3);
figure
plot(NPV1x,error,'r-','LineWidth', 1);
hold on
plot(x3,y3,'b-','LineWidth', 1);
xlabel('Hydropower expansion (MW)');
ylabel('NPV (billion CNY)');
legend('NPV error','Numerical solution','Optimal size error');


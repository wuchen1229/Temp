%% 扩机、装机年利用小时数拟合

clear,clc,close all



% 第三段
Ec_data=load('Ec_data.txt');%试算值
x2=Ec_data(:,1);
y2=Ec_data(:,2);
Eqcsize=length(x2);
xmax=Ec_data(Eqcsize,1);
ymax=Ec_data(Eqcsize,2);
p2=polyfit(x2,y2,3);
Em_data=load('Em_data.txt');%数值解
x22=Em_data(:,1);
y22=Em_data(:,2);


% 第二段
qc_data=load('qc_data.txt');
x3=qc_data(:,1);
y3=qc_data(:,2);
p3=polyfit(x3,y3,1);
qm_data=load('qm_data.txt');
x33=qm_data(:,1);
y33=qm_data(:,2);


% 绘图
X2=0:7000;
Y2=polyval(p2,X2);
T2=[Y2(1) Y2(10:10:5810)];
T22=[Y2(1) Y2(10:10:7000)];
Ry2=y22(1:582,:);
R2=corrcoef(T2',Ry2);
XE=xmax;
YM=y22(30);
YE=round(YM,-2);
Y22=170:210;
[row22,cell22]=size(Y22);
X22=XE*ones(row22,cell22);
% Ec_numerical=T2';
Ec_numerical=T22';
%%画图
figure  %扩机-发电量
plot(x2,y2,'r-*','markersize',4); 
hold on
plot(x22,y22,'r-*','markersize',4); %发电量不变了
hold on
plot(X2,Y2,'b-','LineWidth', 2);
hold on
plot(x22,y22,'b-','LineWidth', 2);
hold on
plot(X22,Y22,'black--','LineWidth', 1.5);
hold on
plot(XE,YE,'b-s','markersize',6,'MarkerFaceColor','b'); %解析最大值
text(4400,205,['(',num2str(XE),',',num2str(YE),')'],'color','b');
xlabel('Hydropower expansion (MW)');
ylabel('Hydropower generation (hundred million kWh)');
legend('Numerical points','','','Fitted curve','','Maximum size');
save('Ec_numerical.txt','Ec_numerical','-ascii');%拟合曲线中离散扩机对应的发电量
save('R.txt','R2','-ascii');%拟合曲线决定性系数
save('扩机发电量参数.txt','p2','-ascii');%三次函数参数
%%
X3=0:6300;
Y3=polyval(p3,X3);
T3=[Y3(1) Y3(10:10:6040)];
Ry3=y33(1:605,:);
R3=corrcoef(T3',Ry3);
qc_numerical=T3';
figure  %扩机-弃电
plot(x3,y3,'r-+','markersize',4);
hold on
plot(X3,Y3,'black-','LineWidth', 2);
hold on
plot(x33,y33,'b-+','markersize',4);
xlabel('Hydropower expansion (MW)');
ylabel('WP-PV curtailment (%)');
legend('Numerical points','Fitted curve');
save('qc_numerical.txt','qc_numerical','-ascii');%拟合曲线中离散扩机对应的发电量
save('Rq.txt','R3','-ascii');%弃电拟合曲线决定性系数
save('扩机弃电率参数.txt','p3','-ascii');%一次函数参数



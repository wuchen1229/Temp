%% 鎵╂満鍑芥暟鏁忔劅鎬у垎鏋?

clear,clc,close all

syms x y z u
input=[0.08 0.03 0.009 0.004 0.1 0.06 0.012 0.008];
% input=[0.07 0.05 0.009 0.004 0.1 0.07 0.015 0.008];
Bmax=input(1);
Bmin=input(2);
Com_max=input(3);
Com_min=input(4);
rmax=input(5);
rmin=input(6);
Cin_max=input(7);
Cin_min=input(8);
r=0.1;
zmax=0;
zmin=0;
z1=0;
for i=1:50
    zmax=zmax+1/((1+rmax)^i);
end
for i=1:50
    zmin=zmin+1/((1+rmin)^i);
end
for i=1:50
    z1=z1+1/((1+r)^i);
end
dB=Bmax-Bmin;
dCom=Com_max-Com_min;
dz=zmax-zmin;
dCin=Cin_max-Cin_min;
sizeB=dB/0.01+1;
Result_B=zeros(sizeB,9);
%% 经济参数循环
data=[0.06 0.006 z1 0.009];%宸ヤ綔鐐瑰潗鏍囧?
% data=[0.05 0.006 z1 0.009];
k=dB/0.01+1;
for n=1:k
    B=Bmin+(n-1)*0.01;
    % n=(B-Bmin)/0.01+1;
% B=data(1);
Com=data(2);
acc_r=data(3);
Cin=data(4);
x0=(B-Bmin)/dB;%B
y0=(Com-Com_min)/dCom;%Com
z0=(acc_r-zmin)/dz;%鎶樼幇鐜?
u0=(Cin-Cin_min)/dCin;%Cin
para=[ 2.7501959e-10 -4.2911851e-06 2.2557334e-02 165.18637 -6.6203244E-5 0.4 23.0065];%绯绘暟
%鎵╂満鍙戠數绯绘暟
arfa1=para(1);
arfa2=para(2);
arfa3=para(3);
arfa4=para(4);
%鎵╂満寮冪數绯绘暟
beta1=para(5);
beta2=para(6);
Ewp=para(7);

%判别：是否存在可行解
deta=4*acc_r^2*(arfa2^2-arfa1*arfa3)*(B-Com)^2+12*arfa1*beta1*Ewp*acc_r^2*B*(B-Com)+12*acc_r*arfa1*Cin*(B-Com);

if deta>0
C1=0;
C2=arfa1*beta1*Ewp/(3*arfa1^2);
C3=1/(3*arfa1);
C4=(arfa2^2-3*arfa1*arfa3)/(9*arfa1^2);


f=-arfa2/(3*arfa1)-(C1*(x*dB+Bmin)^2/((z*dz+zmin)^2*(x*dB+Bmin-y*dCom-Com_min)^2)+C2*(x*dB+Bmin)/(x*dB+Bmin-y*dCom-Com_min)+C3*(u*dCin+Cin_min)/((z*dz+zmin)*(x*dB+Bmin-y*dCom-Com_min))+C4)^(1/2);

%鍋忓
dfx=diff(f,x);
dfy=diff(f,y);
dfz=diff(f,z);
dfu=diff(f,u);

A=-arfa2/(3*arfa1);
temp1=subs(f,{x,y,z,u},{x0,y0,z0,u0});
temp11=double(temp1);
% temp111=A-temp11^
temp2=subs(dfx,{x,y,z,u},{x0,y0,z0,u0});
temp22=double(temp2);
% temp222=
temp3=subs(dfy,{x,y,z,u},{x0,y0,z0,u0});
temp33=double(temp3);
% temp333=
temp4=subs(dfz,{x,y,z,u},{x0,y0,z0,u0});
temp44=double(temp4);
% temp444=
temp5=subs(dfu,{x,y,z,u},{x0,y0,z0,u0});
temp55=double(temp5);
% temp555=
temp=[temp11 temp22 temp33 temp44 temp55 x0 y0 z1 u0];
con_temp=temp';
else 
    temp=zeros(1,9);
end
Result_B(n,:)=temp;
end
tableB = array2table(Result_B);
saveName = 'Result_B.xlsx';
writetable(tableB, saveName, "Sheet", "电价敏感性");
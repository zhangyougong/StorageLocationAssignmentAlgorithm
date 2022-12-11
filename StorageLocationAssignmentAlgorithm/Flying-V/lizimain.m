%������
clc;
clear
close all
set(0,'defaultfigurecolor','w');
particle_num=20;
goods_num=88;  %88������
goods_kind=40;  %40����������
goods_pos=4;  %ÿ�������λ�ã�����������������������
goods_Vv=2;  %С��ˮƽ�ٶ�
goods_Vy=0.5;  %С����ֱ�ٶ�
layer_height=0.8;
layer_width=1;%��λ�ĳ���߾�Ϊ1m
pop_length=particle_num*goods_num; %��Ⱥ����
goods_init_num=[xlsread('��λ��Ϣ.xlsx',1,'D3:D22');xlsread('��λ��Ϣ.xlsx',1,'H3:H22')]';
goods_init_cumsum=cumsum(goods_init_num);
goods_init_frq=[xlsread('��λ��Ϣ.xlsx',1,'C3:C22');xlsread('��λ��Ϣ.xlsx',1,'G3:G22')]'./100;
goods_init_KG=[xlsread('��λ��Ϣ.xlsx',1,'B3:B22');xlsread('��λ��Ϣ.xlsx',1,'F3:F22')]';
for i=1:40
goods_frq(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_frq(i);%20������Ĵ�ȡƵ��
goods_weight(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_KG(i);
end
Wmax=0.8;%����Ȩ�ص����ֵ
Wmin=0;%����Ȩ�ص���Сֵ
% C1max=1;%ѧϰ���ӵ����ֵ
% C1min=0;%ѧϰ���ӵ���Сֵ
% C2max=1;
% C2min=0;
C1=2;%ѧϰ����
C2=2;%ѧϰ����
Vmax=[1*ones(pop_length,1),3*ones(pop_length,1),3*ones(pop_length,1),1*ones(pop_length,1)];%���ӵ��ٶ����ֵ
Vmin=[-1*ones(pop_length,1),-3*ones(pop_length,1),-3*ones(pop_length,1),-1*ones(pop_length,1)];%���ӵ��ٶ����ֵ
% Vmax=[4*ones(pop_length,1),12*ones(pop_length,1),12*ones(pop_length,1),4*ones(pop_length,1)];%���ӵ��ٶ����ֵ
% Vmin=[-4*ones(pop_length,1),-12*ones(pop_length,1),-12*ones(pop_length,1),-4*ones(pop_length,1)];%���ӵ��ٶ����ֵ
time_rate=1;  %ʱ�����۱���
gravity_rate=1;%�������۱���
generation=1000;%��������
goods_time_optimal_value=0;%ʱ������ֵ
goods_gravity_optimal_value=0;%��������ֵ
pop_average_objvalue=zeros(1,generation);  %����ƽ��Ŀ�꺯��ֵ
pop_best_objvalue=zeros(1,generation); %��������Ŀ�꺯��ֵ
pop_average_fitvalue=zeros(1,generation);  %����ƽ����Ӧ��ֵ
pop_best_fitvalue=zeros(1,generation); %����������Ӧ��ֵ
for k=1:3
    pop=particle_initpop(goods_num,goods_pos,particle_num); % �����������Ⱥ�ĳ�ʼλ��
    pop_v=particle_initv(goods_num,goods_pos,particle_num); % �����������Ⱥ�ĳ�ʼ�ٶ�
    pop_fitvalue=zeros(particle_num,generation); %��ʼ��ÿ�����ӵ�ÿһ������Ӧ��
    particle_fitvalue=zeros(1,particle_num); %ÿ�����ӵ�����Ӧ��
    bestfit_all=0; %��ʷ����Ӧ��
    particle_best_generation=zeros(pop_length,goods_pos);%ÿ�����ӵ���ʷ���Ÿ���
    bestparticle=zeros(goods_num,goods_pos);%����Ⱥ��ʷ���Ÿ���  
for q=1:generation   
W=Wmax-(Wmax-Wmin)*q/generation;%shi������Ĺ���Ȩ�صݼ�����
% C1=C1max-(C1max-C1min)*q/generation;%ѧϰ���ӷǶԳ����Եݼ�����
% C2=C2max-(C2max-C2min)*q/generation;
[objvalue,average_objvalue]=particle_calobjvalue(pop,particle_num,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%����Ŀ�꺯��
pop_father=pop;
objvalue_father=objvalue;
[fitvalue,average_fitvalue,bestfit_all,bestparticle,pop_fitvalue,particle_fitvalue,particle_best_generation] =particle_calfitvalue(pop,goods_num,bestparticle,particle_best_generation,pop_fitvalue,particle_fitvalue,objvalue,particle_num,q);%����������ӵ���Ӧ�Ⱥ�ƽ����Ӧ��
pop_average_objvalue(q)=average_objvalue;  %����ƽ��Ŀ�꺯��ֵ
pop_best_objvalue(q)=1./bestfit_all;  %��������Ŀ�꺯��ֵ
pop_average_fitvalue(q)=average_fitvalue;  %����ƽ����Ӧ��ֵ
pop_best_fitvalue(q)=bestfit_all; %����������Ӧ��ֵ
for i=1:pop_length  %����λ�ú��ٶ�
    for j=1:goods_pos
     s=mod(i,goods_num);
     if s==0
         s=goods_num;
     end
     pop_v(i,j)=W*pop_v(i,j)+C1*rand(1)*(particle_best_generation(i,j)-pop(i,j))+C2*rand(1)*(bestparticle(s,j)-pop(i,j));%�����ٶ�
     if pop_v(i,j)>Vmax(i,j)   %�ٶ��޷�
         pop_v(i,j)=Vmax(i,j);
     elseif pop_v(i,j)<Vmin(i,j)
         pop_v(i,j)=Vmin(i,j);
     end
     pop(i,j)=pop(i,j)+round(pop_v(i,j));  %����λ��    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
%%%%%%%%%%��������ĸ���λ�ý��б��죬�����������Ļ�������������в�����Լ����Ԫ�ؽ��б��죬��ɻ����.%%%%%%%%%%%%%%%%%%%%%%%
pop=particle_mutation(pop,particle_num,goods_num);
%%%%%%%%%%%%%%%%%%%ʹ�ñ任��ĸ��壬��Ӧֵ��ԭ�еĸ���Ҫ�á����û����Ӧֵ��ԭ�и���Ҫ�ã���ô�ø����滻�Ӵ���
[objvalue,average_objvalue]=particle_calobjvalue(pop,particle_num,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%����Ŀ�꺯��
for i=1:particle_num
    if objvalue_father(i)<objvalue(i)
        pop((i-1)*goods_num+1:i*goods_num,:)=pop_father((i-1)*goods_num+1:i*goods_num,:);
    end
end
end
if k==1
     goods_time_optimal_value=1/bestfit_all;
elseif k==2
     goods_gravity_optimal_value=1/bestfit_all;
end
end
plot(1:generation,pop_best_objvalue,'k','Linewidth',1.2);
hold on;
plot(1:generation,pop_average_objvalue,'k:','Linewidth',1.5);
axis([0 generation 200 500]);
legend('�Ż�Ŀ������ֵ','�Ż�Ŀ��ƽ��ֵ');
box;
xlabel('�Ŵ����� ');
ylabel('�Ż�Ŀ��ֵ');
title('�Ż�Ŀ��ֵ����');
% title('Objvalue of all as generation goes on');
% xlabel('generation');
% ylabel('fitness of all'); 
figure;hold on;
plot(1:generation,pop_best_fitvalue,'k','Linewidth',1.2);
plot(1:generation,pop_average_fitvalue,'k:','Linewidth',1.5);
legend('��Ӧ������ֵ','��Ӧ��ƽ��ֵ');
box;
xlabel('�Ŵ�����');
ylabel('��Ӧ��ֵ');
title('��Ӧ��ֵ����');
% title('Fitness of all as generation goes on');
% xlabel('generation');
% ylabel('fitness of all'); 
promote=(pop_best_objvalue(1)-pop_best_objvalue(generation))./pop_best_objvalue(1)

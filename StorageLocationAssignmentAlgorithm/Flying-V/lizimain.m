%主程序
clc;
clear
close all
set(0,'defaultfigurecolor','w');
particle_num=20;
goods_num=88;  %88个货物
goods_kind=40;  %40个货物种类
goods_pos=4;  %每个货物的位置，货区，排数，列数，层数
goods_Vv=2;  %小车水平速度
goods_Vy=0.5;  %小车竖直速度
layer_height=0.8;
layer_width=1;%货位的长宽高均为1m
pop_length=particle_num*goods_num; %种群数量
goods_init_num=[xlsread('货位信息.xlsx',1,'D3:D22');xlsread('货位信息.xlsx',1,'H3:H22')]';
goods_init_cumsum=cumsum(goods_init_num);
goods_init_frq=[xlsread('货位信息.xlsx',1,'C3:C22');xlsread('货位信息.xlsx',1,'G3:G22')]'./100;
goods_init_KG=[xlsread('货位信息.xlsx',1,'B3:B22');xlsread('货位信息.xlsx',1,'F3:F22')]';
for i=1:40
goods_frq(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_frq(i);%20个货物的存取频率
goods_weight(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_KG(i);
end
Wmax=0.8;%惯性权重的最大值
Wmin=0;%惯性权重的最小值
% C1max=1;%学习因子的最大值
% C1min=0;%学习因子的最小值
% C2max=1;
% C2min=0;
C1=2;%学习因子
C2=2;%学习因子
Vmax=[1*ones(pop_length,1),3*ones(pop_length,1),3*ones(pop_length,1),1*ones(pop_length,1)];%粒子的速度最大值
Vmin=[-1*ones(pop_length,1),-3*ones(pop_length,1),-3*ones(pop_length,1),-1*ones(pop_length,1)];%粒子的速度最大值
% Vmax=[4*ones(pop_length,1),12*ones(pop_length,1),12*ones(pop_length,1),4*ones(pop_length,1)];%粒子的速度最大值
% Vmin=[-4*ones(pop_length,1),-12*ones(pop_length,1),-12*ones(pop_length,1),-4*ones(pop_length,1)];%粒子的速度最大值
time_rate=1;  %时间评价比重
gravity_rate=1;%重心评价比重
generation=1000;%迭代次数
goods_time_optimal_value=0;%时间最优值
goods_gravity_optimal_value=0;%重心最优值
pop_average_objvalue=zeros(1,generation);  %历代平均目标函数值
pop_best_objvalue=zeros(1,generation); %历代最优目标函数值
pop_average_fitvalue=zeros(1,generation);  %历代平均适应度值
pop_best_fitvalue=zeros(1,generation); %历代最优适应度值
for k=1:3
    pop=particle_initpop(goods_num,goods_pos,particle_num); % 随机产生粒子群的初始位置
    pop_v=particle_initv(goods_num,goods_pos,particle_num); % 随机产生粒子群的初始速度
    pop_fitvalue=zeros(particle_num,generation); %初始化每个粒子的每一代的适应度
    particle_fitvalue=zeros(1,particle_num); %每个粒子的最适应度
    bestfit_all=0; %历史最适应度
    particle_best_generation=zeros(pop_length,goods_pos);%每个粒子的历史最优个体
    bestparticle=zeros(goods_num,goods_pos);%粒子群历史最优个体  
for q=1:generation   
W=Wmax-(Wmax-Wmin)*q/generation;%shi等提出的惯性权重递减策略
% C1=C1max-(C1max-C1min)*q/generation;%学习因子非对称线性递减策略
% C2=C2max-(C2max-C2min)*q/generation;
[objvalue,average_objvalue]=particle_calobjvalue(pop,particle_num,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%计算目标函数
pop_father=pop;
objvalue_father=objvalue;
[fitvalue,average_fitvalue,bestfit_all,bestparticle,pop_fitvalue,particle_fitvalue,particle_best_generation] =particle_calfitvalue(pop,goods_num,bestparticle,particle_best_generation,pop_fitvalue,particle_fitvalue,objvalue,particle_num,q);%计算各个粒子的适应度和平均适应度
pop_average_objvalue(q)=average_objvalue;  %当代平均目标函数值
pop_best_objvalue(q)=1./bestfit_all;  %历代最优目标函数值
pop_average_fitvalue(q)=average_fitvalue;  %当代平均适应度值
pop_best_fitvalue(q)=bestfit_all; %历代最优适应度值
for i=1:pop_length  %更新位置和速度
    for j=1:goods_pos
     s=mod(i,goods_num);
     if s==0
         s=goods_num;
     end
     pop_v(i,j)=W*pop_v(i,j)+C1*rand(1)*(particle_best_generation(i,j)-pop(i,j))+C2*rand(1)*(bestparticle(s,j)-pop(i,j));%更新速度
     if pop_v(i,j)>Vmax(i,j)   %速度限幅
         pop_v(i,j)=Vmax(i,j);
     elseif pop_v(i,j)<Vmin(i,j)
         pop_v(i,j)=Vmin(i,j);
     end
     pop(i,j)=pop(i,j)+round(pop_v(i,j));  %更新位置    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
%%%%%%%%%%对死个体的个别位置进行变异，如果有死个体的话对死个体的所有不满足约束的元素进行变异，变成活个体.%%%%%%%%%%%%%%%%%%%%%%%
pop=particle_mutation(pop,particle_num,goods_num);
%%%%%%%%%%%%%%%%%%%使得变换后的个体，适应值比原有的父代要好。如果没有适应值比原有父代要好，那么让父代替换子代。
[objvalue,average_objvalue]=particle_calobjvalue(pop,particle_num,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%计算目标函数
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
legend('优化目标最优值','优化目标平均值');
box;
xlabel('遗传代数 ');
ylabel('优化目标值');
title('优化目标值曲线');
% title('Objvalue of all as generation goes on');
% xlabel('generation');
% ylabel('fitness of all'); 
figure;hold on;
plot(1:generation,pop_best_fitvalue,'k','Linewidth',1.2);
plot(1:generation,pop_average_fitvalue,'k:','Linewidth',1.5);
legend('适应度最优值','适应度平均值');
box;
xlabel('遗传代数');
ylabel('适应度值');
title('适应度值曲线');
% title('Fitness of all as generation goes on');
% xlabel('generation');
% ylabel('fitness of all'); 
promote=(pop_best_objvalue(1)-pop_best_objvalue(generation))./pop_best_objvalue(1)

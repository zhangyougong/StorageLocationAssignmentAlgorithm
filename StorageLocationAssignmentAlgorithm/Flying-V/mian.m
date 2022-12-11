%主程序
clc
clear
close all
tic
set(0,'defaultfigurecolor','w');
%objvalue_or_fitalue=1;%1表示绘制目标函数图像，0表示绘制适应度函数图像
title_font_size = 11;
r_linewidth=2.2;
g_linewidth=2;
k_linewidth=2;
b_linewidth=2;
popsize=100;   %群体大小
goods_num=88;  %20个货物
goods_kind=40; %货物的种类
goods_pos=12;  %每个货物的位置，2位货区，4位排数，4位列数，2位层数
goods_Vv=2;    %小车水平速度
goods_Vy=0.5;  %小车竖直速度
layer_height=0.8;%货架高度
layer_width=1;   %货位的长宽均为1m
goods_init_num=[xlsread('货位信息.xlsx',1,'D3:D22');xlsread('货位信息.xlsx',1,'H3:H22')]';
goods_init_cumsum=cumsum(goods_init_num);
goods_init_frq=[xlsread('货位信息.xlsx',1,'C3:C22');xlsread('货位信息.xlsx',1,'G3:G22')]'./100;
goods_init_KG=[xlsread('货位信息.xlsx',1,'B3:B22');xlsread('货位信息.xlsx',1,'F3:F22')]';
for i=1:40
goods_frq(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_frq(i); % 88个货物的存取频率
goods_weight(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_KG(i);
end
% goods_frq
% goods_weight
%goods_frq=ones(1,goods_num);
%goods_weight=[13 13 27 29 15 15 15 28 28 28 37 37 37 17 40 23 23 23 18 29 13 13 13 13 22 36 36 36 14 14 21 21 21 19 39 39 39 20 20 20 37 32 32 32 20 34 18 31 30 28 35 27 29 34 33 33 19 37 19 36 40 22 11];%20个货物的质量
time_rate=1;  %时间评价比重
gravity_rate=1;%重心评价比重
%pc=0;  %交叉概率
%pm=0; %变异概率 自适应遗传算法
generation=1000;%迭代次数
goods_time_optimal_value=0;
goods_gravity_optimal_value=0;
result_bestfit_time=zeros(1,generation);
result_bestfit_gravity=zeros(1,generation);
result_bestfit_all=zeros(1,generation);
result_objvalue_time=zeros(1,generation);
result_objvalue_gravity=zeros(1,generation);
result_objvalue_all=zeros(1,generation);
average_fitvalue_time_generation=zeros(1,generation);
average_fitvalue_gravity_generation=zeros(1,generation);
average_fitvalue_all_generation=zeros(1,generation);
average_result_objvalue_time=zeros(1,generation);
average_result_objvalue_gravity=zeros(1,generation);
average_result_objvalue_all=zeros(1,generation);
for k=1:3
    pop=initpop(goods_num,goods_pos,popsize);%随机产生初始群体
    bestfit_all=0; %最适应值
%   best_num=zeros(1,generation);%每一代最适应个体编号
    bestindividual_all=zeros(goods_num,goods_pos);%最优的布局方式  
    result_indiv=zeros(generation,goods_pos);
    individual_fitvalue=zeros(generation,popsize);%每一代中每个个体的适应值
%     result_best_number=zeros(1,generation);
%     result_change_best_number=zeros(1,generation);
%     result_best_fit=zeros(1,generation);
%     result_change_best_fit=zeros(1,generation);
%     result_best_all=zeros(1,generation);
for q=1:generation 
[objvalue,average_objvalue]=calobjvalue(pop,popsize,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%计算目标函数
[fitvalue,average_fitvalue]=calfitvalue(objvalue,popsize);%计算群体中每个个体的适应度和平均适应度
[best_number,bestindividual_current,bestfit_current]=best(pop,fitvalue,popsize,goods_num);%求出群体中适应值最大的个体及其适应值
if(bestfit_current>bestfit_all)  
   bestindividual_all=bestindividual_current;
   bestfit_all=bestfit_current;
else
   pop((best_number-1)*goods_num+1:best_number*goods_num,:)=bestindividual_all;%最佳保留，直接遗传,可以替换
   [objvalue,average_objvalue]=calobjvalue(pop,popsize,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%计算目标函数
   [fitvalue,average_fitvalue]=calfitvalue(objvalue,popsize);%计算群体中每个个体的适应度和平均适应度
   [best_number,bestindividual_current,bestfit_current]=best(pop,fitvalue,popsize,goods_num);%求出群体中适应值最大的个体及其适应值%OK 
end 
%%%%%%%%%%%%%%%%%%%%%%把适应值和目标值存放起来***********************
if k==1
     result_bestfit_time(q)=bestfit_current;
     result_objvalue_time(q)=min(objvalue);
     average_fitvalue_time_generation(q)=average_fitvalue;
     average_result_objvalue_time(q)=average_objvalue;
elseif k==2
    result_bestfit_gravity(q)=bestfit_current;
    result_objvalue_gravity(q)=min(objvalue);
     average_fitvalue_gravity_generation(q)=average_fitvalue;
     average_result_objvalue_gravity(q)=average_objvalue;
elseif k==3
    result_bestfit_all(q)=bestfit_current;
    result_objvalue_all(q)=min(objvalue);
    average_fitvalue_all_generation(q)=average_fitvalue;
    
    if q==1
        average_objvalue_init=1./average_fitvalue;
        best_objvalue_init=1./bestfit_current;
    end
    if q==generation
        average_objvalue_last=1./average_fitvalue;
        best_objvalue_last=1./bestfit_current;
    end
    average_result_objvalue_all(q)=average_objvalue;
end
%%%%%%%%%%%%%%%%%%%%遗传算子%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[newpop]=selection(pop,fitvalue,popsize,goods_num,q,generation);%选择
pop=newpop;
[objvalue,~]=calobjvalue(pop,popsize,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%计算目标函数
[fitvalue,~]=calfitvalue(objvalue,popsize);%计算群体中每个个体的适应度和平均适应度
[newpop]=crossover(pop,popsize,goods_num,goods_pos,fitvalue);%交叉OK
pop=newpop;
[objvalue,~]=calobjvalue(pop,popsize,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%计算目标函数
[fitvalue,~]=calfitvalue(objvalue,popsize);%计算群体中每个个体的适应度和平均适应度
[newpop]=mutation(pop,popsize,goods_num,fitvalue);%变异OK
pop=newpop;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
if k==1
    goods_time_optimal_value=1/bestfit_all;
elseif k==2
    goods_gravity_optimal_value=1/bestfit_all;
end
%%%%%%%%显示最后的结果*******************
result_plan=horzcat(decodechrom(bestindividual_current,1,2),decodechrom(bestindividual_current,3,6));
result_plan=horzcat(result_plan,decodechrom(bestindividual_current,7,10));
result_plan=horzcat(result_plan,decodechrom(bestindividual_current,11,12));
end
pop_plan=horzcat(decodechrom(pop,1,2),decodechrom(pop,3,6));
pop_plan=horzcat(pop_plan,decodechrom(pop,7,10));
pop_plan=horzcat(pop_plan,decodechrom(pop,11,12));

%if objvalue_or_fitalue
% figure(1);
% subplot(1,2,1)
% plot(1:generation,result_objvalue_time,'k','Linewidth',1.2);%时间目标最优值
% hold on;
% plot(1:generation,average_result_objvalue_time,'k:','Linewidth',1.5);%时间目标平均值
% % title(' Objvalue of time as generation goes on');
% % xlabel('generation ');
% % ylabel('objvalue of time');
% xlabel('遗传代数 ');
% ylabel('时间的目标值');
% %grid on;
% subplot(1,2,2)
% plot(1:generation,result_objvalue_gravity,'k','Linewidth',1.2); %重量目标最优值
% hold on;
% plot(1:generation,average_result_objvalue_gravity,'k:','Linewidth',1.5);%重量目标平均值
% title('Objvalue of gravity as generation goes on');
% % xlabel('generation');
% % ylabel('objvalue of gravity');
% xlabel('遗传代数 ');
% ylabel('重心的目标值');
%grid on;
figure(1)
plot(1:generation,result_objvalue_all,'k','linewidth',k_linewidth);%目标最优值
hold on;
plot(1:generation,average_result_objvalue_all,'b','linewidth',b_linewidth);%目标平均值
xlabel('generation');
ylabel('F','Interpreter','latex');
legend('Optimal value','Average value');legend('boxoff');
set(gca,'FontSize',title_font_size,'FontName','Times New Roman','FontWeight','bold');
axis([0 generation 200 500]);
box;
%grid on;
%else
% figure(3);
% subplot(1,2,1)
% plot(1:generation,result_bestfit_time,'k','Linewidth',1.2) %时间适应度最优值
% hold on;
% plot(1:generation,average_fitvalue_time_generation,'k:','Linewidth',1.5);%时间适应度平均值
% title(' Fitness of time as generation goes on');
% xlabel('generation ');
% ylabel('fitness of time');
% %grid on;
% subplot(1,2,2)
% plot(1:generation,result_bestfit_gravity,'k','Linewidth',1.2); %重量适应度最优值
% hold on;
% plot(1:generation,average_fitvalue_gravity_generation,'k:','Linewidth',1.5); %重量适应度平均值
% title('Fitness of gravity as generation goes on');
% xlabel('generation');
% ylabel('fitness of gravity');
% %grid on;
figure(2);
plot(1:generation,result_bestfit_all,'k','linewidth',k_linewidth); %适应度最优值
hold on;
plot(1:generation,average_fitvalue_all_generation,'b','linewidth',b_linewidth);%适应度平均值
legend('Optimal value','Average value');legend('boxoff');
xlabel('generation');
ylabel('G','Interpreter','latex'); 
set(gca,'FontSize',title_font_size,'FontName','Times New Roman','FontWeight','bold');
box;
%grid on
%end
result_plan1=result_plan(:,1).*1000+result_plan(:,2).*100+result_plan(:,3).*10+result_plan(:,4);
toc
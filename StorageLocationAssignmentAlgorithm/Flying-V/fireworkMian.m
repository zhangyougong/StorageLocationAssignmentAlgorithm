%主程序
clc
clear
close all
tic
set(0,'defaultfigurecolor','w');
title_font_size = 11;
r_linewidth=2.2;
g_linewidth=2;
k_linewidth=2;
b_linewidth=2;
%objvalue_or_fitalue=1; % 1表示绘制目标函数图像，0表示绘制适应度函数图像
popsize=100;    % 烟花数量
goods_num=88;  % 货物数量
goods_kind=40; % 货物的种类
goods_pos=4;   % 每个货物的位置，货区，排数，列数，层数
goods_Vv=2;    % 小车水平速度
goods_Vy=0.5;  % 小车竖直速度
layer_height=0.8; % 货架高度
layer_width=1;   % 货位的长宽均为1m
dim = goods_num * goods_pos;  % 货物数量 * 货物维度  352 整个火花的维度
gaussianNum = 1; % 产生高斯火花的数目
goods_init_num=[xlsread('货位信息.xlsx',1,'D3:D22');xlsread('货位信息.xlsx',1,'H3:H22')]';
goods_init_cumsum=cumsum(goods_init_num);
goods_init_frq=[xlsread('货位信息.xlsx',1,'C3:C22');xlsread('货位信息.xlsx',1,'G3:G22')]'./100;
goods_init_KG=[xlsread('货位信息.xlsx',1,'B3:B22');xlsread('货位信息.xlsx',1,'F3:F22')]';

% 每一种货物 存取频率和重量信息
for i=1:goods_kind
     goods_frq(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_frq(i); 
     goods_weight(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_KG(i);
end

%%%%%%%%%%%%%%%%%%%%%%% 算法参数 %%%%%%%%%%%%%%%%%%%%%%%
time_rate=1;  % 时间评价比重
gravity_rate=1; % 重心评价比重
generation=1000; % 迭代次数
%%%%%%%%%%%%%%%%%%%%%%% 算法参数 %%%%%%%%%%%%%%%%%%%%%%%
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
    pop=fireworkInitpop(goods_num,goods_pos,popsize);  %   随机产生初始群体
    bestindividual_all=zeros(goods_num,goods_pos);     %  最优的布局方式 
    bestindividual_current = zeros(goods_num,goods_pos);
    result_indiv=zeros(generation,goods_pos);
    individual_fitvalue=zeros(generation,popsize);     % 每一代中每个个体的适应值
    for q=1:generation 
      % disp(q);
      %%%%%%%%%%%%%% 计算目标值和适应度值 %%%%%%%%%%%%%%%%
      [objvalue,average_objvalue]= fireworkCalobjvalue(pop,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%计算目标函数
      currentPopsize = length(pop)./goods_num;
      [fitvalue,average_fitvalue]= calfitvalue(objvalue,currentPopsize); %%%% 计算群体中每个个体的适应度和平均适应度
      [~, ~, bestfit_current]= best(pop,fitvalue,currentPopsize,goods_num);
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
          result_bestfit_all(q)= bestfit_current;
          result_objvalue_all(q)=min(objvalue);
          average_fitvalue_all_generation(q)=average_fitvalue;
          average_result_objvalue_all(q)=average_objvalue;
      end

      %%%%%%%%%%%%%%%%%%%% 计算爆炸半径和爆炸数量  %%%%%%%%%%%%%%%%%%
      [explode_radius, explode_num] = fireworksRadius(fitvalue, currentPopsize);   %%%% 计算爆炸半径和爆炸数目
      %%%%%%%%%%%%%%%%%%%%  产生爆炸烟花 %%%%%%%%%%%%%%%%%%%%%%
      [newpop] = fireworkExplode(pop, explode_radius, explode_num, goods_num, popsize, dim);
      pop = [pop;newpop];
      %%%%%%%%%%%%%%%%%%%%  产生高斯烟花 %%%%%%%%%%%%%%%%%%%%%%
      [newpop]= fireworkGaussian(pop, goods_num,gaussianNum, dim); 
      %pop = [pop;newpop];
      currentPopsize = length(pop)./goods_num;
      pop = fireworkFilter(pop, goods_num, currentPopsize);
      %%%%%%%%%%%%%% 计算目标值和适应度值 %%%%%%%%%%%%%%%%
      [objvalue,~]= fireworkCalobjvalue(pop,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%计算目标函数
      currentPopsize = length(pop)./goods_num;
      [fitvalue,~]= calfitvalue(objvalue,currentPopsize); %%%% 计算群体中每个个体的适应度和平均适应度
      [best_number, bestindividual_current, bestfit_current]= best(pop,fitvalue,currentPopsize,goods_num); %%%求出群体中适应值最大的个体及其适应值
      %%%%%%%%%%%%%%%%%%%%  选择 %%%%%%%%%%%%%%%%%%%%%%
      [newpop]=fireworkSelection2(pop, goods_num, popsize, bestindividual_current, fitvalue, q, generation); %%%%%  选择
      pop=newpop;
   end
   if k==1
      goods_time_optimal_value = 1/bestfit_current;
   elseif k==2
      goods_gravity_optimal_value = 1/bestfit_current;
   end
   %%%%%%%%显示最后的结果*******************
   result_plan=bestindividual_current;
end
pop_plan=pop;

%if objvalue_or_fitalue
figure(1);
% subplot(1,2,1)
% plot(1:generation,result_objvalue_time,'k','Linewidth',1.2); % 时间目标最优值
% hold on;
% plot(1:generation,average_result_objvalue_time,'k:','Linewidth',1.5); % 时间目标平均值
% % title(' Objvalue of time as generation goes on');
% % xlabel('generation ');
% % ylabel('objvalue of time');
% %grid on;
% subplot(1,2,2)
% plot(1:generation,result_objvalue_gravity,'k','Linewidth',1.2); % 重量目标最优值
% hold on;
% plot(1:generation,average_result_objvalue_gravity,'k:','Linewidth',1.5); % 重量目标平均值
% title('Objvalue of gravity as generation goes on');
% % xlabel('generation');
% % ylabel('objvalue of gravity');
% xlabel('烟花代数 ');
% ylabel('重心的目标值');
% %grid on;
% figure(2)
plot(1:generation,result_objvalue_all,'k','linewidth',k_linewidth); % 目标最优值
hold on;
plot(1:generation,average_result_objvalue_all,'b','linewidth',b_linewidth); % 目标平均值
xlabel('generation');
ylabel('F','Interpreter','latex');
legend('Optimal value','Average value');legend('boxoff');
axis([0 generation 0 400]);
set(gca,'FontSize',title_font_size,'FontName','Times New Roman','FontWeight','bold');
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
%grid on;
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
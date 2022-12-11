%������
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
%objvalue_or_fitalue=1; % 1��ʾ����Ŀ�꺯��ͼ��0��ʾ������Ӧ�Ⱥ���ͼ��
popsize=100;    % �̻�����
goods_num=88;  % ��������
goods_kind=40; % ���������
goods_pos=4;   % ÿ�������λ�ã�����������������������
goods_Vv=2;    % С��ˮƽ�ٶ�
goods_Vy=0.5;  % С����ֱ�ٶ�
layer_height=0.8; % ���ܸ߶�
layer_width=1;   % ��λ�ĳ����Ϊ1m
dim = goods_num * goods_pos;  % �������� * ����ά��  352 �����𻨵�ά��
gaussianNum = 1; % ������˹�𻨵���Ŀ
goods_init_num=[xlsread('��λ��Ϣ.xlsx',1,'D3:D22');xlsread('��λ��Ϣ.xlsx',1,'H3:H22')]';
goods_init_cumsum=cumsum(goods_init_num);
goods_init_frq=[xlsread('��λ��Ϣ.xlsx',1,'C3:C22');xlsread('��λ��Ϣ.xlsx',1,'G3:G22')]'./100;
goods_init_KG=[xlsread('��λ��Ϣ.xlsx',1,'B3:B22');xlsread('��λ��Ϣ.xlsx',1,'F3:F22')]';

% ÿһ�ֻ��� ��ȡƵ�ʺ�������Ϣ
for i=1:goods_kind
     goods_frq(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_frq(i); 
     goods_weight(1,goods_init_cumsum(i)-goods_init_num(i)+1:goods_init_cumsum(i))=goods_init_KG(i);
end

%%%%%%%%%%%%%%%%%%%%%%% �㷨���� %%%%%%%%%%%%%%%%%%%%%%%
time_rate=1;  % ʱ�����۱���
gravity_rate=1; % �������۱���
generation=1000; % ��������
%%%%%%%%%%%%%%%%%%%%%%% �㷨���� %%%%%%%%%%%%%%%%%%%%%%%
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
    pop=fireworkInitpop(goods_num,goods_pos,popsize);  %   ���������ʼȺ��
    bestindividual_all=zeros(goods_num,goods_pos);     %  ���ŵĲ��ַ�ʽ 
    bestindividual_current = zeros(goods_num,goods_pos);
    result_indiv=zeros(generation,goods_pos);
    individual_fitvalue=zeros(generation,popsize);     % ÿһ����ÿ���������Ӧֵ
    for q=1:generation 
      % disp(q);
      %%%%%%%%%%%%%% ����Ŀ��ֵ����Ӧ��ֵ %%%%%%%%%%%%%%%%
      [objvalue,average_objvalue]= fireworkCalobjvalue(pop,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%����Ŀ�꺯��
      currentPopsize = length(pop)./goods_num;
      [fitvalue,average_fitvalue]= calfitvalue(objvalue,currentPopsize); %%%% ����Ⱥ����ÿ���������Ӧ�Ⱥ�ƽ����Ӧ��
      [~, ~, bestfit_current]= best(pop,fitvalue,currentPopsize,goods_num);
      %%%%%%%%%%%%%%%%%%%%%%����Ӧֵ��Ŀ��ֵ�������***********************
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

      %%%%%%%%%%%%%%%%%%%% ���㱬ը�뾶�ͱ�ը����  %%%%%%%%%%%%%%%%%%
      [explode_radius, explode_num] = fireworksRadius(fitvalue, currentPopsize);   %%%% ���㱬ը�뾶�ͱ�ը��Ŀ
      %%%%%%%%%%%%%%%%%%%%  ������ը�̻� %%%%%%%%%%%%%%%%%%%%%%
      [newpop] = fireworkExplode(pop, explode_radius, explode_num, goods_num, popsize, dim);
      pop = [pop;newpop];
      %%%%%%%%%%%%%%%%%%%%  ������˹�̻� %%%%%%%%%%%%%%%%%%%%%%
      [newpop]= fireworkGaussian(pop, goods_num,gaussianNum, dim); 
      %pop = [pop;newpop];
      currentPopsize = length(pop)./goods_num;
      pop = fireworkFilter(pop, goods_num, currentPopsize);
      %%%%%%%%%%%%%% ����Ŀ��ֵ����Ӧ��ֵ %%%%%%%%%%%%%%%%
      [objvalue,~]= fireworkCalobjvalue(pop,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k);%����Ŀ�꺯��
      currentPopsize = length(pop)./goods_num;
      [fitvalue,~]= calfitvalue(objvalue,currentPopsize); %%%% ����Ⱥ����ÿ���������Ӧ�Ⱥ�ƽ����Ӧ��
      [best_number, bestindividual_current, bestfit_current]= best(pop,fitvalue,currentPopsize,goods_num); %%%���Ⱥ������Ӧֵ���ĸ��弰����Ӧֵ
      %%%%%%%%%%%%%%%%%%%%  ѡ�� %%%%%%%%%%%%%%%%%%%%%%
      [newpop]=fireworkSelection2(pop, goods_num, popsize, bestindividual_current, fitvalue, q, generation); %%%%%  ѡ��
      pop=newpop;
   end
   if k==1
      goods_time_optimal_value = 1/bestfit_current;
   elseif k==2
      goods_gravity_optimal_value = 1/bestfit_current;
   end
   %%%%%%%%��ʾ���Ľ��*******************
   result_plan=bestindividual_current;
end
pop_plan=pop;

%if objvalue_or_fitalue
figure(1);
% subplot(1,2,1)
% plot(1:generation,result_objvalue_time,'k','Linewidth',1.2); % ʱ��Ŀ������ֵ
% hold on;
% plot(1:generation,average_result_objvalue_time,'k:','Linewidth',1.5); % ʱ��Ŀ��ƽ��ֵ
% % title(' Objvalue of time as generation goes on');
% % xlabel('generation ');
% % ylabel('objvalue of time');
% %grid on;
% subplot(1,2,2)
% plot(1:generation,result_objvalue_gravity,'k','Linewidth',1.2); % ����Ŀ������ֵ
% hold on;
% plot(1:generation,average_result_objvalue_gravity,'k:','Linewidth',1.5); % ����Ŀ��ƽ��ֵ
% title('Objvalue of gravity as generation goes on');
% % xlabel('generation');
% % ylabel('objvalue of gravity');
% xlabel('�̻����� ');
% ylabel('���ĵ�Ŀ��ֵ');
% %grid on;
% figure(2)
plot(1:generation,result_objvalue_all,'k','linewidth',k_linewidth); % Ŀ������ֵ
hold on;
plot(1:generation,average_result_objvalue_all,'b','linewidth',b_linewidth); % Ŀ��ƽ��ֵ
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
% plot(1:generation,result_bestfit_time,'k','Linewidth',1.2) %ʱ����Ӧ������ֵ
% hold on;
% plot(1:generation,average_fitvalue_time_generation,'k:','Linewidth',1.5);%ʱ����Ӧ��ƽ��ֵ
% title(' Fitness of time as generation goes on');
% xlabel('generation ');
% ylabel('fitness of time');
% %grid on;
% subplot(1,2,2)
% plot(1:generation,result_bestfit_gravity,'k','Linewidth',1.2); %������Ӧ������ֵ
% hold on;
% plot(1:generation,average_fitvalue_gravity_generation,'k:','Linewidth',1.5); %������Ӧ��ƽ��ֵ
% title('Fitness of gravity as generation goes on');
% xlabel('generation');
% ylabel('fitness of gravity');
%grid on;
figure(2);
plot(1:generation,result_bestfit_all,'k','linewidth',k_linewidth); %��Ӧ������ֵ
hold on;
plot(1:generation,average_fitvalue_all_generation,'b','linewidth',b_linewidth);%��Ӧ��ƽ��ֵ
legend('Optimal value','Average value');legend('boxoff');
xlabel('generation');
ylabel('G','Interpreter','latex'); 
set(gca,'FontSize',title_font_size,'FontName','Times New Roman','FontWeight','bold');
box;
%grid on
%end
result_plan1=result_plan(:,1).*1000+result_plan(:,2).*100+result_plan(:,3).*10+result_plan(:,4);
toc
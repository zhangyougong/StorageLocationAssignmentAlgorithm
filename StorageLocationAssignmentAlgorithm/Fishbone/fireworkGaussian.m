function [newpop] = fireworkGaussian(pop, goods_num, gaussianNum, dim)
%����
%�Ŵ��㷨�ı������Կ���ʹ�������������������ܴ��ڵ������ռ䣬��˿�����һ���̶������ȫ�����Ž⡣
popsize = length(pop)./goods_num;
newpop = zeros(gaussianNum*goods_num ,4);
lowerBound = 1;
for i=1:gaussianNum
     firework_index = ceil(rand()*popsize); % ѡ�еĻ𻨱��
     gauss = normrnd(1, 1);  % ��ֵΪ1 ����Ϊ1 �ĸ�˹����
     dimens_select = ceil(rand()*dim);  % ��Dά����ѡ��Z��ά��
     origin_goods_assignment = pop((firework_index-1)*goods_num+1 : firework_index*goods_num,:); 
     new_goods_assignment = origin_goods_assignment; %% ����Ӧ��ȡ���ɵĸ���
     for k = 1 : dimens_select
         rand_dimen = ceil(rand()*dim); % ��Dά����ѡ��1��ά��
         dimen_row = ceil(rand_dimen/4);  %  �ڼ���
         dimen_list = rand_dimen - (dimen_row-1) * 4; % �ڼ��� 
         originValue = origin_goods_assignment(dimen_row, dimen_list);
         nowValue = ceil(originValue*gauss); % ���ڵ�ֵ
         if(nowValue>getUpperBound(origin_goods_assignment(dimen_row, :), dimen_list))   %% ��ȡ�Ͻ�
             nowValue = getUpperBound(origin_goods_assignment(dimen_row, :), dimen_list);
         elseif (nowValue<lowerBound)
             nowValue = lowerBound;
         end
            new_goods_assignment(dimen_row, dimen_list) = nowValue;
     end
     newpop((i-1)*goods_num+1 : i*goods_num,:) = new_goods_assignment;
end
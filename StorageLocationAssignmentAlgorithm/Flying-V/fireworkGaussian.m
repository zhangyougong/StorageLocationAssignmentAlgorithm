function [newpop] = fireworkGaussian(pop, goods_num, gaussianNum, dim)
popsize = length(pop)./goods_num;
newpop = zeros(gaussianNum*goods_num ,4);
lowerBound = 1;
for i=1:gaussianNum
     firework_index = ceil(rand()*popsize); % ѡ�еĻ𻨱��
     gauss = normrnd(1, 1);  % ��ֵΪ1 ����Ϊ1 �ĸ�˹����
     %dimens_select = ceil(rand()*dim);  % ��Dά����ѡ��Z��ά��
     dimens_select = 1;
     origin_goods_assignment = pop((firework_index-1)*goods_num+1 : firework_index*goods_num,:); 
     new_goods_assignment = origin_goods_assignment; %% ����Ӧ��ȡ���ɵĸ���
     for k = 1 : dimens_select
         goods_common = 1;
         while(goods_common == 1) 
                goods_common = 0;
         rand_dimen = ceil(rand()*dim); % ��Dά����ѡ��1��ά��
         dimen_row = ceil(rand_dimen/4);  %  �ڼ���
         dimen_list = rand_dimen - (dimen_row-1) * 4; % �ڼ��� 
         originValue = origin_goods_assignment(dimen_row, dimen_list);
         nowValue = round(originValue*gauss); % ���ڵ�ֵ
         if(nowValue>getUpperBound(origin_goods_assignment(dimen_row, :), dimen_list))   %% ��ȡ�Ͻ�
             nowValue = getUpperBound(origin_goods_assignment(dimen_row, :), dimen_list);
         elseif (nowValue<lowerBound)
             nowValue = lowerBound;
         end
         new_goods_assignment(dimen_row, dimen_list) = nowValue;
         for p=1:goods_num
                if(dimen_row == p) 
                    continue;
                end
                goods_differ1=sum(~(new_goods_assignment(dimen_row,:)==pop((firework_index-1)*goods_num+p,:)));
                if goods_differ1==0
                   goods_common=1;
                end
         end
         if(goods_common == 1)
             new_goods_assignment(dimen_row, dimen_list) = originValue;
         end
         end
     end
     newpop((i-1)*goods_num+1 : i*goods_num,:) = new_goods_assignment;
end
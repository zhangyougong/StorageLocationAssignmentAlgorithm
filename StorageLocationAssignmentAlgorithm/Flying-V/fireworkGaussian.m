function [newpop] = fireworkGaussian(pop, goods_num, gaussianNum, dim)
popsize = length(pop)./goods_num;
newpop = zeros(gaussianNum*goods_num ,4);
lowerBound = 1;
for i=1:gaussianNum
     firework_index = ceil(rand()*popsize); % 选中的火花标号
     gauss = normrnd(1, 1);  % 均值为1 方差为1 的高斯函数
     %dimens_select = ceil(rand()*dim);  % 从D维度里选出Z个维度
     dimens_select = 1;
     origin_goods_assignment = pop((firework_index-1)*goods_num+1 : firework_index*goods_num,:); 
     new_goods_assignment = origin_goods_assignment; %% 这里应该取出旧的个体
     for k = 1 : dimens_select
         goods_common = 1;
         while(goods_common == 1) 
                goods_common = 0;
         rand_dimen = ceil(rand()*dim); % 从D维度里选出1个维度
         dimen_row = ceil(rand_dimen/4);  %  第几行
         dimen_list = rand_dimen - (dimen_row-1) * 4; % 第几列 
         originValue = origin_goods_assignment(dimen_row, dimen_list);
         nowValue = round(originValue*gauss); % 现在的值
         if(nowValue>getUpperBound(origin_goods_assignment(dimen_row, :), dimen_list))   %% 获取上界
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
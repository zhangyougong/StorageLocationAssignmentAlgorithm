function [newpop] = fireworkExplode(pop, explode_radius, explode_num, goods_num,firework_num, dim)
newpop = [];
lowerBound = 1;
firework_index = 0;
% 每个烟花都产生新的烟花
for i = 1: firework_num
    % 产生的烟花个数
    for j = 1 : explode_num(i)
        dimens_select = ceil(rand()*dim);  % 从D维度里选出Z个维度
        offset = round(((rand()*2)-1)*explode_radius(i));  % 计算当前烟花的偏移量
        origin_goods_assignment = pop((i-1)*goods_num+1 : i*goods_num,:); 
        new_goods_assignment = origin_goods_assignment; %% 这里应该取出旧的个体
        for k = 1 : dimens_select
            goods_common = 1;
            while(goods_common == 1) 
                goods_common = 0;
            rand_dimen = ceil(rand()*dim); % 从D维度里选出1个维度
            dimen_row = ceil(rand_dimen/4);  %  第几行
            dimen_list = rand_dimen - (dimen_row-1) * 4; % 第几列 
            originValue = origin_goods_assignment(dimen_row, dimen_list);
            nowValue = originValue + offset; % 现在的值
            if(nowValue>getUpperBound(origin_goods_assignment(dimen_row, :), dimen_list))   %% 获取上界
                nowValue = getUpperBound(origin_goods_assignment(dimen_row, :), dimen_list);
            elseif (nowValue<lowerBound)
                nowValue = lowerBound;
            end
            new_goods_assignment(dimen_row, dimen_list) = nowValue;
            for p =1:goods_num
                if(dimen_row == p) 
                    continue;
                end
                goods_differ1=sum(~(new_goods_assignment(dimen_row,:)==pop((i-1)*goods_num+p,:)));
                if goods_differ1==0
                   goods_common=1;
                end
            end
            if(goods_common == 1)
                new_goods_assignment(dimen_row, dimen_list) = originValue;
            end
            end
        end
        firework_index = firework_index + 1; % 火花数 + 1
        newpop((firework_index-1)*goods_num+1 : firework_index*goods_num,:) = new_goods_assignment;
    end
end



function [newpop]=fireworkSelection(pop,goods_num, popsize, bestindividual_current)
%选择或复制操作决定哪些个体可以进入下一代。赌轮盘选择法。结合资料书P307页
originPopsize = length(pop)./goods_num;
distance = zeros(originPopsize, 1);
for i = 1: originPopsize
    for j = 1: originPopsize
       distance(i) = distance(i) + dist_E(pop((i-1)*goods_num+1: i*goods_num, :), pop((j-1)*goods_num+1: j*goods_num, :));
    end
end

totalDistance=sum(distance); % 求适应度之和
newpop=zeros(popsize, 4);

% STEP1 最佳保留
newpop(1:goods_num,:) = bestindividual_current;
% STEP2 剩下轮盘赌法
selectionRatio=distance/totalDistance;%单个个体被选择的概率
if totalDistance==0
    disp('error')
end   
selectionRatio1=cumsum(selectionRatio); %如果fitvalue=[1 2 3 4],则cumsum(fitvalue)=[1 3 6 10]
ms=sort(rand(popsize-1,1));%从小到大排列  生成px行1列的0到1之间的随机数矩阵，并且从小到大排列

fitin=1;
newin=2;
while newin<=popsize
    if(ms(newin-1))<=selectionRatio1(fitin)
        newpop((newin-1)*goods_num+1:newin*goods_num,:)=pop((fitin-1)*goods_num+1:fitin*goods_num,:);
        newin=newin+1;
    else
        fitin=fitin+1;
    end
end
end


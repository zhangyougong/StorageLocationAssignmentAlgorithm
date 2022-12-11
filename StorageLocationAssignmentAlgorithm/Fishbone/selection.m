function [newpop]=selection(pop,fitvalue,popsize,goods_num,q,generation )
%选择或复制操作决定哪些个体可以进入下一代。赌轮盘选择法。结合资料书P307页
fitvalue2=zeros(1,popsize);
fitvalue_max=max(fitvalue);
fitvalue_min=min(fitvalue);
for i=1:popsize
 fitvalue2(i)=fitvalue(i)+((exp(1)-exp(q./generation))./(exp(1)+exp(q./generation)))*(fitvalue_max-fitvalue_min);
end
fitvalue=fitvalue2;
totalfit=sum(fitvalue);%求适应度之和
newpop=zeros(size(pop));
fitvalue1=fitvalue;
fitvalue1=fitvalue1/totalfit;%单个个体被选择的概率
if totalfit==0
    disp('error')
end   
fitvalue1=cumsum(fitvalue1); %如果fitvalue=[1 2 3 4],则cumsum(fitvalue)=[1 3 6 10]
ms=sort(rand(popsize,1));%从小到大排列  生成px行1列的0到1之间的随机数矩阵，并且从小到大排列
fitin=1;
newin=1;
while newin<popsize+1
    if(ms(newin))<=fitvalue1(fitin)
        newpop((newin-1)*goods_num+1:newin*goods_num,:)=pop((fitin-1)*goods_num+1:fitin*goods_num,:);
        newin=newin+1;
    else
        fitin=fitin+1;
    end
end
end


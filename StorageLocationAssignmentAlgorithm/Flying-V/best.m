function [best_number,bestindividual_current,bestfit_current] = best(pop,fitvalue,popsize,goods_num)
%求出群体中适应值最大的值
bestindividual_current=pop(1:goods_num,:);
bestfit_current=fitvalue(1);
best_number=1;
for i=2:popsize
    if fitvalue(i)>bestfit_current
        bestfit_current=fitvalue(i);
        best_number=i;
        bestindividual_current=pop((i-1)*goods_num+1:i*goods_num,:);
    end
end
end
